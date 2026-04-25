package com.example.badogosShop.dto;

public record ProductDto(
        String name,
        Integer brandId,
        Integer amount,
        Integer price,
        Double weightInKg,
        String material,
        Double lengthInCm,
        Double heightInCm,
        Double widthInCm,
        String size,
        Boolean isSet,
        String stockKeepingUnit,
        String description,
        Integer categoryId
) {
}

