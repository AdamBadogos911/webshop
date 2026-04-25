package com.example.badogosShop.service;

import com.example.badogosShop.config.security.SecurityUtils;
import com.example.badogosShop.config.email.EmailSender;
import com.example.badogosShop.dto.UserRegisterRequest;
import com.example.badogosShop.dto.UserResponse;
import com.example.badogosShop.dto.UserUpdate;
import com.example.badogosShop.entity.Cart;
import com.example.badogosShop.entity.Role;
import com.example.badogosShop.entity.User;
import com.example.badogosShop.exception.*;
import com.example.badogosShop.repository.CartRepository;
import com.example.badogosShop.repository.RoleRepository;
import com.example.badogosShop.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.Set;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final CartRepository cartRepository;
    private final RoleRepository roleRepository;
    private final EmailSender emailSender;
    private final SecurityUtils securityUtils;
    private final ValidationUtils validationUtils;

    private static final int DEFAULT_ROLE_ID = 1;
    private static final Set<String> ALLOWED_IMAGE_EXTENSIONS = Set.of("jpg", "jpeg", "png", "gif", "webp");
    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of("image/jpeg", "image/png", "image/gif", "image/webp");

    @Value("${app.base-url:http://localhost:8080}")
    private String baseUrl;

    /**
     * Login – a jelszó ellenőrzést a Spring Security BasicAuthenticationFilter már elvégezte.
     * Ez a metódus csak a felhasználó adatait adja vissza és frissíti a lastLogin időpontot.
     *
     * @param email az autentikált felhasználó email-je (SecurityContext-ből)
     */
    public UserResponse login(String email) {
        if (email == null) {
            throw new ResourceNotFoundException("userNotFound");
        }
        User searchedUser = userRepository.findByEmail(email).orElse(null);
        if (searchedUser == null || Boolean.TRUE.equals(searchedUser.getIsDeleted())) {
            throw new ResourceNotFoundException("userNotFound");
        }
        searchedUser.setLastLogin(LocalDateTime.now());
        return toUserResponse(userRepository.save(searchedUser));
    }

    public void register(UserRegisterRequest request) {
        if (!validationUtils.isEmailValid(request.email())) {
            throw new BusinessValidationException("invalidEmail");
        }
        if (!validationUtils.isPasswordValid(request.password())) {
            throw new BusinessValidationException("invalidPassword");
        }

        // Duplikált email ellenőrzés
        if (userRepository.findByEmail(request.email()).isPresent()) {
            throw new ConflictException("duplicateEmail");
        }

        // Role betöltése adatbázisból (nem transient objektum)
        Role defaultRole = roleRepository.findById(DEFAULT_ROLE_ID)
                .orElseThrow(() -> new ResourceNotFoundException("roleNotFound"));

        User newUser = new User();
        newUser.setEmail(request.email());
        newUser.setPassword(passwordEncoder.encode(request.password()));
        newUser.setFirstName(request.firstName());
        newUser.setLastName(request.lastName());
        newUser.setPhoneNumber(request.phoneNumber());
        newUser.setPfpPath(baseUrl + "/pfp/default.png");
        newUser.setRole(defaultRole);
        newUser.setRegisterFinishedAt(new java.util.Date());

        User registeredUser = userRepository.save(newUser);
        cartRepository.save(new Cart(registeredUser));

        // Async – háttérben küldődik, nem blokkolja a választ
        emailSender.sendEmailAboutRegistration(request.email());
    }

    public UserResponse update(Integer id, UserUpdate updatedUser) {
        if (id == null || updatedUser == null) throw new InvalidInputException();

        User searchedUser = userRepository.findById(id).orElse(null);
        if (searchedUser == null || Boolean.TRUE.equals(searchedUser.getIsDeleted())) {
            throw new ResourceNotFoundException("userNotFound");
        }
        if (!securityUtils.canAccessUser(searchedUser)) throw new ForbiddenOperationException();
        if (!validationUtils.isEmailValid(updatedUser.email())) {
            throw new BusinessValidationException("invalidEmail");
        }

        // Ha az email változik, ellenőrizzük a duplikációt
        if (!searchedUser.getEmail().equalsIgnoreCase(updatedUser.email())) {
            if (userRepository.findByEmail(updatedUser.email()).isPresent()) {
                throw new ConflictException("duplicateEmail");
            }
        }

        searchedUser.setEmail(updatedUser.email());
        searchedUser.setPhoneNumber(updatedUser.phoneNumber());
        searchedUser.setFirstName(updatedUser.firstName());
        searchedUser.setLastName(updatedUser.lastName());
        return toUserResponse(userRepository.save(searchedUser));
    }

    public void delete(Integer id) {
        if (id == null) throw new InvalidInputException();
        User searchedUser = userRepository.findById(id).orElse(null);
        if (searchedUser == null || Boolean.TRUE.equals(searchedUser.getIsDeleted())) {
            throw new ResourceNotFoundException("userNotFound");
        }
        if (!securityUtils.canAccessUser(searchedUser)) throw new ForbiddenOperationException();
        userRepository.deleteUserById(id);
    }

    public UserResponse changePfp(MultipartFile newPfpImage, Integer id) {
        if (id == null || newPfpImage == null) throw new InvalidInputException();

        User searchedUser = userRepository.findById(id).orElse(null);
        if (searchedUser == null || Boolean.TRUE.equals(searchedUser.getIsDeleted())) {
            throw new ResourceNotFoundException("userNotFound");
        }
        if (!securityUtils.canAccessUser(searchedUser)) throw new ForbiddenOperationException();

        String originalFilename = newPfpImage.getOriginalFilename();
        if (originalFilename == null || originalFilename.isBlank()) {
            throw new BusinessValidationException("invalidFileName");
        }

        // Fájltípus validáció
        String contentType = newPfpImage.getContentType();
        if (contentType == null || !ALLOWED_CONTENT_TYPES.contains(contentType.toLowerCase())) {
            throw new BusinessValidationException("invalidFileType");
        }

        // Kiterjesztés validáció
        String sanitizedFilename = Paths.get(originalFilename).getFileName().toString();
        String extension = getFileExtension(sanitizedFilename).toLowerCase();
        if (!ALLOWED_IMAGE_EXTENSIONS.contains(extension)) {
            throw new BusinessValidationException("invalidFileType");
        }

        String fileName = searchedUser.getId() + "_" + sanitizedFilename;
        Path filePath = Paths.get("images", "pfp", fileName);

        try (OutputStream fout = Files.newOutputStream(filePath)) {
            fout.write(newPfpImage.getBytes());
        } catch (IOException e) {
            log.error("File upload error for user {}", id, e);
            throw new BusinessValidationException("fileUploadError");
        }

        searchedUser.setPfpPath(baseUrl + "/pfp/" + fileName);
        return toUserResponse(userRepository.save(searchedUser));
    }

    public void getVerificationCode(String email) {
        if (email == null) throw new InvalidInputException();
        if (!validationUtils.isEmailValid(email)) throw new BusinessValidationException("invalidEmail");

        User searchedUser = userRepository.findByEmail(email).orElse(null);
        if (searchedUser == null || Boolean.TRUE.equals(searchedUser.getIsDeleted())) {
            throw new ResourceNotFoundException("userNotFound");
        }

        String vCode = validationUtils.generateVerificationCode();
        searchedUser.setVerificationCode(passwordEncoder.encode(vCode));
        searchedUser.setVerificationCodeExpiresAt(LocalDateTime.now().plusMinutes(15));
        userRepository.save(searchedUser);

        // Async – háttérben küldődik
        emailSender.sendVerificationCodeForPasswordReset(email, vCode);
    }

    @Transactional(readOnly = true)
    public Boolean checkVerificationCode(String verificationCode, String email) {
        if (verificationCode == null || email == null) throw new InvalidInputException();
        if (!validationUtils.isEmailValid(email)) throw new BusinessValidationException("invalidEmail");

        User searchedUser = userRepository.findByEmail(email).orElse(null);
        if (searchedUser == null || Boolean.TRUE.equals(searchedUser.getIsDeleted())) {
            throw new ResourceNotFoundException("userNotFound");
        }
        return searchedUser.getVerificationCode() != null
                && searchedUser.getVerificationCodeExpiresAt() != null
                && searchedUser.getVerificationCodeExpiresAt().isAfter(LocalDateTime.now())
                && passwordEncoder.matches(verificationCode, searchedUser.getVerificationCode());
    }

    public void changePassword(String email, String verificationCode, String newPassword) {
        if (email == null || verificationCode == null || newPassword == null) throw new InvalidInputException();
        if (!validationUtils.isEmailValid(email)) throw new BusinessValidationException("invalidEmail");

        User searchedUser = userRepository.findByEmail(email).orElse(null);
        if (searchedUser == null || Boolean.TRUE.equals(searchedUser.getIsDeleted())) {
            throw new ResourceNotFoundException("userNotFound");
        }
        if (searchedUser.getVerificationCode() == null
                || searchedUser.getVerificationCodeExpiresAt() == null
                || searchedUser.getVerificationCodeExpiresAt().isBefore(LocalDateTime.now())
                || !passwordEncoder.matches(verificationCode, searchedUser.getVerificationCode())) {
            throw new ForbiddenOperationException();
        }
        if (!validationUtils.isPasswordValid(newPassword)) {
            throw new BusinessValidationException("invalidPassword");
        }

        searchedUser.setPassword(passwordEncoder.encode(newPassword));
        searchedUser.setVerificationCode(null);
        searchedUser.setVerificationCodeExpiresAt(null);
        userRepository.save(searchedUser);
    }

    private String getFileExtension(String filename) {
        int lastDotIndex = filename.lastIndexOf('.');
        if (lastDotIndex == -1 || lastDotIndex == filename.length() - 1) {
            return "";
        }
        return filename.substring(lastDotIndex + 1);
    }

    private UserResponse toUserResponse(User user) {
        return new UserResponse(
                user.getId(),
                user.getEmail(),
                user.getFirstName(),
                user.getLastName(),
                user.getPhoneNumber(),
                user.getPfpPath(),
                user.getLastLogin(),
                user.getRole() != null ? user.getRole().getName() : null
        );
    }
}