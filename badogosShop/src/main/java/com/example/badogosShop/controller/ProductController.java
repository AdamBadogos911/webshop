package com.example.badogosShop.controller;

import com.example.badogosShop.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.awt.print.Pageable;

@RestController
@RequestMapping("/product")
@RequiredArgsConstructor

public class ProductController {

    private ProductService productService;

    @GetMapping("/category/{id}")
        public ResponseEntity<Object> getProductByCategory(Pageable pageable, @PathVariable("id") Integer categoryId) {
            return productService.getProductCategory(pageable, categoryId);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Object> deleteProduct(@PathVariable("id") Integer id) {
        return productService.deleteProduct(id);
    }

    @GetMapping("")
    public ResponseEntity<Object> getAllProduct(Pageable pageable) {
        return productService.getAllProduct(pageable);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Object> getProductById(@PathVariable("id") Integer id) {
        return productService.getProductById(id);
    }

}
