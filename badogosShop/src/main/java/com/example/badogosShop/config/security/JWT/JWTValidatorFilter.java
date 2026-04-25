package com.example.badogosShop.config.security.JWT;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;

@Component
@RequiredArgsConstructor
public class JWTValidatorFilter extends OncePerRequestFilter {

    private final JWTService jwtService;
    private static final String AUTHORIZATION = "Authorization";
    private static final String REFRESH_TOKEN = "refreshToken";
    private static final String BEARER = "Bearer ";

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        String header = request.getHeader(AUTHORIZATION);
        if (header != null && header.startsWith(BEARER)) {
            String jwt = header.substring(BEARER.length()).trim();
            UserDetails principal = null;
            try {
                principal = jwtService.parseJwt(jwt);
            } catch (Exception e) {
                String refreshToken = request.getHeader(REFRESH_TOKEN);
                if (refreshToken != null && !refreshToken.isBlank()) {
                    try {
                        principal = jwtService.parseRefreshToken(refreshToken);
                        String newJwt = jwtService.createJwtToken(principal);
                        response.setHeader(AUTHORIZATION, BEARER + newJwt);
                        response.setHeader(REFRESH_TOKEN, jwtService.createRefreshToken(principal));
                    } catch (Exception ignored) {
                        SecurityContextHolder.clearContext();
                    }
                }
            }

            if (principal != null) {
                UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(principal, null, principal.getAuthorities());
                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(authentication);
            }
        }

        filterChain.doFilter(request, response);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) throws ServletException {
        List<String> allowedUrlPaths = List.of(
                "/user/register",
                "/user/login"
        );

        return allowedUrlPaths.contains(request.getServletPath());
    }
}