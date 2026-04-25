package com.example.badogosShop.repository;

import com.example.badogosShop.entity.CartProduct;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

public interface CartProductRepository extends JpaRepository<CartProduct, Integer> {

    @Procedure(name = "deleteProductFromCart", procedureName = "deleteProductFromCart")
    void deleteProductFromCart(@Param("idIN") Integer productId);
}