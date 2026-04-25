package com.example.badogosShop.dto;

import java.time.LocalDateTime;

public record UserResponse(
        Integer id,
        String email,
        String firstName,
        String lastName,
        String phoneNumber,
        String pfpPath,
        LocalDateTime lastLogin,
        String role
) {
}
