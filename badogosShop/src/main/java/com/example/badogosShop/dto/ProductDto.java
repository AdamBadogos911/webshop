package com.example.badogosShop.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;
import jakarta.validation.constraints.Size;

public record ProductDto(
        @NotNull @Size(min = 1, max = 255) String name,
        @NotNull Integer brandId,
        @NotNull @PositiveOrZero Integer amount,
        @NotNull @Positive Integer price,
        Double weightInKg,
        String material,
        Double lengthInCm,
        Double heightInCm,
        Double widthInCm,
        String size,
        Boolean isSet,
        @NotNull @Size(max = 255) String stockKeepingUnit,
        @NotNull String description,
        @NotNull Integer categoryId
) {
}