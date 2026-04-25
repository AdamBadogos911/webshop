package com.example.badogosShop.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record CategoryRequest(
        Integer id,
        @NotNull @Size(min = 1, max = 255) String name,
        Integer mainCategoryId
) { }
