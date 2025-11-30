package com.example.badogosShop.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.*;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Null;
import javax.validation.constraints.Size;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "product")
@Getter
@Setter
@ToString
@NoArgsConstructor

public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "name")
    @NotNull
    private String name;

    @Column(name = "description")
    @NotNull
    private String description;

    @Column(name = "price")
    @NotNull
    @Size(max = 7)
    private Integer price;

    @Column(name = "discount")
    @NotNull
    @Size(max = 2)
    private Integer discount;

    @Column(name = "created_at")
    private Date createdAt;

    @Column(name = "updated_at")
    @Null
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    @Null
    private LocalDateTime deletedAt;

    @Column(name = "is_deleted")
    private Boolean isDeleted = false;

    @Column(name = "amount")
    @NotNull
    private Integer amount;

    @Column(name = "stock_keeping_unit")
    @NotNull
    @Size(max = 255)
    private String stockKeepingUnit;

    @OneToOne(cascade = {})
    @JoinColumn(name = "detail_id")
    private Details detail;

    @ManyToOne(cascade = {})
    @JoinColumn(name = "brand_id")
    private Brand brand;

    @OneToOne(cascade = {})
    @JoinColumn(name = "image_path_id")
    private ProductImages images;

    @OneToMany(mappedBy = "product", fetch = FetchType.LAZY, cascade = {})
    private List<Review> productReviewList;

    @OneToMany(mappedBy = "orderProduct", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnore
    private List<OrderProduct> orderHistoryList;

    @ManyToMany(fetch = FetchType.LAZY, cascade = {}, mappedBy = "productList")
    @JsonIgnoreProperties({"productList"})
    private List<Category> categories;

    @OneToMany(mappedBy = "cartProduct", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnore
    private List<CartProduct> cartProductList;

}
