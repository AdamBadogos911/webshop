package com.example.badogosShop.controller;

import com.example.badogosShop.service.ProductService;
import lombok.RequiredArgsConstructor;

import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/product")
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productService;

    @GetMapping("/category/{id}")
    public ResponseEntity<Object> getProductsByCategory(Pageable pageable, @PathVariable("id") Integer categoryId) {
        return productService.getProductsByCategory(pageable, categoryId);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Object> deleteProduct(@PathVariable("id") Integer id) {
        return productService.deleteProduct(id);
    }

    @GetMapping
    public ResponseEntity<Object> getAllProduct(Pageable pageable) {
        return productService.getAllProduct(pageable);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Object> getProductById(@PathVariable("id") Integer id) {
        return productService.getProductById(id);
    }

    @GetMapping("/mostViewed")
    public ResponseEntity<Object> getMostViewedProducts() {
        return productService.getMostViewedProducts();
    }
}

