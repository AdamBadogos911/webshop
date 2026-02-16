package com.example.badogosShop.service;

import com.example.badogosShop.entity.Category;
import com.example.badogosShop.entity.Product;
import com.example.badogosShop.repository.CategoryRepository;
import com.example.badogosShop.repository.ProductRepository;

import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.validation.ConstraintViolationException;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
@Transactional(noRollbackFor = {DataIntegrityViolationException.class, ConstraintViolationException.class, SQLIntegrityConstraintViolationException.class, SQLException.class})
public class ProductService {
    private final CategoryRepository categoryRepository;
    private final ProductRepository productRepository;

    public ResponseEntity<Object> getProductsByCategory(Pageable pageable, Integer categoryId) {
        try {
            Category searchedCategory = categoryRepository.findById(categoryId).orElse(null);
            if (searchedCategory == null || searchedCategory.getIsDeleted()) {
                return ResponseEntity.notFound().build();
            }
            Page<Product> pages = productRepository.findByCategory(searchedCategory, pageable);
            HttpHeaders header = new HttpHeaders();
            header.add("TotalPage", pages.getTotalPages() + "");

            return new ResponseEntity<>(pages.toList(), header, HttpStatus.OK);
        } catch (RuntimeException e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }

    }

    public ResponseEntity<Object> deleteProduct(Integer id) {
        try {
            Product searchedProduct = productRepository.findById(id).orElse(null);
            if (searchedProduct == null || searchedProduct.getIsDeleted()) {
                return ResponseEntity.notFound().build();
            }

            searchedProduct.setIsDeleted(true);
            searchedProduct.setDeletedAt(LocalDateTime.now());
            productRepository.save(searchedProduct);

            return ResponseEntity.ok().build();

        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    public ResponseEntity<Object> getAllProduct(Pageable pageable) {
        try {
            Page<Product> pages = productRepository.findAll(pageable);
            HttpHeaders header = new HttpHeaders();
            header.add("TotalPage", pages.getTotalPages() + "");

            return new ResponseEntity<>(pages.toList(), header, HttpStatus.OK);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    public ResponseEntity<Object> getProductById(Integer id) {
        try {
            Product searchedProduct = productRepository.findById(id).orElse(null);
            if (searchedProduct == null || searchedProduct.getIsDeleted()) {
                return ResponseEntity.notFound().build();
            }
            return ResponseEntity.ok().body(searchedProduct);
        } catch (RuntimeException e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    public ResponseEntity<Object> addProduct() {
        return null;
    }

    public ResponseEntity<Object> updateProduct() {
        return null;
    }
}