package com.example.badogosShop.service;

import com.example.badogosShop.config.security.SecurityUtils;
import com.example.badogosShop.dto.CartResponse;
import com.example.badogosShop.entity.Cart;
import com.example.badogosShop.entity.CartProduct;
import com.example.badogosShop.entity.Product;
import com.example.badogosShop.entity.User;
import com.example.badogosShop.exception.*;
import com.example.badogosShop.repository.CartProductRepository;
import com.example.badogosShop.repository.CartRepository;
import com.example.badogosShop.repository.ProductRepository;
import com.example.badogosShop.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Date;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class CartService {

    private final CartRepository cartRepository;
    private final ProductRepository productRepository;
    private final UserRepository userRepository;
    private final CartProductRepository cartProductRepository;
    private final SecurityUtils securityUtils;

    @Transactional(readOnly = true)
    public CartResponse getCartByUserId(Integer userId) {
        if (userId == null) throw new InvalidInputException();

        User searchedUser = userRepository.findById(userId).orElse(null);
        if (searchedUser == null || Boolean.TRUE.equals(searchedUser.getIsDeleted())) {
            throw new ResourceNotFoundException("userNotFound");
        }
        if (!securityUtils.canAccessUser(searchedUser)) {
            throw new ForbiddenOperationException();
        }

        Cart cart = cartRepository.getCartByUserId(userId).orElse(null);
        if (cart == null) throw new ResourceNotFoundException("cartNotFound");

        cart.setCartProductList(cart.getCartProductList().stream()
                .filter(product -> !Boolean.TRUE.equals(product.getIsDeleted()))
                .toList());
        return CartResponse.fromEntity(cart);
    }

    // Fix #2: Készlet NEM változik kosárműveletkor – készlet csak rendeléskor csökken
    public void deleteProductFromCart(Integer cartProductId, Integer userId) {
        if (cartProductId == null || userId == null) throw new InvalidInputException();

        Cart searchedCart = cartRepository.getCartByUserId(userId).orElse(null);
        if (searchedCart == null) throw new ResourceNotFoundException("cartNotFound");
        if (!securityUtils.canAccessUser(searchedCart.getCartUser())) throw new ForbiddenOperationException();

        CartProduct searchedProduct = cartProductRepository.findById(cartProductId).orElse(null);
        if (searchedProduct == null || Boolean.TRUE.equals(searchedProduct.getIsDeleted())) {
            throw new ResourceNotFoundException("productNotFound");
        }
        if (searchedProduct.getCart() == null || !searchedCart.getId().equals(searchedProduct.getCart().getId())) {
            throw new ForbiddenOperationException();
        }

        cartProductRepository.deleteProductFromCart(searchedProduct.getId());
        // Fix #2: Készlet visszaállítás ELTÁVOLÍTVA – a készlet nem csökkent kosárba helyezéskor,
        // így visszaállítani sem kell törléskor.
    }

    public void changeAmountOfProduct(Integer userId, Integer productId, Integer newAmount) {
        if (userId == null || productId == null || newAmount == null) throw new InvalidInputException();
        if (productId == 0 || newAmount < 0) throw new InvalidInputException();

        Cart searchedCart = cartRepository.getCartByUserId(userId).orElse(null);
        CartProduct searchedBasketProduct = cartProductRepository.findById(productId).orElse(null);

        if (searchedCart == null) throw new ResourceNotFoundException("cartNotFound");
        if (!securityUtils.canAccessUser(searchedCart.getCartUser())) throw new ForbiddenOperationException();
        if (searchedBasketProduct == null || Boolean.TRUE.equals(searchedBasketProduct.getIsDeleted())) {
            throw new ResourceNotFoundException("productNotFound");
        }
        if (searchedBasketProduct.getCart() == null || !searchedCart.getId().equals(searchedBasketProduct.getCart().getId())) {
            throw new ForbiddenOperationException();
        }
        // Ellenőrzés: az új mennyiség nem haladhatja meg a tényleges készletet
        if (newAmount > searchedBasketProduct.getCartProduct().getAmount() || newAmount < 0) {
            throw new BusinessValidationException("invalidAmount");
        }
        if (newAmount == 0) {
            cartProductRepository.deleteProductFromCart(searchedBasketProduct.getId());
            // Fix #2: Készlet visszaállítás ELTÁVOLÍTVA
        } else {
            searchedBasketProduct.setAmount(newAmount);
            searchedBasketProduct.setLastModifiedAt(LocalDateTime.now());
            cartProductRepository.save(searchedBasketProduct);
        }
    }

    public void clearCart(Integer cartId) {
        if (cartId == null) throw new InvalidInputException();
        Cart searchedCart = cartRepository.findById(cartId).orElse(null);
        if (searchedCart == null) throw new ResourceNotFoundException("cartNotFound");
        if (!securityUtils.canAccessUser(searchedCart.getCartUser())) throw new ForbiddenOperationException();
        cartRepository.clearCart(cartId);
    }

    // Fix #23: Duplikátum ellenőrzés – ha a termék már a kosárban van, mennyiséget növelünk
    public void addProductToCart(Integer productId, Integer amount, Integer userId) {
        if (productId == null || userId == null || amount == null) throw new InvalidInputException();
        if (productId == 0 || amount <= 0) throw new InvalidInputException();

        Cart searchedCart = cartRepository.getCartByUserId(userId).orElse(null);
        if (searchedCart == null) throw new ResourceNotFoundException("cartNotFound");
        if (!securityUtils.canAccessUser(searchedCart.getCartUser())) throw new ForbiddenOperationException();

        Product searchedProduct = productRepository.findById(productId).orElse(null);
        if (searchedProduct == null || Boolean.TRUE.equals(searchedProduct.getIsDeleted())) {
            throw new ResourceNotFoundException("productNotFound");
        }
        if (amount > searchedProduct.getAmount()) {
            throw new BusinessValidationException("invalidAmount");
        }

        // Ha a termék már a kosárban van, mennyiséget növeljük
        CartProduct existingCartProduct = cartProductRepository
                .findActiveByCartAndProduct(searchedCart, searchedProduct)
                .orElse(null);

        if (existingCartProduct != null) {
            int newTotal = existingCartProduct.getAmount() + amount;
            if (newTotal > searchedProduct.getAmount()) {
                throw new BusinessValidationException("invalidAmount");
            }
            existingCartProduct.setAmount(newTotal);
            existingCartProduct.setLastModifiedAt(LocalDateTime.now());
            cartProductRepository.save(existingCartProduct);
        } else {
            CartProduct newCartProduct = new CartProduct(amount, searchedProduct, searchedCart);
            newCartProduct.setCreatedAt(new Date());
            newCartProduct.setLastModifiedAt(LocalDateTime.now());
            cartProductRepository.save(newCartProduct);
        }

        searchedCart.setLastModifiedAt(LocalDateTime.now());
        cartRepository.save(searchedCart);
    }
}