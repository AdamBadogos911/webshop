package com.example.badogosShop.repository;

import com.example.badogosShop.entity.OrderProduct;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OrderProductRepository extends JpaRepository<OrderProduct, Integer> {
}