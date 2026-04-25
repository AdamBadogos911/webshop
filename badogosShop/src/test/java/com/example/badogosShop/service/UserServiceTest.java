package com.example.badogosShop.service;

import com.example.badogosShop.config.email.EmailSender;
import com.example.badogosShop.config.security.SecurityUtils;
import com.example.badogosShop.entity.User;
import com.example.badogosShop.exception.ForbiddenOperationException;
import com.example.badogosShop.exception.InvalidInputException;
import com.example.badogosShop.repository.CartRepository;
import com.example.badogosShop.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDateTime;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private CartRepository cartRepository;

    @Mock
    private EmailSender emailSender;

    @Mock
    private SecurityUtils securityUtils;

    @Mock
    private ValidationUtils validationUtils;

    @InjectMocks
    private UserService userService;

    @Test
    void changePasswordRequiresVerificationCode() {
        // verificationCode == null → InvalidInputException (422)
        assertThrows(InvalidInputException.class, () ->
                userService.changePassword("user@example.com", null, "Strong1!"));
        verify(userRepository, never()).save(any());
    }

    @Test
    void changePasswordRejectsInvalidVerificationCode() {
        User user = new User();
        user.setEmail("user@example.com");
        user.setIsDeleted(false);
        user.setVerificationCode("encoded-code");
        user.setVerificationCodeExpiresAt(LocalDateTime.now().plusMinutes(10));

        when(validationUtils.isEmailValid("user@example.com")).thenReturn(true);
        when(userRepository.findByEmail("user@example.com")).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("wrong-code", "encoded-code")).thenReturn(false);

        // Wrong verification code → ForbiddenOperationException (403)
        assertThrows(ForbiddenOperationException.class, () ->
                userService.changePassword("user@example.com", "wrong-code", "Strong1!"));
        verify(userRepository, never()).save(any());
    }

    @Test
    void changePasswordUpdatesPasswordAndClearsVerificationCode() {
        User user = new User();
        user.setEmail("user@example.com");
        user.setIsDeleted(false);
        user.setVerificationCode("encoded-code");
        user.setVerificationCodeExpiresAt(LocalDateTime.now().plusMinutes(10));

        when(validationUtils.isEmailValid("user@example.com")).thenReturn(true);
        when(validationUtils.isPasswordValid("Strong1!")).thenReturn(true);
        when(userRepository.findByEmail("user@example.com")).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("valid-code", "encoded-code")).thenReturn(true);
        when(passwordEncoder.encode("Strong1!")).thenReturn("encoded-password");

        // Should succeed without exception
        assertDoesNotThrow(() ->
                userService.changePassword("user@example.com", "valid-code", "Strong1!"));

        assertEquals("encoded-password", user.getPassword());
        assertNull(user.getVerificationCode());
        verify(userRepository).save(user);
    }
}
