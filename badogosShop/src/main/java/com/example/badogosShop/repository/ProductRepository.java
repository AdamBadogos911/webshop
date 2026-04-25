package com.example.badogosShop.repository;

import com.example.badogosShop.entity.Category;
import com.example.badogosShop.entity.Product;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ProductRepository extends JpaRepository<Product, Integer> {

    Page<Product> findByCategoryAndIsDeletedFalse(Category category, Pageable pageable);

    @Procedure(name = "getMostViewedProducts", procedureName = "getMostViewedProducts")
    List<Product> getMostViewedProducts();

    @Procedure(name = "getOrderedProductOfMonth", procedureName = "getOrderedProductOfMonth")
    List<Integer> getOrderedProductOfMonth(@Param("monthNumber") Integer monthNumber);

    @Procedure(name = "getProductById", procedureName = "getProductById")
    Optional<Product> getProductById(@Param("idIN") Integer id);

    /**
     * Atomi viewCount növelés – hatékonyabb, mint a teljes entitás betöltés + mentés.
     * Nem tölti be az entitást, nem rontja a cache konzisztenciát.
     */
    @Modifying
    @Query("UPDATE Product p SET p.viewCount = COALESCE(p.viewCount, 0) + 1 WHERE p.id = :id")
    void incrementViewCount(@Param("id") Integer id);
}