package com.example.badogosShop.controller;

import com.example.badogosShop.entity.Review;
import com.example.badogosShop.service.ReviewService;
import com.fasterxml.jackson.databind.JsonNode;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/review")
@RequiredArgsConstructor
public class ReviewController {

    private final ReviewService reviewService;

    @PostMapping
    private ResponseEntity<Object> addReview(@RequestBody Review newReview) {
        return reviewService.addReview(newReview);
    }

    @PutMapping
    private ResponseEntity<Object> updateReview(@RequestBody JsonNode updatedReview) {
        return reviewService.updateReview(updatedReview.get("id").asInt(0), updatedReview.get("reviewText").asText(null));
    }

    @DeleteMapping("/{id}")
    private ResponseEntity<Object> deleteReview(@PathVariable("id") Integer id) {
        return reviewService.deleteReview(id);
    }

    @GetMapping("/user/{id}")
    private ResponseEntity<Object> getReviewsByUser(@PathVariable("id") Integer id) {
        return reviewService.gerReviewByUser(id);
    }

    @GetMapping("/product/{id}")
    private ResponseEntity<Object> getReviewByProduct(@PathVariable("id") Integer id) {
        return reviewService.getReviewByProductId(id);
    }
}

