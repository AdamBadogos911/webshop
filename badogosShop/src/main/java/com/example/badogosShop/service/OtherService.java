package com.example.badogosShop.service;

import com.example.badogosShop.entity.AddressType;
import com.example.badogosShop.entity.Brand;
import com.example.badogosShop.entity.PaymentMethod;
import com.example.badogosShop.repository.AddressTypeRepository;
import com.example.badogosShop.repository.BrandRepository;
import com.example.badogosShop.repository.PaymentMethodRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class OtherService {

    private final PaymentMethodRepository paymentMethodRepository;
    private final AddressTypeRepository addressTypeRepository;
    private final BrandRepository brandRepository;

    @Cacheable("paymentMethods")
    public List<PaymentMethod> getAllPaymentMethod() {
        return paymentMethodRepository.findAll();
    }

    @Cacheable("addressTypes")
    public List<AddressType> getAllAddressType() {
        return addressTypeRepository.findAll();
    }

    @Cacheable("brands")
    public List<Brand> getAllBrand() {
        return brandRepository.getAllBrand().stream()
                .filter(b -> !Boolean.TRUE.equals(b.getIsDeleted()))
                .toList();
    }
}