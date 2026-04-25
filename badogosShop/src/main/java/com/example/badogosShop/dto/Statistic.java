package com.example.badogosShop.dto;

import java.util.List;

public record Statistic(
        Long income,
        Long numberOfOrder,
        Long averageOrderedPrice,
        Long numberOfSoldProduct
) {
}
