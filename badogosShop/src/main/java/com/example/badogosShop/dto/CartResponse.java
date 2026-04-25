package com.example.badogosShop.dto;

import com.example.badogosShop.entity.Cart;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

/**
 * DTO a Cart entitáshoz – megoldja a LazyInitializationException problémát.
 * A CartProduct-on belüli Product lazy mezői (images, category) is
 * a @Transactional service metóduson belül kerülnek kiolvasásra.
 */
public record CartResponse(
        Integer id,
        LocalDateTime lastModifiedAt,
        Date createdAt,
        List<CartProductInfo> cartProductList
) {
    public record CartProductInfo(
            Integer id,
            Integer amount,
            Date createdAt,
            LocalDateTime lastModifiedAt,
            ProductResponse product
    ) {}

    public static CartResponse fromEntity(Cart cart) {
        List<CartProductInfo> products = List.of();
        if (cart.getCartProductList() != null) {
            products = cart.getCartProductList().stream()
                    .map(cp -> new CartProductInfo(
                            cp.getId(),
                            cp.getAmount(),
                            cp.getCreatedAt(),
                            cp.getLastModifiedAt(),
                            cp.getCartProduct() != null ? ProductResponse.fromEntity(cp.getCartProduct()) : null
                    ))
                    .toList();
        }

        return new CartResponse(cart.getId(), cart.getLastModifiedAt(), cart.getCreatedAt(), products);
    }
}
