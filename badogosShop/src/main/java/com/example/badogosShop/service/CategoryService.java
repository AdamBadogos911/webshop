package com.example.badogosShop.service;

import com.example.badogosShop.entity.Category;
import com.example.badogosShop.repository.CategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.validation.ConstraintViolationException;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(noRollbackFor = {DataIntegrityViolationException.class, ConstraintViolationException.class, SQLIntegrityConstraintViolationException.class, SQLException.class})
public class CategoryService {
    private final CategoryRepository categoryRepository;

    public ResponseEntity<Object> getAllCategory() {
        return null;
    }

    public ResponseEntity<Object> addCategory(Category newCategory) {
        try {
            if (newCategory == null) {
                return ResponseEntity.status(422).build();
            }

            if (newCategory.getId() != null) {
                return ResponseEntity.status(415).body("invalidBrand");
            } else {
                return ResponseEntity.ok().body(categoryRepository.save(newCategory));
            }

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    public ResponseEntity<Object> updateCategory(Category updatedCategory) {
        try {
            if (updatedCategory == null) {
                return ResponseEntity.status(422).build();
            }

            if (updatedCategory.getId() == null) {
                return ResponseEntity.status(415).body("invalidObject");
            } else {
                return ResponseEntity.ok().body(categoryRepository.save(updatedCategory));
            }

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    public ResponseEntity<Object> deleteCategory(Integer id) {
        try {
            if (id == null) {
                return ResponseEntity.status(422).build();
            }

            Category searchedBrand = categoryRepository.findById(id).orElse(null);
            if (searchedBrand == null) {
                return ResponseEntity.notFound().build();
            } else {

                return ResponseEntity.ok().build();
            }

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    public ResponseEntity<Object> getAllMainCategory() {
        try {
            return ResponseEntity.ok().body(categoryRepository.getAllMainCategory());
        } catch (RuntimeException e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    public ResponseEntity<Object> getAllSubCategoryFromMainCategory(Integer mainCategoryId) {
        try {
            System.out.println(mainCategoryId);
            Category searchedMainCategory = categoryRepository.findById(mainCategoryId).orElse(null);
            if (searchedMainCategory == null || searchedMainCategory.getIsDeleted()) {
                return ResponseEntity.notFound().build();
            }
            List<Category> subCategories = categoryRepository.getAllSubCategoryFromMainCategory(mainCategoryId);
            return ResponseEntity.ok().body(subCategories);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }
}