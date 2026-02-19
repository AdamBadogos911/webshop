package com.example.badogosShop.repository;

import com.example.badogosShop.entity.Category;
import com.example.badogosShop.entity.Product;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;

import java.util.List;

public interface ProductRepository extends JpaRepository<Product, Integer> {

    Page<Product> findByCategory(Category category, Pageable pageable);

    @Procedure(name = "getMostViewedProducts", procedureName = "getMostViewedProducts")
    List<Product> getMostViewedProducts();
}
