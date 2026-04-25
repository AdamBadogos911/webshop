package com.example.badogosShop.controller;

import com.example.badogosShop.service.CartService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import tools.jackson.databind.JsonNode;

@RestController
@RequestMapping("/cart")
@RequiredArgsConstructor
public class CartController {

    private final CartService cartService;

    @GetMapping("/user/{id}")
    private ResponseEntity<Object> getCartByUserId(@PathVariable("id") Integer userId) {
        return cartService.getCartByUserId(userId);
    }

    @DeleteMapping("/product")
    private ResponseEntity<Object> deleteProductFromCart(@RequestParam("cartProductId") Integer basketProductId, @RequestParam("userId") Integer userId) {
        return cartService.deleteProductFromCart(basketProductId, userId);
    }

    @PatchMapping("/{id}")
    private ResponseEntity<Object> changeAmountOfProduct(@RequestBody JsonNode requestBody, @PathVariable("id") Integer userId) {
        return cartService.changeAmountOfProduct(userId, requestBody.get("productId").asInt(0), requestBody.get("newAmount").asInt(-1));
    }

    @PostMapping("/{id}")
    private ResponseEntity<Object> addProductToCart(@RequestBody JsonNode requestBody, @PathVariable("id") Integer userId) {
        return cartService.addProductToCart(requestBody.get("productId").asInt(0), requestBody.get("amount").asInt(-1), userId);
    }

    @DeleteMapping("/{id}/clear")
    private ResponseEntity<Object> clearCart(@PathVariable("id") Integer basketId) {
        return cartService.clearCart(basketId);
    }
}
