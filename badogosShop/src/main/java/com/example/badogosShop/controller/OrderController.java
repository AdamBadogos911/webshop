package com.example.badogosShop.controller;

import com.example.badogosShop.entity.OrderHistory;
import com.example.badogosShop.service.OrderService;
import com.fasterxml.jackson.databind.JsonNode;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/order")
@RequiredArgsConstructor

public class OrderController {

    private OrderService orderService;

    @GetMapping("/user/{id}")
    public ResponseEntity<Object> getOrderHistoryByUserId(@PathVariable("id") Integer userId) {
        return orderService.getOrderHistoryByUserId(userId);
    }

    @DeleteMapping("/cancel/{id}")
    public ResponseEntity<Object> cancelOrder(@PathVariable("id") Integer orderId, @RequestBody JsonNode requestBody) {
        return orderService.cancelOrder(orderId, requestBody.get("cancelerUserId").asInt());
    }

    @GetMapping("")
    public ResponseEntity<Object> getAllOrder() {
        return orderService.getAllOrder();
    }

    @PostMapping("/basket/{id}")
    public ResponseEntity<Object> sendOrder(@RequestBody OrderHistory newOrder, @PathVariable("id") Integer baskedId) {
        return orderService.sendOrder(newOrder, baskedId);
    }

}
