package com.example.badogosShop.service;

import com.example.badogosShop.entity.Product;
import com.example.badogosShop.entity.Review;
import com.example.badogosShop.entity.User;
import com.example.badogosShop.repository.ProductRepository;
import com.example.badogosShop.repository.ReviewRepository;
import com.example.badogosShop.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.validation.ConstraintViolationException;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
@Transactional(noRollbackFor = {DataIntegrityViolationException.class, ConstraintViolationException.class, SQLIntegrityConstraintViolationException.class, SQLException.class})
public class ReviewService {

    private final ReviewRepository reviewRepository;
    private final UserRepository userRepository;
    private final ProductRepository productRepository;

    public ResponseEntity<Object> addReview(Review newReview) {
        try {
            if (newReview == null) {
                return ResponseEntity.status(422).build();
            }

            Product searchedProduct = productRepository.findById(newReview.getProduct().getId()).orElse(null);
            User author = userRepository.getUserById(newReview.getAuthor().getId()).orElse(null);

            if (searchedProduct == null || searchedProduct.getIsDeleted()) {
                return ResponseEntity.status(404).body("bookNotFound");
            } else if (author == null || author.getIsDeleted()) {
                return ResponseEntity.status(404).body("authorNotFound");
            }

            if (newReview.getRating() > 5 || newReview.getRating() < 1) {
                return ResponseEntity.status(415).body("invalidRating");
            } else if (newReview.getId() != null) {
                return ResponseEntity.status(415).body("invalidObject");
            }

            return ResponseEntity.ok().body(reviewRepository.save(newReview));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    public ResponseEntity<Object> updateReview(Integer reviewId, String updatedText) {
        try {
            if (reviewId == 0 || updatedText == null) {
                return ResponseEntity.status(422).build();
            }

            Review searchedReview = reviewRepository.findById(reviewId).orElse(null);
            if (searchedReview == null || searchedReview.getIsDeleted()) {
                return ResponseEntity.notFound().build();
            }
            searchedReview.setReviewText(updatedText.trim());

            return ResponseEntity.ok().body(reviewRepository.save(searchedReview));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    public ResponseEntity<Object> deleteReview(Integer id) {
        try {
            if (id == null) {
                return ResponseEntity.status(422).build();
            }
            Review searchedReview = reviewRepository.findById(id).orElse(null);
            if (searchedReview == null || searchedReview.getIsDeleted()) {
                return ResponseEntity.notFound().build();
            }

            searchedReview.setIsDeleted(true);
            searchedReview.setDeletedAt(LocalDateTime.now());
            reviewRepository.save(searchedReview);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    public ResponseEntity<Object> getReviewByProductId(Integer id) {
        try {
            if (id == null) {
                return ResponseEntity.status(422).build();
            }

            Product searchedProduct = productRepository.findById(id).orElse(null);
            if (searchedProduct == null || searchedProduct.getIsDeleted()) {
                return ResponseEntity.notFound().build();
            } else {
                return ResponseEntity.ok().body(searchedProduct.getProductReviewList().stream().filter(review -> !review.getIsDeleted()));
            }

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    public ResponseEntity<Object> gerReviewByUser(Integer id) {
        try {
            if (id == null) {
                return ResponseEntity.status(422).build();
            }
            User searchedUser = userRepository.findById(id).orElse(null);
            if (searchedUser == null || searchedUser.getIsDeleted()) {
                return ResponseEntity.notFound().build();
            } else {
                return ResponseEntity.ok().body(searchedUser.getReviewList().stream().filter(review -> !review.getIsDeleted()));
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }
}
