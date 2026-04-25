package com.example.badogosShop.controller;

import com.example.badogosShop.service.CartService;
import com.fasterxml.jackson.databind.JsonNode;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/cart")
@RequiredArgsConstructor
public class CartController {

    private final CartService cartService;

    @GetMapping("/user/{id}")
    public ResponseEntity<?> getCartByUserId(@PathVariable("id") Integer userId) {
        return ResponseEntity.ok(cartService.getCartByUserId(userId));
    }

    @DeleteMapping("/product")
    public ResponseEntity<?> deleteProductFromCart(@RequestParam("cartProductId") Integer basketProductId, @RequestParam("userId") Integer userId) {
        cartService.deleteProductFromCart(basketProductId, userId);
        return ResponseEntity.ok().build();
    }

    @PatchMapping("/{id}")
    public ResponseEntity<?> changeAmountOfProduct(@RequestBody JsonNode requestBody, @PathVariable("id") Integer userId) {
        Integer productId = requestBody != null && requestBody.has("productId") ? requestBody.get("productId").asInt(0) : null;
        Integer newAmount = requestBody != null && requestBody.has("newAmount") ? requestBody.get("newAmount").asInt(-1) : null;
        cartService.changeAmountOfProduct(userId, productId, newAmount);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/{id}")
    public ResponseEntity<?> addProductToCart(@RequestBody JsonNode requestBody, @PathVariable("id") Integer userId) {
        Integer productId = requestBody != null && requestBody.has("productId") ? requestBody.get("productId").asInt(0) : null;
        Integer amount = requestBody != null && requestBody.has("amount") ? requestBody.get("amount").asInt(-1) : null;
        cartService.addProductToCart(productId, amount, userId);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/{id}/clear")
    public ResponseEntity<?> clearCart(@PathVariable("id") Integer basketId) {
        cartService.clearCart(basketId);
        return ResponseEntity.ok().build();
    }
}
