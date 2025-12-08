package com.example.badogosShop.controller;

import com.example.badogosShop.entity.User;
import com.example.badogosShop.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import tools.jackson.databind.JsonNode;

import java.util.Map;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
@CrossOrigin({"http://localhost:4200"})

public class UserController {

    private final UserService userService;

    @PostMapping("/login")
    public ResponseEntity<Object> login(@RequestBody JsonNode body) {
        return userService.login(body.get("email").asString(), body.get("password").asString());
    }

    @PostMapping("/register")
    public ResponseEntity<Object> register(@RequestBody User newUser) { return userService.register(newUser); }

}
