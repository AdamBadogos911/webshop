package com.example.badogosShop.repository;

import com.example.badogosShop.entity.OrderHistory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface OrderHistoryRepository extends JpaRepository<OrderHistory, Integer> {

    Optional<OrderHistory> findByOrderId(Integer orderId);
}