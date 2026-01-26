package com.example.badogosShop.controller;

import com.example.badogosShop.entity.Category;
import com.example.badogosShop.service.CategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController()
@RequestMapping("/category")
@RequiredArgsConstructor

public class CategoryController {

    private final CategoryService categoryService;

    @GetMapping("/main")
    public ResponseEntity<Object> getAllMainCategory() {
        return categoryService.getAllMainCategory();
    }

    @GetMapping("/main/{id}/sub")
    public ResponseEntity<Object> getAllSubCategoryOfMainCategory(@PathVariable("id") Integer mainCategoryId) {
        return categoryService.getAllSubCategoryFromMainCategory(mainCategoryId);
    }

    @PostMapping("")
    public ResponseEntity<Object> addCategory(@RequestBody Category newCategory) {
        return categoryService.addCategory(newCategory);
    }

    @PutMapping("")
    public ResponseEntity<Object> updateCategory(@RequestBody Category updatedCategory) {
        return categoryService.updateCategory((updatedCategory));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Object> deleteCategory(@PathVariable("id") Integer categoryId) {
        return categoryService.deleteCategory(categoryId);
    }

}
