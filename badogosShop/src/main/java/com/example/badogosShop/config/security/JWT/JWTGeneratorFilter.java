package com.example.badogosShop.config.security.JWT;

import com.example.badogosShop.config.security.JWT.RefreshToken.RefreshToken;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import tools.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Base64;
import java.util.UUID;

@Component
@RequiredArgsConstructor
public class JWTGeneratorFilter extends OncePerRequestFilter {

    private final JWTService jwtService;
    private final ObjectMapper mapper;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        Authentication givenAuthentication = SecurityContextHolder.getContext().getAuthentication();
        System.out.println("Generálás");

        if (givenAuthentication != null) {
            System.out.println("givenAuthentication != null");
            UserDetails principal = (UserDetails) givenAuthentication.getPrincipal();
            String jwt = jwtService.createJwtToken((UserDetails) givenAuthentication.getPrincipal());
            System.out.println(jwt);
            response.setHeader("Bearer ", jwt);
            System.out.println(generateRefreshToken(principal.getUsername()));
            response.setHeader("refreshToken", generateRefreshToken(principal.getUsername()));
        }

        filterChain.doFilter(request, response);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) throws ServletException {
        return !request.getServletPath().equals("/user/login");
    }

    private String generateRefreshToken(String email){
        RefreshToken refreshToken = new RefreshToken(email, UUID.randomUUID().toString(), Instant.now().plusMillis(7200000));

        try {
            String refreshTokenAsString = mapper.writeValueAsString(refreshToken);
            return Base64.getUrlEncoder().encodeToString(refreshTokenAsString.getBytes(StandardCharsets.UTF_8));
        } catch (Exception e) {
            System.out.println("Ajjajmeg");
            return null;
        }
    }
}
