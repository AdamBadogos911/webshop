package com.example.badogosShop.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record OrderRequest(
        @NotNull @Size(min = 1, max = 100) String firstName,
        @NotNull @Size(min = 1, max = 100) String lastName,
        @NotNull String phone,
        @NotNull @Size(max = 100) String email,
        @NotNull Integer paymentMethodId,
        Integer userId,
        @NotNull @Valid BillingDetailDto billingDetail,
        @NotNull @Valid TransportDetailDto transportDetail
) { }
