package com.example.badogosShop.controller;

import com.example.badogosShop.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/order")
@RequiredArgsConstructor

public class OrderController {

    private OrderService orderService;

}
