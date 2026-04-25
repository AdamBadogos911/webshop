package com.example.badogosShop.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record UserUpdate(
        @NotNull @Size(min = 1, max = 100) String firstName,
        @NotNull @Size(min = 1, max = 100) String lastName,
        @NotNull @Size(max = 255) String email,
        @Size(max = 30) String phoneNumber
) { }
