package com.example.badogosShop.config.security.JWT;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.example.badogosShop.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class JWTService {
    private final UserRepository userRepository;
    private static final String AUTH = "auth";
    private static final String TOKEN_TYPE = "tokenType";
    private static final String ACCESS_TOKEN_TYPE = "access";
    private static final String REFRESH_TOKEN_TYPE = "refresh";
    private static final long DEFAULT_ACCESS_TOKEN_EXPIRY = 900_000L;
    private static final long DEFAULT_REFRESH_TOKEN_EXPIRY = 7_200_000L;
    private static final String DEFAULT_ISSUER = "badogosShop";
    private final JWTProperties jwtProperties;

    public String createJwtToken(UserDetails principal) {
        com.example.badogosShop.entity.User loggedUsers = userRepository.findByEmail(principal.getUsername()).orElseThrow(() -> new UsernameNotFoundException("User not found"));

        return createToken(loggedUsers.getEmail(), principal.getAuthorities(), getAccessTokenExpiry(), ACCESS_TOKEN_TYPE);
    }

    public String createRefreshToken(UserDetails principal) {
        com.example.badogosShop.entity.User loggedUser = userRepository.findByEmail(principal.getUsername()).orElseThrow(() -> new UsernameNotFoundException("User not found"));

        return createToken(loggedUser.getEmail(), principal.getAuthorities(), getRefreshTokenExpiry(), REFRESH_TOKEN_TYPE);
    }

    public UserDetails parseJwt(String jwtToken) {
        DecodedJWT jwt = verifyToken(jwtToken, ACCESS_TOKEN_TYPE);
        return new User(jwt.getSubject(), "dummy", jwt.getClaim(AUTH).asList(String.class).stream().map(SimpleGrantedAuthority::new).collect(Collectors.toList()));
    }

    public UserDetails parseRefreshToken(String refreshToken) {
        DecodedJWT jwt = verifyToken(refreshToken, REFRESH_TOKEN_TYPE);
        com.example.badogosShop.entity.User loggedUser = userRepository.findByEmail(jwt.getSubject()).orElseThrow(() -> new UsernameNotFoundException("User not found"));
        if (Boolean.TRUE.equals(loggedUser.getIsDeleted())) {
            throw new UsernameNotFoundException("User not found");
        }

        String roleName = loggedUser.getRole() != null && loggedUser.getRole().getName() != null
                ? loggedUser.getRole().getName()
                : "ROLE_user";
        List<GrantedAuthority> authorities = List.of(new SimpleGrantedAuthority(roleName));
        return new User(loggedUser.getEmail(), loggedUser.getPassword(), authorities);
    }

    public String regenerateJwtToken(String refreshTokenValue) {
        if (refreshTokenValue == null || refreshTokenValue.isBlank()) {
            return null;
        }

        return createJwtToken(parseRefreshToken(refreshTokenValue));
    }

    private String createToken(String subject, Collection<? extends GrantedAuthority> authorities, long expiry, String tokenType) {
        return JWT.create()
                .withSubject(subject)
                .withArrayClaim(AUTH, authorities.stream().map(GrantedAuthority::getAuthority).toArray(String[]::new))
                .withClaim(TOKEN_TYPE, tokenType)
                .withExpiresAt(new Date(System.currentTimeMillis() + expiry))
                .withIssuer(getIssuer())
                .sign(Algorithm.HMAC256(getSecret()));
    }

    private DecodedJWT verifyToken(String token, String expectedType) {
        DecodedJWT jwt = JWT.require(Algorithm.HMAC256(getSecret()))
                .withIssuer(getIssuer())
                .build()
                .verify(token);

        if (!expectedType.equals(jwt.getClaim(TOKEN_TYPE).asString())) {
            throw new IllegalArgumentException("Invalid token type");
        }

        return jwt;
    }

    private String getSecret() {
        return Optional.ofNullable(jwtProperties.getSecret())
                .filter(secret -> !secret.isBlank())
                .orElseThrow(() -> new IllegalStateException("JWT secret is not configured"));
    }

    private String getIssuer() {
        return Optional.ofNullable(jwtProperties.getIssuer())
                .filter(issuer -> !issuer.isBlank())
                .orElse(DEFAULT_ISSUER);
    }

    private long getAccessTokenExpiry() {
        return Optional.ofNullable(jwtProperties.getExpiredTime()).orElse(DEFAULT_ACCESS_TOKEN_EXPIRY);
    }

    private long getRefreshTokenExpiry() {
        return Optional.ofNullable(jwtProperties.getRefreshExpiredTime()).orElse(DEFAULT_REFRESH_TOKEN_EXPIRY);
    }
}
