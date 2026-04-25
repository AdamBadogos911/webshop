package com.example.badogosShop.config.security.JWT;

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

import java.io.IOException;

@Component
@RequiredArgsConstructor
public class JWTGeneratorFilter extends OncePerRequestFilter {

    private static final String AUTHORIZATION = "Authorization";
    private static final String REFRESH_TOKEN = "refreshToken";
    private static final String BEARER = "Bearer ";

    private final JWTService jwtService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        Authentication givenAuthentication = SecurityContextHolder.getContext().getAuthentication();
        if (givenAuthentication != null && givenAuthentication.getPrincipal() instanceof UserDetails principal) {
            String jwt = jwtService.createJwtToken(principal);
            response.setHeader(AUTHORIZATION, BEARER + jwt);
            response.setHeader(REFRESH_TOKEN, jwtService.createRefreshToken(principal));
        }

        filterChain.doFilter(request, response);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) throws ServletException {
        return !request.getServletPath().equals("/user/login");
    }
}

