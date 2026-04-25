package com.example.badogosShop.dto;

import com.example.badogosShop.entity.Product;
import com.example.badogosShop.entity.ProductImage;

import java.util.Date;
import java.util.List;

public record ProductResponse(
        Integer id,
        String name,
        String description,
        Integer price,
        Integer discount,
        Integer amount,
        String stockKeepingUnit,
        Long viewCount,
        Date createdAt,
        String brandName,
        String categoryName,
        DetailResponse detail,
        List<String> imageUrls
) {
    public record DetailResponse(
            Double weightInKg,
            String material,
            Double lengthInCm,
            Double heightInCm,
            Double widthInCm,
            String size,
            Boolean isSet
    ) { }

    public static ProductResponse fromEntity(Product p) {
        DetailResponse detailResp = null;
        if (p.getDetail() != null) {
            var d = p.getDetail();
            detailResp = new DetailResponse(
                    d.getWeightInKg(), d.getMaterial(), d.getLengthInCm(),
                    d.getHeightInCm(), d.getWidthInCm(), d.getSize(), d.getIsSet()
            );
        }

        List<String> images = p.getImages() != null
                ? p.getImages().stream().map(ProductImage::getImagePath).toList()
                : List.of();

        return new ProductResponse(
                p.getId(), p.getName(), p.getDescription(),
                p.getPrice(), p.getDiscount(), p.getAmount(),
                p.getStockKeepingUnit(), p.getViewCount(), p.getCreatedAt(),
                p.getBrand() != null ? p.getBrand().getName() : null,
                p.getCategory() != null ? p.getCategory().getName() : null,
                detailResp, images
        );
    }
}
