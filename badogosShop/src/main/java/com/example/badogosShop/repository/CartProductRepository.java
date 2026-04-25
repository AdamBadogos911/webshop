package com.example.badogosShop.repository;

import com.example.badogosShop.entity.Cart;
import com.example.badogosShop.entity.CartProduct;
import com.example.badogosShop.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface CartProductRepository extends JpaRepository<CartProduct, Integer> {

    @Procedure(name = "deleteProductFromCart", procedureName = "deleteProductFromCart")
    void deleteProductFromCart(@Param("idIN") Integer productId);

    @Query("SELECT cp FROM CartProduct cp WHERE cp.cart = :cart AND cp.cartProduct = :product AND (cp.isDeleted = false OR cp.isDeleted IS NULL)")
    Optional<CartProduct> findActiveByCartAndProduct(@Param("cart") Cart cart, @Param("product") Product product);
}