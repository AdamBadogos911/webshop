package com.example.badogosShop.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

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
@NamedStoredProcedureQueries({
        @NamedStoredProcedureQuery(name = "getMostViewedProducts", procedureName = "getMostViewedProducts", resultClasses = Product.class),
        @NamedStoredProcedureQuery(name = "getOrderedProductOfMonth", procedureName = "getOrderedProductOfMonth", parameters = {
                @StoredProcedureParameter(name = "monthNumber", mode = ParameterMode.IN, type = Integer.class)
        }, resultClasses = Integer.class),
        @NamedStoredProcedureQuery(name = "getProductById", procedureName = "getProductById", parameters = {
                @StoredProcedureParameter(name = "idIN", mode = ParameterMode.IN, type = Integer.class)
        }, resultClasses = Product.class),

        @NamedStoredProcedureQuery(name = "searchProduct", procedureName = "searchProduct", parameters = {
                @StoredProcedureParameter(name = "searchTerm", mode = ParameterMode.IN, type = String.class)
        }, resultClasses = Product.class)
})
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "stock_keeping_unit", unique = true)
    @NotNull
    private String stockKeepingUnit;

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

    @Column(name = "view_count")
    private Long viewCount;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "detail_id")
    private Details detail;

    @ManyToOne
    @JoinColumn(name = "brand_id")
    private Brand brand;

    @OneToMany(mappedBy = "product")
    private List<ProductImages> images;

    @OneToMany(mappedBy = "product")
    @JsonIgnore
    private List<Review> productReviewList;

    @OneToMany(mappedBy = "orderProduct", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnore
    private List<OrderProduct> orderHistoryList;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    @JsonIgnoreProperties({"productList"})
    private Category category;

    @OneToMany(mappedBy = "cartProduct", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnore
    private List<CartProduct> cartProductList;

    public Product(String name, Brand brand, Integer amount, Integer price, Details detail, String stockKeepingUnit, String description, Category category) {
        this.name = name;
        this.brand = brand;
        this.amount = amount;
        this.price = price;
        this.detail = detail;
        this.stockKeepingUnit = stockKeepingUnit;
        this.isDeleted = false;
        this.description = description;
        this.category = category;
    }

}

