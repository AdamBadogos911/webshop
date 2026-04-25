package com.example.badogosShop.dto;

import com.example.badogosShop.entity.Review;

import java.time.LocalDateTime;
import java.util.Date;

public record ReviewResponse(
        Integer id,
        String reviewText,
        Integer rating,
        Date createdAt,
        LocalDateTime updatedAt,
        Integer productId,
        String productName,
        Integer authorId,
        String authorName
) {
    public static ReviewResponse fromEntity(Review r) {
        return new ReviewResponse(
                r.getId(),
                r.getReviewText(),
                r.getRating(),
                r.getCreatedAt(),
                r.getUpdatedAt(),
                r.getProduct() != null ? r.getProduct().getId() : null,
                r.getProduct() != null ? r.getProduct().getName() : null,
                r.getAuthor() != null ? r.getAuthor().getId() : null,
                r.getAuthor() != null ? (r.getAuthor().getFirstName() + " " + r.getAuthor().getLastName()) : null
        );
    }
}
