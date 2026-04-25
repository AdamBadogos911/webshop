package com.example.badogosShop.dto;

public record UserUpdate(
        String firstName,
        String lastName,
        String email,
        String phoneNumber
) { }
