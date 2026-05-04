package com.example.badogosShop.service;

import com.example.badogosShop.dto.ProductDto;
import com.example.badogosShop.entity.Brand;
import com.example.badogosShop.entity.Category;
import com.example.badogosShop.entity.Details;
import com.example.badogosShop.entity.Product;
import com.example.badogosShop.repository.BrandRepository;
import com.example.badogosShop.repository.CategoryRepository;
import com.example.badogosShop.repository.ProductRepository;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.concurrent.ThreadLocalRandom;

@Service
@RequiredArgsConstructor
@Transactional
public class ProductService {
    private final CategoryRepository categoryRepository;
    private final ProductRepository productRepository;
    private final BrandRepository brandRepository;

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

    public ResponseEntity<Object> getAllProduct() {
        try {
            return ResponseEntity.ok(productRepository.findAll().stream().filter(p -> !p.getIsDeleted()).toList());
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
            searchedProduct.setViewCount(searchedProduct.getViewCount() + 1);
            productRepository.save(searchedProduct);

            return ResponseEntity.ok().body(searchedProduct);
        } catch (RuntimeException e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    public ResponseEntity<Object> getMostViewedProducts() {
        try {
            return ResponseEntity.ok().body(productRepository.getMostViewedProducts());
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    public ResponseEntity<Object> addProduct(ProductDto newProductDto) {
        Brand searchedBrand = brandRepository.getBrandById(newProductDto.brandId()).orElse(null);
        if (searchedBrand == null || searchedBrand.getIsDeleted()) {
            return ResponseEntity.status(404).body("brandNotFound");
        }

        Category searchedCategory = categoryRepository.findById(newProductDto.categoryId()).orElse(null);
        if (searchedCategory == null || searchedCategory.getIsDeleted()) {
            return ResponseEntity.status(404).body("categoryNotFound");
        }

        Product newProduct = new Product(
                newProductDto.name(),
                searchedBrand,
                newProductDto.amount(),
                newProductDto.price(),
                new Details(newProductDto.weightInKg(), newProductDto.material(), newProductDto.lengthInCm(), newProductDto.heightInCm(), newProductDto.widthInCm(), newProductDto.size(), newProductDto.isSet()),
                newProductDto.stockKeepingUnit(),
                newProductDto.description(),
                searchedCategory
        );

        Product savedProduct = productRepository.save(newProduct);

        String randomPart = String.format("%08d", ThreadLocalRandom.current().nextInt(0, 100_000_000));
        savedProduct.setStockKeepingUnit(randomPart + savedProduct.getId());

        return ResponseEntity.ok().body(productRepository.save(savedProduct));
    }

    public ResponseEntity<Object> updateProduct(Integer id, ProductDto updatedProductDto) {
        Product searchedProduct = productRepository.getProductById(id).orElse(null);
        if (searchedProduct == null || searchedProduct.getIsDeleted()) {
            return ResponseEntity.status(404).body("productNotFound");
        }

        Brand searchedBrand = brandRepository.getBrandById(updatedProductDto.brandId()).orElse(null);
        if (searchedBrand == null || searchedBrand.getIsDeleted()) {
            return ResponseEntity.status(404).body("brandNotFound");
        }

        Category searchedCategory = categoryRepository.findById(updatedProductDto.categoryId()).orElse(null);
        if (searchedCategory == null || searchedCategory.getIsDeleted()) {
            return ResponseEntity.status(404).body("categoryNotFound");
        }

        searchedProduct.setName(updatedProductDto.name());
        searchedProduct.setBrand(searchedBrand);
        searchedProduct.setAmount(updatedProductDto.amount());
        searchedProduct.setPrice(updatedProductDto.price());
        searchedProduct.setDetail(new Details(searchedProduct.getDetail().getId() ,updatedProductDto.weightInKg(), updatedProductDto.material(), updatedProductDto.lengthInCm(), updatedProductDto.heightInCm(), updatedProductDto.widthInCm(), updatedProductDto.size(), updatedProductDto.isSet(), searchedProduct));
        searchedProduct.setStockKeepingUnit(updatedProductDto.stockKeepingUnit());
        searchedProduct.setDescription(updatedProductDto.description());
        searchedProduct.setCategory(searchedCategory);

        return ResponseEntity.ok().body(productRepository.save(searchedProduct));
    }

    public ResponseEntity<Object> getProductBySearch(String searchTerm) {
        return ResponseEntity.ok().body(productRepository.searchProduct(searchTerm));
    }
}