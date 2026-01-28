package com.example.badogosShop.repository;

import com.example.badogosShop.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface CategoryRepository extends JpaRepository<Category, Integer> {

    @Procedure(name = "getMainCategory", procedureName = "getMainCategory")
    List<Category> getAllMainCategory();

    @Procedure(name = "getSubCatByPrimCat", procedureName = "getSubCatByPrimCat")
    List<Category> getAllSubCategoryFromMainCategory(@Param("primCategoryIdIn") Integer mainCategoryId);

}