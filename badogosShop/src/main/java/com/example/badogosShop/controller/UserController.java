package com.example.badogosShop.controller;

import com.example.badogosShop.entity.User;
import com.example.badogosShop.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
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
    public ResponseEntity<Object> register(@RequestBody User newUser) {
        return userService.register(newUser);
    }

    @PutMapping("/{id}")
    private ResponseEntity<Object> update(@RequestBody User updatedUser, @PathVariable("id") Integer id) {
        return userService.update(id, updatedUser)
    }

    @DeleteMapping("/{id}")
    private ResponseEntity<Object> delete(@PathVariable("id") Integer id) {
        return userService.delete(id);
    }

    @PatchMapping("/pfp/{id}")
    private ResponseEntity<Object> changePfp(@RequestParam("pfpFile")MultipartFile newPfpImage, @PathVariable("id") Integer id) {
        return userService.changePfp(newPfpImage, id);
    }

    @GetMapping("/verificationCode")
    private ResponseEntity<Object> getVerificationCode(@RequestParam("email") String email) {
        return userService.getVerificationCode(email);
    }

    @PostMapping("/check")
    private ResponseEntity<Object> checkVerificationCode(@RequestBody JsonNode requestBody) {
        return userService.checkVerificationCode(requestBody.get("vCode").asText(null), requestBody.get("email").asText(null));
    }

    @PatchMapping("/password")
    private ResponseEntity<Object> changePassword(@RequestBody JsonNode requestBody) {
        return userService.changePassword(requestBody.get("email").asText(null), requestBody.get("newPassword").asText(null));
    }


}

