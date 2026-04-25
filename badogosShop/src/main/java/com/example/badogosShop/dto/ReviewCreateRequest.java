package com.example.badogosShop.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public record ReviewCreateRequest(
        @NotNull String reviewText,
        @NotNull @Min(1) @Max(5) Integer rating,
        @NotNull Integer productId,
        @NotNull Integer authorId
) { }
