package com.example.badogosShop.service;

import com.example.badogosShop.entity.User;
import com.example.badogosShop.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.regex.Pattern;

@Service
@Transactional
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    public ResponseEntity<Object> login(String email, String password) {
        if (!passwordChecker(password)) {
            return ResponseEntity.status(417).body("invalidPassword");
        } else if (!emailChecker(email)){
            return ResponseEntity.status(417).body("invalidEmail");
        } else {
            System.out.println(password);
            User searchedUser = userRepository.login(email, password);
            System.out.println(searchedUser.getPassword());
            System.out.println(password == searchedUser.getPassword());
            if(searchedUser == null || searchedUser.getId() == null || searchedUser.getIsDeleted()){
                return ResponseEntity.notFound().build();
            } else {
                return ResponseEntity.ok().body(searchedUser);
            }
        }
    }

    public ResponseEntity<Object> register(User newUser) {
        if(newUser.getId() != null){
            return ResponseEntity.internalServerError().build();
        } else if (!passwordChecker(newUser.getPassword())){
            return ResponseEntity.status(417).body("invalidPassword");
        } else if (!emailChecker(newUser.getEmail())){
            return ResponseEntity.status(417).body("invalidEmail");
        } else {
            System.out.println("Asd");
            userRepository.save(newUser);
            return ResponseEntity.ok().build();
        }
    }

    //
    public static boolean passwordChecker(String password) {
        if (password.length() < 8 || password.length() > 8) {
            return false;
        }

        String numbersText = "1234567890";
        boolean upperCaseChecker = false;
        boolean lowerCaseChecker = false;
        boolean initChecker = false;

        for (int i = 0; i < password.trim().length(); i++) {
            String selectedChar = String.valueOf(password.charAt(i));

            if (numbersText.contains(selectedChar)) {
                initChecker = true;
            } else if (selectedChar.equals(selectedChar.toUpperCase())) {
                upperCaseChecker = true;
            } else if (selectedChar.equals(selectedChar.toLowerCase())) {
                lowerCaseChecker = true;
            }
        }

        return upperCaseChecker && lowerCaseChecker && initChecker;
    }

    public static boolean emailChecker(String email) {
        if (email == null || email.length() > 100) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email).matches();
    }
}

