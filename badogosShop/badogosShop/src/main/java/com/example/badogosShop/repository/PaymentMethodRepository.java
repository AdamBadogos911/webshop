package com.example.badogosShop.repository;

import com.example.badogosShop.entity.PaymentMethod;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PaymentMethodRepository extends JpaRepository<PaymentMethod, Integer> {
}