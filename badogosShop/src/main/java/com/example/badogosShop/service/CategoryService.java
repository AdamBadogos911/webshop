package com.example.badogosShop.service;

import com.example.badogosShop.dto.CategoryRequest;
import com.example.badogosShop.entity.Category;
import com.example.badogosShop.exception.BusinessValidationException;
import com.example.badogosShop.exception.ResourceNotFoundException;
import com.example.badogosShop.repository.CategoryRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class CategoryService {
    private final CategoryRepository categoryRepository;

    @Cacheable("categories")
    @Transactional(readOnly = true)
    public List<Category> getAllCategory() {
        return categoryRepository.findAll().stream()
                .filter(c -> !Boolean.TRUE.equals(c.getIsDeleted()))
                .toList();
    }

    @CacheEvict(cacheNames = {"categories", "mainCategories", "subCategories"}, allEntries = true)
    public Category addCategory(CategoryRequest request) {
        if (request.id() != null) {
            throw new BusinessValidationException("invalidCategory");
        }
        Category category = new Category();
        category.setName(request.name());

        // Fix: mainCategoryId kezelése – alkategória létrehozás támogatása
        if (request.mainCategoryId() != null) {
            Category mainCategory = categoryRepository.findById(request.mainCategoryId()).orElse(null);
            if (mainCategory == null || Boolean.TRUE.equals(mainCategory.getIsDeleted())) {
                throw new ResourceNotFoundException("mainCategoryNotFound");
            }
            category.setMainCategory(mainCategory);
        }

        return categoryRepository.save(category);
    }

    @CacheEvict(cacheNames = {"categories", "mainCategories", "subCategories"}, allEntries = true)
    public Category updateCategory(CategoryRequest request) {
        if (request.id() == null) {
            throw new BusinessValidationException("invalidObject");
        }
        Category existing = categoryRepository.findById(request.id()).orElse(null);
        if (existing == null || Boolean.TRUE.equals(existing.getIsDeleted())) {
            throw new ResourceNotFoundException("categoryNotFound");
        }
        existing.setName(request.name());

        // Fix: mainCategoryId kezelése – kategória áthelyezés támogatása
        if (request.mainCategoryId() != null) {
            Category mainCategory = categoryRepository.findById(request.mainCategoryId()).orElse(null);
            if (mainCategory == null || Boolean.TRUE.equals(mainCategory.getIsDeleted())) {
                throw new ResourceNotFoundException("mainCategoryNotFound");
            }
            existing.setMainCategory(mainCategory);
        } else {
            existing.setMainCategory(null);
        }

        return categoryRepository.save(existing);
    }

    @CacheEvict(cacheNames = {"categories", "mainCategories", "subCategories"}, allEntries = true)
    public void deleteCategory(Integer id) {
        Category searchedCategory = categoryRepository.findById(id).orElse(null);
        if (searchedCategory == null || Boolean.TRUE.equals(searchedCategory.getIsDeleted())) {
            throw new ResourceNotFoundException("categoryNotFound");
        }
        searchedCategory.setIsDeleted(true);
        searchedCategory.setDeletedAt(LocalDateTime.now());
        categoryRepository.save(searchedCategory);
    }

    @Cacheable("mainCategories")
    @Transactional(readOnly = true)
    public List<Category> getAllMainCategory() {
        return categoryRepository.getAllMainCategory();
    }

    @Cacheable(value = "subCategories", key = "#mainCategoryId")
    @Transactional(readOnly = true)
    public List<Category> getAllSubCategoryFromMainCategory(Integer mainCategoryId) {
        Category searchedMainCategory = categoryRepository.findById(mainCategoryId).orElse(null);
        if (searchedMainCategory == null || Boolean.TRUE.equals(searchedMainCategory.getIsDeleted())) {
            throw new ResourceNotFoundException("categoryNotFound");
        }
        return categoryRepository.getAllSubCategoryFromMainCategory(mainCategoryId);
    }
}