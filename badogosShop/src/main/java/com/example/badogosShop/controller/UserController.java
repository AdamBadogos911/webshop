package com.example.badogosShop.controller;

import com.example.badogosShop.dto.UserUpdate;
import com.example.badogosShop.entity.User;
import com.example.badogosShop.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import tools.jackson.databind.JsonNode;


@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @PostMapping("/login")
    private ResponseEntity<Object> login(@RequestBody JsonNode requestBody) {
        return userService.login(requestBody.get("email").asText(null), requestBody.get("password").asText(null));
    }

    @PostMapping("/register")
    private ResponseEntity<Object> register(@RequestBody User newUser) {
        return userService.register(newUser);
    }

    @PutMapping("/{id}")
    private ResponseEntity<Object> update(@RequestBody UserUpdate updatedUser, @PathVariable("id") Integer id) {
        return userService.update(id, updatedUser);
    }

    @DeleteMapping("/{id}")
    private ResponseEntity<Object> delete(@PathVariable("id") Integer id) {
        return userService.delete(id);
    }

    @PatchMapping("/pfp/{id}")
    private ResponseEntity<Object> changePfp(@RequestParam("image") MultipartFile newPfpImage, @PathVariable("id") Integer id) {
        return userService.changePfp(newPfpImage, id);
    }

    @GetMapping("/vCode")
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
