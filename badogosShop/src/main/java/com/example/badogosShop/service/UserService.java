package com.example.badogosShop.service;

import com.example.badogosShop.config.email.EmailSender;
import com.example.badogosShop.entity.Cart;
import com.example.badogosShop.entity.User;
import com.example.badogosShop.repository.CartRepository;
import com.example.badogosShop.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.ConstraintViolationException;
import java.io.File;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.time.LocalDateTime;
import java.util.Random;
import java.util.regex.Pattern;

@Service
@RequiredArgsConstructor
@Transactional(noRollbackFor = {DataIntegrityViolationException.class, ConstraintViolationException.class, SQLIntegrityConstraintViolationException.class, SQLException.class})
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final CartRepository cartRepository;
    private final EmailSender emailSender;

    public ResponseEntity<Object> login(String email, String password) {
        try {
            if (email == null || password == null) {
                return ResponseEntity.status(422).build();
            }
            User searchedUser = userRepository.findByEmail(email).orElse(null);
            if (searchedUser == null) {
                return ResponseEntity.notFound().build();
            }

            if (!passwordEncoder.matches(password, searchedUser.getPassword())) {
                return ResponseEntity.notFound().build();
            } else {
                System.out.println("successfullyLogin");
                searchedUser.setLastLogin(LocalDateTime.now());
                return ResponseEntity.ok().body(userRepository.save(searchedUser));
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    public ResponseEntity<Object> register(User newUser) {
        try {
            if (newUser == null) {
                return ResponseEntity.status(422).build();
            }

            if (newUser.getId() != null) {
                return ResponseEntity.status(415).body("invalidObject");
            } else if (!isEmailValid(newUser.getEmail())) {
                return ResponseEntity.status(415).body("invalidEmail");
            } else if (!isPasswordValid(newUser.getPassword())) {
                return ResponseEntity.status(415).body("invalidPassword");
            } else {
                newUser.setPassword(passwordEncoder.encode(newUser.getPassword()));
                User registeredUser = userRepository.save(newUser);
                cartRepository.save(new Cart(registeredUser));

                try {
                    emailSender.sendEmailAboutRegistration(newUser.getEmail());
                } catch (Exception e) {
                    e.printStackTrace();
                    return ResponseEntity.internalServerError().build();
                }

                return ResponseEntity.ok().build();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    public ResponseEntity<Object> update(Integer id, User updatedUser) {
        try {
            if (id == null || updatedUser == null) {
                return ResponseEntity.status(422).build();
            }
            User searchedUser = userRepository.getUserById(id).orElse(null);
            if (searchedUser == null || searchedUser.getIsDeleted()) {
                return ResponseEntity.notFound().build();
            }
            if (!isEmailValid(updatedUser.getEmail())) {
                return ResponseEntity.status(415).body("invalidEmail");
            } else {
                return ResponseEntity.ok().body(userRepository.save(searchedUser));
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    public ResponseEntity<Object> delete(Integer id) {
        try {
            if (id == null) {
                return ResponseEntity.status(422).build();
            }
            User searchedUser = userRepository.getUserById(id).orElse(null);
            if (searchedUser == null || searchedUser.getIsDeleted()) {
                return ResponseEntity.notFound().build();
            } else {
                userRepository.deleteUserById(id);
                return ResponseEntity.ok().build();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    public ResponseEntity<Object> changePfp(MultipartFile newPfpImage, Integer id) {
        try {
            if (id == null || newPfpImage == null) {
                return ResponseEntity.status(422).build();
            }

            User searchedUser = userRepository.getUserById(id).orElse(null);

            if (searchedUser == null || searchedUser.getIsDeleted()) {
                return ResponseEntity.notFound().build();
            } else {
//                String filePath = "C:\\Users\\bzhal\\Documents\\GitHub\\appointment_management_system\\pmsWebPage\\src\\assets\\images\\pfp" + File.separator + pfpFile.getOriginalFilename();

                try {
//                    FileOutputStream fout = new FileOutputStream(newPfpImage);
//                    fout.write(newPfpImage.getBytes());
//                    fout.close();

                    searchedUser.setPfpPath("assets\\images\\pfp" + File.separator + newPfpImage.getOriginalFilename());
                } catch (Exception e) {
                    return ResponseEntity.internalServerError().body("fileUploadError");
                }

                return ResponseEntity.ok().body(userRepository.save(searchedUser));
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    public ResponseEntity<Object> getVerificationCode(String email) {
        try {
            if (email == null) {
                return ResponseEntity.status(422).build();
            }
            User searchedUser = userRepository.findByEmail(email).orElse(null);
            if (searchedUser == null || searchedUser.getIsDeleted()) {
                return ResponseEntity.notFound().build();
            } else {
                String vCode = generateVerificationCode();
                try {
                    emailSender.sendVerificationCodeForPasswordReset(email, vCode);
                } catch (Exception e) {
                    e.printStackTrace();
                    return ResponseEntity.internalServerError().build();
                }
                searchedUser.setVCode(passwordEncoder.encode(vCode));
                return ResponseEntity.ok().build();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("serverError");
        }
    }

    public ResponseEntity<Object> checkVerificationCode(String vCode, String email) {
        try {
            if (vCode == null || email == null) {
                return ResponseEntity.status(422).build();
            }
            if (!isEmailValid(email)) {
                return ResponseEntity.status(415).body("invalidEmail");
            }

            User searchedUser = userRepository.findByEmail(email).orElse(null);
            if (searchedUser == null || searchedUser.getIsDeleted()) {
                return ResponseEntity.internalServerError().build();
            } else {
                return ResponseEntity.ok().body(passwordEncoder.matches(vCode, searchedUser.getVCode()));
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    public ResponseEntity<Object> changePassword(String email, String newPassword) {
        try {
            if (email == null || newPassword == null) {
                return ResponseEntity.status(422).build();
            }
            if (!isEmailValid(email)) {
                return ResponseEntity.status(415).body("invalidEmail");
            }

            User searchedUser = userRepository.findByEmail(email).orElse(null);
            if (searchedUser == null || searchedUser.getIsDeleted()) {
                return ResponseEntity.internalServerError().build();
            }

            if (!isPasswordValid(newPassword)) {
                return ResponseEntity.status(415).body("invalidPassword");
            } else {
                searchedUser.setPassword(passwordEncoder.encode(newPassword));
                userRepository.save(searchedUser);
                return ResponseEntity.ok().build();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    public Boolean isEmailValid(String email) {
        Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
        if (email == null || email.length() > 100) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email).matches();
    }

    public Boolean isPasswordValid(String password) {
        if (password.length() < 8 || password.length() > 16) {
            return false;
        }

        String specialCharacters = "\"!@#$%^&*()-_=+[]{};:,.?/\"";
        String numbersText = "1234567890";
        boolean specialChecker = false;
        boolean upperCaseChecker = false;
        boolean lowerCaseChecker = false;
        boolean initChecker = false;

        for (int i = 0; i < password.trim().length(); i++) {
            String selectedChar = String.valueOf(password.charAt(i));

            if (numbersText.contains(selectedChar)) {
                initChecker = true;
            } else if (specialCharacters.contains(selectedChar)) {
                specialChecker = true;
            } else if (selectedChar.equals(selectedChar.toUpperCase())) {
                upperCaseChecker = true;
            } else if (selectedChar.equals(selectedChar.toLowerCase())) {
                lowerCaseChecker = true;
            }
        }

        return specialChecker && upperCaseChecker && lowerCaseChecker && initChecker;
    }

    public String generateVerificationCode() {
        String characters = "!@#$%&*()-+={}[]|\\/:;'\"<>,.?~" + "ABCDEFGHIJKLMNOPQRSTUVWXYZÁÉÜŰÚÖÓŐÍ" + "0123456789" + "abcdefghijklmnopqrstuvxyzéáíúöőüű";
        String verificationCode = "";
        while (verificationCode.length() != 10) {
            verificationCode += String.valueOf(characters.charAt(new Random().nextInt(0, characters.length())));
        }

        return verificationCode;
    }
}

