package com.example.badogosShop.service;

import org.springframework.stereotype.Component;

import java.security.SecureRandom;
import java.util.regex.Pattern;

/**
 * Közös validációs és segéd metódusok, amelyek több service-ben is kellenek.
 * Így nem duplikálódik a kód (DRY elv).
 */
@Component
public class ValidationUtils {

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();
    private static final String VERIFICATION_CHARACTERS =
            "!@#$%&*()-+={}[]|\\/:;'\"<>,.?~"
                    + "ABCDEFGHIJKLMNOPQRSTUVWXYZÁÉÜŰÚÖÓŐÍ"
                    + "0123456789"
                    + "abcdefghijklmnopqrstuvwxyzéáíúöőüű";

    public boolean isEmailValid(String email) {
        if (email == null || email.length() > 100) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email).matches();
    }

    public boolean isPasswordValid(String password) {
        if (password == null || password.length() < 8 || password.length() > 16) {
            return false;
        }

        String specialCharacters = "!@#$%^&*()-_=+[]{};:,.?/";
        String numbersText = "1234567890";
        boolean specialChecker = false;
        boolean upperCaseChecker = false;
        boolean lowerCaseChecker = false;
        boolean numberChecker = false;

        for (int i = 0; i < password.length(); i++) {
            char c = password.charAt(i);
            String selectedChar = String.valueOf(c);

            if (numbersText.contains(selectedChar)) {
                numberChecker = true;
            } else if (specialCharacters.contains(selectedChar)) {
                specialChecker = true;
            } else if (Character.isUpperCase(c)) {
                upperCaseChecker = true;
            } else if (Character.isLowerCase(c)) {
                lowerCaseChecker = true;
            }
        }

        return specialChecker && upperCaseChecker && lowerCaseChecker && numberChecker;
    }

    public String generateVerificationCode() {
        StringBuilder verificationCode = new StringBuilder(10);
        for (int i = 0; i < 10; i++) {
            verificationCode.append(VERIFICATION_CHARACTERS.charAt(
                    SECURE_RANDOM.nextInt(VERIFICATION_CHARACTERS.length())));
        }
        return verificationCode.toString();
    }
}
