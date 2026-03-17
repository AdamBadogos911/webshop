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
import tools.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;

@Component
@RequiredArgsConstructor
public class JWTValidatorFilter extends OncePerRequestFilter {

    private final JWTService jwtService;
    private static final String AUTHORIZATION = "Authorization";
    private static final String BEARER = "Bearer";
    private final ObjectMapper mapper;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        String header = request.getHeader(AUTHORIZATION);
        System.out.println("header: " + header);
        if (header != null && header.startsWith(BEARER)) {
            String jwt = header.substring(BEARER.length());
            System.out.println(jwt);
            UserDetails principal;
            try {
                principal = jwtService.parseJwt(jwt);
            } catch (Exception e) {
                String newJwt = jwtService.regenerateJwtToken(request.getHeader("refreshToken"));
                principal = jwtService.parseJwt(newJwt);
                response.setHeader("Bearer ", newJwt);
            }

            UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(principal, null, principal.getAuthorities());
            authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
            SecurityContextHolder.getContext().setAuthentication(authentication);
        }

        filterChain.doFilter(request, response);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) throws ServletException {
        System.out.println(request.getServletPath());
        ArrayList<String> allowedUrlPaths = new ArrayList<String>(Arrays.asList(
                "/user/register",
                "/user/login"
        ));

        return allowedUrlPaths.contains(request.getServletPath());
    }
}