package com.example.badogosShop.repository;

import com.example.badogosShop.entity.Cart;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface CartRepository extends JpaRepository<Cart, Integer> {

    @Procedure(name = "getCartByUserId", procedureName = "getCartByUserId")
    Optional<Cart> getCartByUserId(@Param("idIN") Integer cartId);

    @Procedure(name = "clearCart", procedureName = "clearCart")
    void clearCart(@Param("idIN") Integer cartId);
}

