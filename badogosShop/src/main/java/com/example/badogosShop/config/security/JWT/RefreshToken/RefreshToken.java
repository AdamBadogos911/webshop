package com.example.badogosShop.config.security.JWT.RefreshToken;

import lombok.*;

import java.time.Instant;

@Getter
@Setter
@AllArgsConstructor
@ToString
@NoArgsConstructor
public class RefreshToken {

    private Long id;
    private String email;
    private String tokenValue;
    private Instant expiredDate;

    public RefreshToken(String email, String tokenValue, Instant expiredDate) {
        this.email = email;
        this.tokenValue = tokenValue;
        this.expiredDate = expiredDate;
    }
}