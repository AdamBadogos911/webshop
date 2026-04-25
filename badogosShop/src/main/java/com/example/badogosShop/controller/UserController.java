package com.example.badogosShop.controller;

import com.example.badogosShop.config.security.SecurityUtils;
import com.example.badogosShop.dto.UserRegisterRequest;
import com.example.badogosShop.dto.UserUpdate;
import com.example.badogosShop.service.UserService;
import com.fasterxml.jackson.databind.JsonNode;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final SecurityUtils securityUtils;

    /**
     * Login végpont.
     * A hitelesítés HTTP Basic Auth-on keresztül történik (Spring Security BasicAuthenticationFilter),
     * a JWT tokenek automatikusan generálódnak a JWTGeneratorFilter által a response header-ben.
     * Ez a controller metódus csak a felhasználó adatait adja vissza + frissíti a lastLogin-t.
     */
    @PostMapping("/login")
    public ResponseEntity<?> login() {
        String authenticatedEmail = securityUtils.getAuthenticatedEmail();
        return ResponseEntity.ok(userService.login(authenticatedEmail));
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@Valid @RequestBody UserRegisterRequest request) {
        userService.register(request);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> update(@Valid @RequestBody UserUpdate updatedUser, @PathVariable("id") Integer id) {
        return ResponseEntity.ok(userService.update(id, updatedUser));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable("id") Integer id) {
        userService.delete(id);
        return ResponseEntity.ok().build();
    }

    @PatchMapping("/pfp/{id}")
    public ResponseEntity<?> changePfp(@RequestParam("image") MultipartFile newPfpImage, @PathVariable("id") Integer id) {
        return ResponseEntity.ok(userService.changePfp(newPfpImage, id));
    }

    @GetMapping("/verificationCode")
    public ResponseEntity<?> getVerificationCode(@RequestParam("email") String email) {
        userService.getVerificationCode(email);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/check")
    public ResponseEntity<?> checkVerificationCode(@RequestBody JsonNode requestBody) {
        String verificationCode = requestBody != null && requestBody.has("verificationCode") ? requestBody.get("verificationCode").asText(null) : null;
        String email = requestBody != null && requestBody.has("email") ? requestBody.get("email").asText(null) : null;
        return ResponseEntity.ok(userService.checkVerificationCode(verificationCode, email));
    }

    @PatchMapping("/password")
    public ResponseEntity<?> changePassword(@RequestBody JsonNode requestBody) {
        String email = requestBody != null && requestBody.has("email") ? requestBody.get("email").asText(null) : null;
        String verificationCode = requestBody != null && requestBody.has("verificationCode") ? requestBody.get("verificationCode").asText(null) : null;
        String newPassword = requestBody != null && requestBody.has("newPassword") ? requestBody.get("newPassword").asText(null) : null;
        userService.changePassword(email, verificationCode, newPassword);
        return ResponseEntity.ok().build();
    }
}
