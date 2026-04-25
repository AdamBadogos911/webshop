package com.example.badogosShop.service;

import com.example.badogosShop.repository.AddressTypeRepository;
import com.example.badogosShop.repository.BrandRepository;
import com.example.badogosShop.repository.PaymentMethodRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.validation.ConstraintViolationException;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;

@Service
@RequiredArgsConstructor
@Transactional
public class OtherService {

    private final PaymentMethodRepository paymentMethodRepository;
    private final AddressTypeRepository addressTypeRepository;
    private final BrandRepository brandRepository;

    public ResponseEntity<Object> getAllPaymentMethod() {
        try {
            return ResponseEntity.ok().body(paymentMethodRepository.findAll());
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }
    public ResponseEntity<Object> getAllAddressType() {
        try {
            return ResponseEntity.ok().body(addressTypeRepository.findAll());
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    public ResponseEntity<Object> getAllBrand() {
        try {
            return ResponseEntity.ok(brandRepository.getAllBrand());
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }
}

