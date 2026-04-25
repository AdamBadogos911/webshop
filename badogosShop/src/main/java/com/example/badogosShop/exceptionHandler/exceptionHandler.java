package com.example.badogosShop.exceptionHandler;

import com.example.badogosShop.exception.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestControllerAdvice
public class exceptionHandler {

    // ===== Custom business exceptions =====

    @org.springframework.web.bind.annotation.ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<Map<String, Object>> handleNotFound(ResourceNotFoundException ex) {
        return buildResponse(HttpStatus.NOT_FOUND, ex.getStatusText());
    }

    @org.springframework.web.bind.annotation.ExceptionHandler(ForbiddenOperationException.class)
    public ResponseEntity<Map<String, Object>> handleForbidden(ForbiddenOperationException ex) {
        return buildResponse(HttpStatus.FORBIDDEN, ex.getStatusText());
    }

    @org.springframework.web.bind.annotation.ExceptionHandler(InvalidInputException.class)
    public ResponseEntity<Map<String, Object>> handleInvalidInput(InvalidInputException ex) {
        return buildResponse(HttpStatus.UNPROCESSABLE_ENTITY, ex.getStatusText());
    }

    @org.springframework.web.bind.annotation.ExceptionHandler(BusinessValidationException.class)
    public ResponseEntity<Map<String, Object>> handleBusinessValidation(BusinessValidationException ex) {
        return buildResponse(HttpStatus.BAD_REQUEST, ex.getStatusText());
    }

    @org.springframework.web.bind.annotation.ExceptionHandler(ConflictException.class)
    public ResponseEntity<Map<String, Object>> handleConflict(ConflictException ex) {
        return buildResponse(HttpStatus.CONFLICT, ex.getStatusText());
    }

    // ===== Spring/framework exceptions =====

    @org.springframework.web.bind.annotation.ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<Map<String, Object>> handleAccessDenied(AccessDeniedException ex) {
        return buildResponse(HttpStatus.FORBIDDEN, "forbidden");
    }

    @org.springframework.web.bind.annotation.ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<Map<String, Object>> handleDataIntegrityViolation(DataIntegrityViolationException ex) {
        log.error("Adatbázis constraint megsértés: {}", ex.getMessage());

        Map<String, Object> response = new HashMap<>();

        if (ex.getMessage() != null && ex.getMessage().contains("for key 'email'")) {
            response.put("statusText", "duplicateEmail");
            response.put("message", "Ez az email cím már regisztrálva van");
            response.put("timestamp", System.currentTimeMillis());
            return ResponseEntity.status(HttpStatus.CONFLICT).body(response);
        }
        else if (ex.getMessage() != null && ex.getMessage().contains("for key 'phone'")) {
            response.put("statusText", "duplicatePhone");
            response.put("message", "Ez a telefonszám már regisztrálva van");
            response.put("timestamp", System.currentTimeMillis());
            return ResponseEntity.status(HttpStatus.CONFLICT).body(response);
        }

        response.put("statusText", "dataIntegrityViolation");
        response.put("message", "Adatbázis constraint megsértés");
        response.put("timestamp", System.currentTimeMillis());
        return ResponseEntity.status(HttpStatus.CONFLICT).body(response);
    }

    @org.springframework.web.bind.annotation.ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, Object>> handleValidationException(MethodArgumentNotValidException ex) {
        log.warn("Validációs hiba a requestben");

        Map<String, Object> response = new HashMap<>();
        Map<String, String> errors = new HashMap<>();

        ex.getBindingResult().getFieldErrors().forEach(error ->
            errors.put(error.getField(), error.getDefaultMessage())
        );

        response.put("statusText", "validationError");
        response.put("message", "A request adatai nem felelnek meg a validációs szabályoknak");
        response.put("errors", errors);
        response.put("timestamp", System.currentTimeMillis());

        return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY).body(response);
    }

    @org.springframework.web.bind.annotation.ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<Map<String, Object>> handleTypeMismatchException(MethodArgumentTypeMismatchException ex) {
        log.warn("Típus eltérés a requestben: paraméter={}, érték={}", ex.getName(), ex.getValue());

        Map<String, Object> response = new HashMap<>();
        response.put("statusText", "typeMismatch");
        response.put("message", "A paraméter típusa helytelen. Várt: " + (ex.getRequiredType() != null ? ex.getRequiredType().getSimpleName() : "ismeretlen"));
        response.put("parameter", ex.getName());
        response.put("timestamp", System.currentTimeMillis());

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }

    @org.springframework.web.bind.annotation.ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<Map<String, Object>> handleIllegalArgumentException(IllegalArgumentException ex) {
        log.warn("Illegális argument: {}", ex.getMessage());

        Map<String, Object> response = new HashMap<>();
        response.put("statusText", "illegalArgument");
        response.put("message", ex.getMessage() != null ? ex.getMessage() : "Érvénytelen paraméter");
        response.put("timestamp", System.currentTimeMillis());

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }

    @org.springframework.web.bind.annotation.ExceptionHandler(RuntimeException.class)
    public ResponseEntity<Map<String, Object>> handleRuntimeException(RuntimeException ex) {
        log.error("Váratlan RuntimeException: ", ex);

        Map<String, Object> response = new HashMap<>();
        response.put("statusText", "internalServerError");
        response.put("message", "Szerveren belüli hiba. A probléma már naplózásra került.");
        response.put("timestamp", System.currentTimeMillis());

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }

    @org.springframework.web.bind.annotation.ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, Object>> handleGenericException(Exception ex) {
        log.error("Váratlan Exception: ", ex);

        Map<String, Object> response = new HashMap<>();
        response.put("statusText", "internalServerError");
        response.put("message", "Szerveren belüli hiba. A probléma már naplózásra került.");
        response.put("timestamp", System.currentTimeMillis());

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }

    // ===== Helper =====

    private ResponseEntity<Map<String, Object>> buildResponse(HttpStatus status, String statusText) {
        Map<String, Object> response = new HashMap<>();
        response.put("statusText", statusText);
        response.put("message", statusText);
        response.put("timestamp", System.currentTimeMillis());
        return ResponseEntity.status(status).body(response);
    }
}