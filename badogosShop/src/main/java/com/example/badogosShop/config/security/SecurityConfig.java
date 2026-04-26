package com.example.badogosShop.config.security;

import com.example.badogosShop.config.security.JWT.JWTGeneratorFilter;
import com.example.badogosShop.config.security.JWT.JWTValidatorFilter;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
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
import org.springframework.security.crypto.argon2.Argon2PasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.www.BasicAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;

import java.util.Arrays;
import java.util.Collections;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(jsr250Enabled = true)
@RequiredArgsConstructor
public class SecurityConfig {

    private final JWTGeneratorFilter jwtGeneratorFilter;
    private final JWTValidatorFilter jwtValidatorFilter;
    private final UserSetter userSetter;

    @Bean
    SecurityFilterChain defaultSecurityFilterChain(HttpSecurity http) throws Exception {
        http
                .cors(corsCustomizer -> corsCustomizer.configurationSource(new CorsConfigurationSource() {
                    @Override
                    public CorsConfiguration getCorsConfiguration(HttpServletRequest request) {
                        CorsConfiguration config = new CorsConfiguration();
                        config.setAllowedOrigins(Collections.singletonList("http://localhost:4200"));
                        config.setAllowedMethods(Collections.singletonList("*"));
                        config.setAllowedHeaders(Collections.singletonList("*"));
                        config.setAllowCredentials(true);
                        config.setExposedHeaders(Arrays.asList("Authorization", "Bearer ", "refreshToken"));
                        config.setMaxAge(3600L);
                        return config;
                    }
                }))
                .authorizeHttpRequests((requests) -> requests
                        .requestMatchers("/cart", "/cart/**").authenticated()
                        .requestMatchers("/category/main", "/category/main/**").permitAll()
                        .requestMatchers("/category", "/category/*").authenticated()
                        .requestMatchers("/order/statistic").hasRole("admin")
                        .requestMatchers("/order/**").authenticated()
                        .requestMatchers("/paymentMethods", "/addressType", "/brand").permitAll()
                        .requestMatchers("/product/category/*").permitAll()
                        .requestMatchers(HttpMethod.DELETE, "/product/*").hasRole("admin")
                        .requestMatchers(HttpMethod.GET, "/product").hasRole("admin")
                        .requestMatchers(HttpMethod.POST, "/product").hasRole("admin")
                        .requestMatchers(HttpMethod.GET, "/product/*").permitAll()
                        .requestMatchers(HttpMethod.PUT, "/product/*").hasRole("admin")
                        .requestMatchers("/product/search", "/product/mostViewed").permitAll()
                        .requestMatchers("/review/product/*").permitAll()
                        .requestMatchers("/review", "/review/**").authenticated()
                        .requestMatchers("/user/login", "/user/register", "/user/vCode", "/user/check", "/user/password").permitAll()
                        .requestMatchers("/user", "/user/**").authenticated()

                        .requestMatchers("/images/pfp/**", "/images/products/*").permitAll()
                )
                .addFilterAfter(jwtGeneratorFilter, BasicAuthenticationFilter.class)
                .addFilterBefore(jwtValidatorFilter, BasicAuthenticationFilter.class)
                .authenticationProvider(authProvider())
                .formLogin(f -> f.disable())
                .csrf(crs -> crs.disable())
                .httpBasic(Customizer.withDefaults());

        return http.build();
    }

    @Bean
    PasswordEncoder passwordEncoder() {
        return new Argon2PasswordEncoder(16, 32, 1, 1 << 12, 3);
    }

    @Bean
    AuthenticationProvider authProvider() {
        DaoAuthenticationProvider authenticationProvider = new DaoAuthenticationProvider(userSetter);
        authenticationProvider.setPasswordEncoder(passwordEncoder());

        return authenticationProvider;
    }
}
