package com.example.badogosShop.controller;

import com.example.badogosShop.dto.CategoryRequest;
import com.example.badogosShop.service.CategoryService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/category")
@RequiredArgsConstructor
public class CategoryController {

    private final CategoryService categoryService;

    @GetMapping("/main")
    public ResponseEntity<?> getAllMainCategory() {
        return ResponseEntity.ok(categoryService.getAllMainCategory());
    }

    @GetMapping("/main/{id}/sub")
    public ResponseEntity<?> getAllSubCategoryOfMainCategory(@PathVariable("id") Integer mainCategoryId) {
        return ResponseEntity.ok(categoryService.getAllSubCategoryFromMainCategory(mainCategoryId));
    }

    @PostMapping
    @PreAuthorize("hasRole('admin')")
    public ResponseEntity<?> addCategory(@Valid @RequestBody CategoryRequest request) {
        return ResponseEntity.ok(categoryService.addCategory(request));
    }

    @PutMapping
    @PreAuthorize("hasRole('admin')")
    public ResponseEntity<?> updateCategory(@Valid @RequestBody CategoryRequest request) {
        return ResponseEntity.ok(categoryService.updateCategory(request));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('admin')")
    public ResponseEntity<?> deleteCategory(@PathVariable("id") Integer categoryId) {
        categoryService.deleteCategory(categoryId);
        return ResponseEntity.ok().build();
    }

    @GetMapping
    public ResponseEntity<?> getAllCategory() {
        return ResponseEntity.ok(categoryService.getAllCategory());
    }
}