package com.example.badogosShop.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record BillingDetailDto(
        @NotNull Integer addressTypeId,
        @NotNull @Min(1000) @Max(9999) Integer postCode,
        @NotNull @Size(max = 100) String town,
        @NotNull @Size(max = 100) String address,
        @NotNull @Min(1) @Max(999) Integer houseNumber,
        @Size(max = 100) String companyName,
        Long taxNumber,
        String other
) { }
