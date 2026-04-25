package com.example.badogosShop.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.time.LocalDateTime;
import java.util.Date;

@Entity
@Table(name = "order_product")
@Getter
@Setter
@ToString(exclude = {"orderProduct", "orderHistory"})
@NoArgsConstructor
public class OrderProduct {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "created_at")
    private Date createdAt;

    @Column(name = "modified_at")
    private LocalDateTime modifiedAt;

    @Column(name = "amount")
    @NotNull
    private Integer amount;

    @ManyToOne(cascade = {})
    @JoinColumn(name = "product_id")
    @JsonIgnoreProperties({"productReviewList", "cartProductList"})
    private Product orderProduct;

    @ManyToOne(cascade = {})
    @JoinColumn(name = "order_id")
    private OrderHistory orderHistory;

    public OrderProduct(Integer amount, Product orderProduct) {
        this.orderProduct = orderProduct;
        this.amount = amount;
    }
}
