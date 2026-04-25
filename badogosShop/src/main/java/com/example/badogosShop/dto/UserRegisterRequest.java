package com.example.badogosShop.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record UserRegisterRequest(
        @NotNull @Size(max = 255) String email,
        @NotNull String password,
        @NotNull @Size(min = 1, max = 100) String firstName,
        @NotNull @Size(min = 1, max = 100) String lastName,
        @Size(max = 30) String phoneNumber
) { }
