package com.example.badogosShop.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;
import java.util.Date;

@Entity
@Table(name = "cart_product")
@Getter
@Setter
@ToString(exclude = {"cartProduct", "cart"})
@NoArgsConstructor
@NamedStoredProcedureQueries({
        @NamedStoredProcedureQuery(name = "deleteProductFromCart", procedureName = "deleteProductFromCart", parameters = {
                @StoredProcedureParameter(name = "idIN", mode = ParameterMode.IN, type = Integer.class)
        })
})
public class CartProduct {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "last_modified_at")
    private LocalDateTime lastModifiedAt;

    @Column(name = "created_at")
    private Date createdAt;

    @Column(name = "amount")
    @NotNull
    private Integer amount;

    @Column(name = "is_deleted")
    private Boolean isDeleted = false;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    @ManyToOne(cascade = {})
    @JoinColumn(name = "product_id")
    @JsonIgnoreProperties({"productReviewList"})
    private Product cartProduct;

    @ManyToOne(cascade = {})
    @JoinColumn(name = "cart_id")
    private Cart cart;

    public CartProduct(Integer amount, Product cartProduct, Cart cart) {
        this.amount = amount;
        this.cartProduct = cartProduct;
        this.cart = cart;
    }
}
