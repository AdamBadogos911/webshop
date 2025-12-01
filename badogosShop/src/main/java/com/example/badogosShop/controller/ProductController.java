package com.example.badogosShop.controller;

import com.example.badogosShop.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/product")
@RequiredArgsConstructor

public class ProductController {

    private ProductService productService;

}
