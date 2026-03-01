package com.example.badogosShop.dto;

import java.util.List;

public record Statistic(
        List<Integer> soldProductIds,
        Integer income,
        Integer numberOfOrder,
        Integer averageOrderedPrice
) {
}
