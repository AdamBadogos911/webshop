package com.example.badogosShop.config.security;

import com.example.badogosShop.config.security.JWT.JWTGeneratorFilter;
import com.example.badogosShop.config.security.JWT.JWTValidatorFilter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.argon2.Argon2PasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.www.BasicAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    @Value("${app.cors.allowed-origins:http://localhost:4200}")
    private String allowedOrigins;

    @Bean
    @Profile("prod")
    SecurityFilterChain defaultSecurityFilterChain(HttpSecurity http,
                                                   JWTGeneratorFilter jwtGeneratorFilter,
                                                   JWTValidatorFilter jwtValidatorFilter,
                                                   AuthenticationProvider authProvider) throws Exception {
        CorsConfigurationSource corsSource = request -> {
            CorsConfiguration config = createBaseCorsConfig();
            config.setAllowedOrigins(List.of(allowedOrigins.split(",")));
            config.setAllowCredentials(true);
            return config;
        };

        return buildSecurityChain(http, jwtGeneratorFilter, jwtValidatorFilter, authProvider, corsSource,
                "/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html", "/actuator/health");
    }

    @Bean
    @Profile("dev")
    SecurityFilterChain devSecurityFilter(HttpSecurity http,
                                          JWTGeneratorFilter jwtGeneratorFilter,
                                          JWTValidatorFilter jwtValidatorFilter,
                                          AuthenticationProvider authProvider) throws Exception {
        CorsConfigurationSource corsSource = request -> {
            CorsConfiguration config = createBaseCorsConfig();
            config.setAllowedOrigins(Collections.singletonList("*"));
            config.setAllowCredentials(false);
            return config;
        };

        return buildSecurityChain(http, jwtGeneratorFilter, jwtValidatorFilter, authProvider, corsSource,
                "/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html", "/actuator/**");
    }

    /**
     * Közös Security chain konfiguráció — a prod és dev profil között csak a CORS és az actuator engedélyezés különbözik.
     */
    private SecurityFilterChain buildSecurityChain(HttpSecurity http,
                                                   JWTGeneratorFilter jwtGeneratorFilter,
                                                   JWTValidatorFilter jwtValidatorFilter,
                                                   AuthenticationProvider authProvider,
                                                   CorsConfigurationSource corsSource,
                                                   String... publicPaths) throws Exception {
        http
                .cors(cors -> cors.configurationSource(corsSource))
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(requests ->
                        requests
                                .requestMatchers("/user/login", "/user/register", "/user/verificationCode", "/user/check", "/user/password").permitAll()
                                .requestMatchers(publicPaths).permitAll()
                                .requestMatchers(HttpMethod.GET, "/product/**", "/category/**", "/brand", "/paymentMethods", "/addressType", "/review/**", "/pfp/**", "/products/**").permitAll()
                                .anyRequest().authenticated()
                )
                .addFilterAfter(jwtGeneratorFilter, BasicAuthenticationFilter.class)
                .addFilterBefore(jwtValidatorFilter, BasicAuthenticationFilter.class)
                .authenticationProvider(authProvider)
                .formLogin(AbstractHttpConfigurer::disable)
                .csrf(AbstractHttpConfigurer::disable)
                .httpBasic(Customizer.withDefaults());

        return http.build();
    }

    private CorsConfiguration createBaseCorsConfig() {
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowedMethods(Collections.singletonList("*"));
        config.setAllowedHeaders(Collections.singletonList("*"));
        config.setExposedHeaders(Arrays.asList("Authorization", "refreshToken", "TotalPage", "TotalElements"));
        config.setMaxAge(3600L);
        return config;
    }

    @Bean
    PasswordEncoder passwordEncoder() {
        return new Argon2PasswordEncoder(16, 32, 1, 1 << 14, 3);
    }

    @Bean
    AuthenticationProvider authProvider(UserSetter userSetter, PasswordEncoder passwordEncoder) {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider(userSetter);
        provider.setPasswordEncoder(passwordEncoder);
        return provider;
    }

    @Bean
    FilterRegistrationBean<JWTGeneratorFilter> jwtGeneratorFilterRegistration(JWTGeneratorFilter filter) {
        FilterRegistrationBean<JWTGeneratorFilter> registration = new FilterRegistrationBean<>(filter);
        registration.setEnabled(false);
        return registration;
    }

    @Bean
    FilterRegistrationBean<JWTValidatorFilter> jwtValidatorFilterRegistration(JWTValidatorFilter filter) {
        FilterRegistrationBean<JWTValidatorFilter> registration = new FilterRegistrationBean<>(filter);
        registration.setEnabled(false);
        return registration;
    }
}
