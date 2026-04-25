package com.example.badogosShop.service;

import com.example.badogosShop.dto.ProductDto;
import com.example.badogosShop.dto.ProductResponse;
import com.example.badogosShop.dto.Statistic;
import com.example.badogosShop.entity.Brand;
import com.example.badogosShop.entity.Category;
import com.example.badogosShop.entity.Details;
import com.example.badogosShop.exception.BusinessValidationException;
import com.example.badogosShop.exception.ResourceNotFoundException;
import com.example.badogosShop.repository.BrandRepository;
import com.example.badogosShop.repository.CategoryRepository;
import com.example.badogosShop.repository.ProductRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class ProductService {
    private final CategoryRepository categoryRepository;
    private final ProductRepository productRepository;
    private final BrandRepository brandRepository;

    @Transactional(readOnly = true)
    public Page<ProductResponse> getProductsByCategory(Pageable pageable, Integer categoryId) {
        Category searchedCategory = categoryRepository.findById(categoryId).orElse(null);
        if (searchedCategory == null || Boolean.TRUE.equals(searchedCategory.getIsDeleted())) {
            throw new ResourceNotFoundException("categoryNotFound");
        }
        // Fix #16: Soft-deleted termékek szűrése
        return productRepository.findByCategoryAndIsDeletedFalse(searchedCategory, pageable)
                .map(ProductResponse::fromEntity);
    }

    @CacheEvict(cacheNames = {"allProducts", "mostViewedProducts"}, allEntries = true)
    public void deleteProduct(Integer id) {
        com.example.badogosShop.entity.Product searchedProduct = productRepository.findById(id).orElse(null);
        if (searchedProduct == null || Boolean.TRUE.equals(searchedProduct.getIsDeleted())) {
            throw new ResourceNotFoundException("productNotFound");
        }
        searchedProduct.setIsDeleted(true);
        searchedProduct.setDeletedAt(LocalDateTime.now());
        productRepository.save(searchedProduct);
    }

    @Cacheable("allProducts")
    @Transactional(readOnly = true)
    public List<ProductResponse> getAllProducts() {
        return productRepository.findAll().stream()
                .filter(p -> !Boolean.TRUE.equals(p.getIsDeleted()))
                .map(ProductResponse::fromEntity)
                .toList();
    }

    public ProductResponse getProductById(Integer id) {
        com.example.badogosShop.entity.Product searchedProduct = productRepository.findById(id).orElse(null);
        if (searchedProduct == null || Boolean.TRUE.equals(searchedProduct.getIsDeleted())) {
            throw new ResourceNotFoundException("productNotFound");
        }
        // Atomi viewCount növelés — hatékonyabb, mint a teljes entitás betöltés + mentés
        productRepository.incrementViewCount(id);
        // Frissített viewCount betöltése a válaszba
        long updatedViewCount = (searchedProduct.getViewCount() != null ? searchedProduct.getViewCount() : 0L) + 1;
        searchedProduct.setViewCount(updatedViewCount);
        return ProductResponse.fromEntity(searchedProduct);
    }

    // Fix #12: getMostViewedProducts DTO-t ad vissza entitás helyett
    @Cacheable("mostViewedProducts")
    @Transactional(readOnly = true)
    public List<ProductResponse> getMostViewedProducts() {
        return productRepository.getMostViewedProducts().stream()
                .filter(p -> !Boolean.TRUE.equals(p.getIsDeleted()))
                .map(ProductResponse::fromEntity)
                .toList();
    }

    // Fix #10/#29: getStatistic – discount figyelembe vétele
    @Transactional(readOnly = true)
    public Statistic getStatistic(Integer monthNumber) {
        if (monthNumber == null || monthNumber < 1 || monthNumber > 12) {
            throw new BusinessValidationException("invalidMonthNumber");
        }
        List<Integer> orderedProductOfMonth = productRepository.getOrderedProductOfMonth(monthNumber);

        int income = 0;
        for (Integer productId : orderedProductOfMonth) {
            com.example.badogosShop.entity.Product product = productRepository.findById(productId).orElse(null);
            if (product != null) {
                int discount = product.getDiscount() != null ? product.getDiscount() : 0;
                int discountedPrice = product.getPrice() * (100 - discount) / 100;
                income += discountedPrice;
            }
        }

        return new Statistic(
                orderedProductOfMonth,
                income,
                orderedProductOfMonth.size(),
                orderedProductOfMonth.isEmpty() ? 0 : income / orderedProductOfMonth.size()
        );
    }

    @CacheEvict(cacheNames = {"allProducts", "mostViewedProducts"}, allEntries = true)
    public ProductResponse addProduct(ProductDto newProductDto) {
        Brand searchedBrand = brandRepository.getBrandById(newProductDto.brandId()).orElse(null);
        if (searchedBrand == null || Boolean.TRUE.equals(searchedBrand.getIsDeleted())) {
            throw new ResourceNotFoundException("brandNotFound");
        }
        Category searchedCategory = categoryRepository.findById(newProductDto.categoryId()).orElse(null);
        if (searchedCategory == null || Boolean.TRUE.equals(searchedCategory.getIsDeleted())) {
            throw new ResourceNotFoundException("categoryNotFound");
        }

        com.example.badogosShop.entity.Product newProduct = new com.example.badogosShop.entity.Product(
                newProductDto.name(),
                searchedBrand,
                newProductDto.amount(),
                newProductDto.price(),
                new Details(newProductDto.weightInKg(), newProductDto.material(), newProductDto.lengthInCm(), newProductDto.heightInCm(), newProductDto.widthInCm(), newProductDto.size(), newProductDto.isSet()),
                newProductDto.stockKeepingUnit(),
                newProductDto.description(),
                searchedCategory);

        return ProductResponse.fromEntity(productRepository.save(newProduct));
    }

    @CacheEvict(cacheNames = {"allProducts", "mostViewedProducts"}, allEntries = true)
    public ProductResponse updateProduct(Integer id, ProductDto updatedProduct) {
        com.example.badogosShop.entity.Product searchedProduct = productRepository.getProductById(id).orElse(null);
        if (searchedProduct == null || Boolean.TRUE.equals(searchedProduct.getIsDeleted())) {
            throw new ResourceNotFoundException("productNotFound");
        }
        Brand searchedBrand = brandRepository.getBrandById(updatedProduct.brandId()).orElse(null);
        if (searchedBrand == null || Boolean.TRUE.equals(searchedBrand.getIsDeleted())) {
            throw new ResourceNotFoundException("brandNotFound");
        }
        Category searchedCategory = categoryRepository.findById(updatedProduct.categoryId()).orElse(null);
        if (searchedCategory == null || Boolean.TRUE.equals(searchedCategory.getIsDeleted())) {
            throw new ResourceNotFoundException("categoryNotFound");
        }

        searchedProduct.setName(updatedProduct.name());
        searchedProduct.setBrand(searchedBrand);
        searchedProduct.setAmount(updatedProduct.amount());
        searchedProduct.setPrice(updatedProduct.price());

        // Fix #3: NPE védelem – ha nincs detail, újat hozunk létre
        if (searchedProduct.getDetail() != null) {
            searchedProduct.setDetail(new Details(searchedProduct.getDetail().getId(), updatedProduct.weightInKg(), updatedProduct.material(), updatedProduct.lengthInCm(), updatedProduct.heightInCm(), updatedProduct.widthInCm(), updatedProduct.size(), updatedProduct.isSet(), searchedProduct));
        } else {
            searchedProduct.setDetail(new Details(updatedProduct.weightInKg(), updatedProduct.material(), updatedProduct.lengthInCm(), updatedProduct.heightInCm(), updatedProduct.widthInCm(), updatedProduct.size(), updatedProduct.isSet()));
        }

        searchedProduct.setStockKeepingUnit(updatedProduct.stockKeepingUnit());
        searchedProduct.setDescription(updatedProduct.description());
        searchedProduct.setCategory(searchedCategory);
        searchedProduct.setUpdatedAt(LocalDateTime.now());

        return ProductResponse.fromEntity(productRepository.save(searchedProduct));
    }
}