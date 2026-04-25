package com.example.badogosShop.controller;

import com.example.badogosShop.dto.OrderHistoryResponse;
import com.example.badogosShop.dto.OrderRequest;
import com.example.badogosShop.service.OrderService;
import com.fasterxml.jackson.databind.JsonNode;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/order")
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;

    @GetMapping("/user/{id}")
    public ResponseEntity<?> getOrderHistoryByUserId(@PathVariable("id") Integer userId) {
        return ResponseEntity.ok(orderService.getOrderHistoryByUserId(userId));
    }

    @DeleteMapping("/cancel/{id}")
    public ResponseEntity<?> cancelOrder(@PathVariable("id") Integer orderId, @RequestBody(required = false) JsonNode requestBody) {
        Integer cancelerUserId = requestBody != null && requestBody.has("cancelerUserId")
                ? requestBody.get("cancelerUserId").asInt(0)
                : 0;
        orderService.cancelOrder(orderId, cancelerUserId);
        return ResponseEntity.ok().build();
    }

    @GetMapping
    public ResponseEntity<?> getAllOrder(Pageable pageable) {
        Page<OrderHistoryResponse> page = orderService.getAllOrderHistory(pageable);
        HttpHeaders headers = new HttpHeaders();
        headers.add("TotalPage", String.valueOf(page.getTotalPages()));
        headers.add("TotalElements", String.valueOf(page.getTotalElements()));
        return ResponseEntity.ok().headers(headers).body(page.getContent());
    }

    @PostMapping("/cart/{id}")
    public ResponseEntity<?> sendOrder(@Valid @RequestBody OrderRequest request, @PathVariable("id") Integer cartId) {
        return ResponseEntity.ok(orderService.sendOrder(request, cartId));
    }
}