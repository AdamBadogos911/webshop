package com.example.badogosShop.repository;

import com.example.badogosShop.entity.Brand;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface BrandRepository extends JpaRepository<Brand, Integer> {

    @Procedure(name = "getAllBrand", procedureName = "getAllBrand")
    List<Brand> getAllBrand();

    @Procedure(name = "getBrandById", procedureName = "getBrandById")
    Optional<Brand> getBrandById(@Param("idIN") Integer id);
}