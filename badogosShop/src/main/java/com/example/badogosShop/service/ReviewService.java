package com.example.badogosShop.service;

import com.example.badogosShop.config.security.SecurityUtils;
import com.example.badogosShop.dto.ReviewCreateRequest;
import com.example.badogosShop.dto.ReviewResponse;
import com.example.badogosShop.entity.Product;
import com.example.badogosShop.entity.Review;
import com.example.badogosShop.entity.User;
import com.example.badogosShop.exception.BusinessValidationException;
import com.example.badogosShop.exception.ForbiddenOperationException;
import com.example.badogosShop.exception.ResourceNotFoundException;
import com.example.badogosShop.repository.ProductRepository;
import com.example.badogosShop.repository.ReviewRepository;
import com.example.badogosShop.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class ReviewService {

    private final ReviewRepository reviewRepository;
    private final UserRepository userRepository;
    private final ProductRepository productRepository;
    private final SecurityUtils securityUtils;

    // Fix #26: Ellenőrizzük, hogy a bejelentkezett felhasználó saját nevében ír értékelést
    public ReviewResponse addReview(ReviewCreateRequest request) {
        Product product = productRepository.findById(request.productId()).orElse(null);
        if (product == null || Boolean.TRUE.equals(product.getIsDeleted())) {
            throw new ResourceNotFoundException("productNotFound");
        }

        User author = userRepository.findById(request.authorId()).orElse(null);
        if (author == null || Boolean.TRUE.equals(author.getIsDeleted())) {
            throw new ResourceNotFoundException("authorNotFound");
        }

        // Fix #26: Jogosultság ellenőrzés – csak saját névben lehet értékelést írni
        if (!securityUtils.canAccessUser(author)) {
            throw new ForbiddenOperationException();
        }

        Review review = new Review();
        review.setReviewText(request.reviewText());
        review.setRating(request.rating());
        review.setProduct(product);
        review.setAuthor(author);
        // Fix #20: createdAt beállítása
        review.setCreatedAt(new Date());
        return ReviewResponse.fromEntity(reviewRepository.save(review));
    }

    // Fix #5: Jogosultság ellenőrzés – csak a szerző vagy admin módosíthat
    public ReviewResponse updateReview(Integer reviewId, String updatedText) {
        if (reviewId == null || reviewId == 0 || updatedText == null) {
            throw new BusinessValidationException("invalidInput");
        }
        Review searchedReview = reviewRepository.findById(reviewId).orElse(null);
        if (searchedReview == null || Boolean.TRUE.equals(searchedReview.getIsDeleted())) {
            throw new ResourceNotFoundException("reviewNotFound");
        }

        // Jogosultság ellenőrzés
        if (searchedReview.getAuthor() != null && !securityUtils.canAccessUser(searchedReview.getAuthor())) {
            throw new ForbiddenOperationException();
        }

        searchedReview.setReviewText(updatedText.trim());
        searchedReview.setUpdatedAt(LocalDateTime.now());
        return ReviewResponse.fromEntity(reviewRepository.save(searchedReview));
    }

    // Fix #5: Jogosultság ellenőrzés – csak a szerző vagy admin törölhet
    public void deleteReview(Integer id) {
        Review searchedReview = reviewRepository.findById(id).orElse(null);
        if (searchedReview == null || Boolean.TRUE.equals(searchedReview.getIsDeleted())) {
            throw new ResourceNotFoundException("reviewNotFound");
        }

        // Jogosultság ellenőrzés
        if (searchedReview.getAuthor() != null && !securityUtils.canAccessUser(searchedReview.getAuthor())) {
            throw new ForbiddenOperationException();
        }

        searchedReview.setIsDeleted(true);
        searchedReview.setDeletedAt(LocalDateTime.now());
        reviewRepository.save(searchedReview);
    }

    @Transactional(readOnly = true)
    public List<ReviewResponse> getReviewsByProductId(Integer id) {
        Product product = productRepository.findById(id).orElse(null);
        if (product == null || Boolean.TRUE.equals(product.getIsDeleted())) {
            throw new ResourceNotFoundException("productNotFound");
        }
        return product.getProductReviewList().stream()
                .filter(review -> !Boolean.TRUE.equals(review.getIsDeleted()))
                .map(ReviewResponse::fromEntity)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<ReviewResponse> getReviewsByUser(Integer id) {
        User user = userRepository.findById(id).orElse(null);
        if (user == null || Boolean.TRUE.equals(user.getIsDeleted())) {
            throw new ResourceNotFoundException("userNotFound");
        }
        return user.getReviewList().stream()
                .filter(review -> !Boolean.TRUE.equals(review.getIsDeleted()))
                .map(ReviewResponse::fromEntity)
                .toList();
    }
}