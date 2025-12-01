package com.example.badogosShop.controller;

import com.example.badogosShop.service.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/review")
@RequiredArgsConstructor

public class ReviewController {

    private ReviewService reviewService;


}
