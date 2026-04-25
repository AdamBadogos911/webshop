package com.example.badogosShop.controller;

import com.example.badogosShop.dto.ProductDto;
import com.example.badogosShop.dto.ProductResponse;
import com.example.badogosShop.service.ProductService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/product")
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productService;

    @GetMapping("/category/{id}")
    public ResponseEntity<?> getProductsByCategory(Pageable pageable, @PathVariable("id") Integer categoryId) {
        Page<ProductResponse> pages = productService.getProductsByCategory(pageable, categoryId);
        HttpHeaders header = new HttpHeaders();
        header.add("TotalPage", String.valueOf(pages.getTotalPages()));
        header.add("TotalElements", String.valueOf(pages.getTotalElements()));
        return ResponseEntity.ok().headers(header).body(pages.getContent());
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('admin')")
    public ResponseEntity<?> deleteProduct(@PathVariable("id") Integer id) {
        productService.deleteProduct(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping
    public ResponseEntity<?> getAllProducts() {
        return ResponseEntity.ok(productService.getAllProducts());
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getProductById(@PathVariable("id") Integer id) {
        return ResponseEntity.ok(productService.getProductById(id));
    }

    @GetMapping("/mostViewed")
    public ResponseEntity<?> getMostViewedProducts() {
        return ResponseEntity.ok(productService.getMostViewedProducts());
    }

    @PostMapping
    @PreAuthorize("hasRole('admin')")
    public ResponseEntity<?> addProduct(@Valid @RequestBody ProductDto product) {
        return ResponseEntity.ok(productService.addProduct(product));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('admin')")
    public ResponseEntity<?> updateProduct(@PathVariable("id") Integer id, @Valid @RequestBody ProductDto updatedProduct) {
        return ResponseEntity.ok(productService.updateProduct(id, updatedProduct));
    }

    @GetMapping("/statistic/{month}")
    @PreAuthorize("hasRole('admin')")
    public ResponseEntity<?> getStatistic(@PathVariable("month") Integer monthNumber) {
        return ResponseEntity.ok(productService.getStatistic(monthNumber));
    }
}