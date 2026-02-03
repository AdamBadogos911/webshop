package com.example.badogosShop.service;

import com.example.badogosShop.entity.AddressType;
import com.example.badogosShop.repository.AddressTypeRepository;
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
@Transactional(noRollbackFor = {DataIntegrityViolationException.class, ConstraintViolationException.class, SQLIntegrityConstraintViolationException.class, SQLException.class})
public class OtherService {

    private final PaymentMethodRepository paymentMethodRepository;
    private final AddressTypeRepository addressTypeRepository;

    public ResponseEntity<Object> getAllPaymentMethods() {
        try {
            return ResponseEntity.ok().body(paymentMethodRepository.findAll());
        } catch(Exception e) {

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

}
