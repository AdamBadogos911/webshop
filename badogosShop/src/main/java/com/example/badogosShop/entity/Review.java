package com.example.badogosShop.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;
import java.util.Date;

@Entity
@Table(name = "review")
@Getter
@Setter
@ToString(exclude = {"product", "author"})
@NoArgsConstructor
public class Review {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "review_text")
    @NotNull
    private String reviewText;

    @Column(name = "rate")
    @NotNull
    @Min(1)
    @Max(5)
    private Integer rating;

    @Column(name = "created_at")
    private Date createdAt;

    @Column(name = "is_deleted")
    private Boolean isDeleted = false;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @ManyToOne()
    @JoinColumn(name = "product_id")
    @JsonIgnoreProperties({"brand", "images", "productReviewList", "orderHistoryList", "category", "cartProductList"})
    private Product product;

    @ManyToOne(cascade = {})
    @JoinColumn(name = "user_id")
    @JsonIgnoreProperties({"cart", "savedDetails", "orderHistoryList", "reviewList"})
    private User author;
}
