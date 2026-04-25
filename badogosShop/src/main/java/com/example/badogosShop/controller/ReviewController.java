package com.example.badogosShop.controller;

import com.example.badogosShop.dto.ReviewCreateRequest;
import com.example.badogosShop.service.ReviewService;
import com.fasterxml.jackson.databind.JsonNode;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/review")
@RequiredArgsConstructor
public class ReviewController {

    private final ReviewService reviewService;

    @PostMapping
    public ResponseEntity<?> addReview(@Valid @RequestBody ReviewCreateRequest request) {
        return ResponseEntity.ok(reviewService.addReview(request));
    }

    @PutMapping
    public ResponseEntity<?> updateReview(@RequestBody JsonNode updatedReview) {
        Integer id = updatedReview != null && updatedReview.has("id") ? updatedReview.get("id").asInt(0) : 0;
        String reviewText = updatedReview != null && updatedReview.has("reviewText") ? updatedReview.get("reviewText").asText(null) : null;
        return ResponseEntity.ok(reviewService.updateReview(id, reviewText));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteReview(@PathVariable("id") Integer id) {
        reviewService.deleteReview(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/user/{id}")
    public ResponseEntity<?> getReviewsByUser(@PathVariable("id") Integer id) {
        return ResponseEntity.ok(reviewService.getReviewsByUser(id));
    }

    @GetMapping("/product/{id}")
    public ResponseEntity<?> getReviewsByProduct(@PathVariable("id") Integer id) {
        return ResponseEntity.ok(reviewService.getReviewsByProductId(id));
    }
}
