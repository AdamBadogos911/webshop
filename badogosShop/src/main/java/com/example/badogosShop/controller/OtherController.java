package com.example.badogosShop.controller;

import com.example.badogosShop.service.OtherService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class OtherController {

    private final OtherService otherService;

    @GetMapping("/paymentMethods")
    public ResponseEntity<?> getAllPaymentMethod() {
        return ResponseEntity.ok(otherService.getAllPaymentMethod());
    }

    @GetMapping("/addressType")
    public ResponseEntity<?> getAllAddressType() {
        return ResponseEntity.ok(otherService.getAllAddressType());
    }

    @GetMapping("/brand")
    public ResponseEntity<?> getAllBrand() {
        return ResponseEntity.ok(otherService.getAllBrand());
    }
}
