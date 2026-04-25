package com.example.badogosShop.service;

import com.example.badogosShop.config.email.EmailSender;
import com.example.badogosShop.config.security.SecurityUtils;
import com.example.badogosShop.dto.OrderHistoryResponse;
import com.example.badogosShop.dto.OrderRequest;
import com.example.badogosShop.dto.OrderResponse;
import com.example.badogosShop.entity.*;
import com.example.badogosShop.exception.*;
import com.example.badogosShop.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class OrderService {

    private final OrderHistoryRepository orderHistoryRepository;
    private final UserRepository userRepository;
    private final StatusRepository statusRepository;
    private final PaymentMethodRepository paymentMethodRepository;
    private final AddressTypeRepository addressTypeRepository;
    private final ProductRepository productRepository;
    private final CartRepository cartRepository;
    private final TransportDetailRepository transportDetailRepository;
    private final BillingDetailRepository billingDetailRepository;
    private final EmailSender emailSender;
    private final SecurityUtils securityUtils;
    private final ValidationUtils validationUtils;

    @Transactional(readOnly = true)
    public List<OrderHistoryResponse> getOrderHistoryByUserId(Integer userId) {
        if (userId == null) throw new InvalidInputException();

        User searchedUser = userRepository.findById(userId).orElse(null);
        if (searchedUser == null || Boolean.TRUE.equals(searchedUser.getIsDeleted())) {
            throw new ResourceNotFoundException("userNotFound");
        }
        if (!securityUtils.canAccessUser(searchedUser)) throw new ForbiddenOperationException();

        return searchedUser.getOrderHistoryList().stream()
                .map(OrderHistoryResponse::fromEntity)
                .toList();
    }

    // Fix #30: cancelOrder most a generált orderId alapján keres, nem DB PK alapján
    public void cancelOrder(Integer orderId, Integer cancelerUserId) {
        if (orderId == null) throw new InvalidInputException();

        OrderHistory searchedOrderHistory = orderHistoryRepository.findByOrderId(orderId).orElse(null);
        if (searchedOrderHistory == null || Boolean.TRUE.equals(searchedOrderHistory.getIsCanceled())) {
            throw new ResourceNotFoundException("orderNotFound");
        }
        if (searchedOrderHistory.getOrderUser() != null && !securityUtils.canAccessUser(searchedOrderHistory.getOrderUser())) {
            throw new ForbiddenOperationException();
        }

        String authenticatedEmail = securityUtils.getAuthenticatedEmail();
        if (authenticatedEmail != null) {
            User cancelerUser = userRepository.findByEmail(authenticatedEmail).orElse(null);
            if (cancelerUser != null && !Boolean.TRUE.equals(cancelerUser.getIsDeleted())) {
                if (cancelerUserId != null && cancelerUserId != 0 && !securityUtils.isAdmin() && !cancelerUserId.equals(cancelerUser.getId())) {
                    throw new ForbiddenOperationException();
                }
                searchedOrderHistory.setCancelerUser(cancelerUser);
            }
        }

        Status canceledStatus = statusRepository.findById(OrderStatusConstants.CANCELED).orElse(null);
        if (canceledStatus == null) {
            throw new ResourceNotFoundException("statusNotFound");
        }

        // Készlet visszaállítása a lemondott rendelésből
        if (searchedOrderHistory.getProducts() != null) {
            for (OrderProduct orderProduct : searchedOrderHistory.getProducts()) {
                if (orderProduct == null || orderProduct.getOrderProduct() == null || orderProduct.getAmount() == null) continue;
                Product product = orderProduct.getOrderProduct();
                product.setAmount(product.getAmount() + orderProduct.getAmount());
                productRepository.save(product);
            }
        }

        searchedOrderHistory.setStatus(canceledStatus);
        searchedOrderHistory.setCanceledAt(LocalDateTime.now());
        searchedOrderHistory.setIsCanceled(true);
        orderHistoryRepository.save(searchedOrderHistory);

        // Async email
        emailSender.sendEmailAboutCancelledOrder(searchedOrderHistory.getEmail());
    }

    public OrderResponse sendOrder(OrderRequest request, Integer cartId) {
        if (cartId == null) throw new InvalidInputException();

        PaymentMethod searchedPaymentMethod = paymentMethodRepository.findById(request.paymentMethodId()).orElse(null);
        Cart searchedCart = cartRepository.findById(cartId).orElse(null);

        if (searchedPaymentMethod == null) throw new ResourceNotFoundException("paymentMethodNotFound");
        if (searchedCart == null) throw new ResourceNotFoundException("cartNotFound");
        if (!securityUtils.canAccessUser(searchedCart.getCartUser())) throw new ForbiddenOperationException();

        // Email és telefon validáció
        if (!validationUtils.isEmailValid(request.email().trim())) {
            throw new BusinessValidationException("invalidEmail");
        }
        if (!isPhoneValid(request.phone())) {
            throw new BusinessValidationException("invalidPhone");
        }

        // Billing detail mapping
        AddressType billingAddressType = addressTypeRepository.findById(request.billingDetail().addressTypeId()).orElse(null);
        if (billingAddressType == null) throw new ResourceNotFoundException("addressTypeNotFound");
        if (!isValidAddress(request.billingDetail().postCode(), request.billingDetail().town())) {
            throw new BusinessValidationException("invalidBillingDetails");
        }
        if (request.billingDetail().taxNumber() != null && !isValidTaxNumber(request.billingDetail().taxNumber())) {
            throw new BusinessValidationException("invalidBillingDetails");
        }

        BillingDetail billingDetail = new BillingDetail();
        billingDetail.setPostCode(request.billingDetail().postCode());
        billingDetail.setTown(request.billingDetail().town());
        billingDetail.setAddress(request.billingDetail().address());
        billingDetail.setHouseNumber(request.billingDetail().houseNumber());
        billingDetail.setCompanyName(request.billingDetail().companyName());
        billingDetail.setTaxNumber(request.billingDetail().taxNumber());
        billingDetail.setOther(request.billingDetail().other());
        billingDetail.setBillingAddressType(billingAddressType);

        // Transport detail mapping
        AddressType transportAddressType = addressTypeRepository.findById(request.transportDetail().addressTypeId()).orElse(null);
        if (transportAddressType == null) throw new ResourceNotFoundException("addressTypeNotFound");
        if (!isValidAddress(request.transportDetail().postCode(), request.transportDetail().town())) {
            throw new BusinessValidationException("invalidTransportDetails");
        }

        TransportDetail transportDetail = new TransportDetail();
        transportDetail.setPostCode(request.transportDetail().postCode());
        transportDetail.setTown(request.transportDetail().town());
        transportDetail.setAddress(request.transportDetail().address());
        transportDetail.setHouseNumber(request.transportDetail().houseNumber());
        transportDetail.setOther(request.transportDetail().other());
        transportDetail.setTransportAddressType(transportAddressType);

        if (searchedCart.getCartProductList() == null || searchedCart.getCartProductList().isEmpty()) {
            throw new ConflictException("cartEmpty");
        }

        // Order összeállítása
        OrderHistory newOrder = new OrderHistory();
        newOrder.setFirstName(request.firstName());
        newOrder.setLastName(request.lastName());
        newOrder.setPhone(request.phone());
        newOrder.setEmail(request.email());
        newOrder.setPaymentMethod(searchedPaymentMethod);
        newOrder.setOrderUser(searchedCart.getCartUser());
        // Fix #20: orderedAt beállítása
        newOrder.setOrderedAt(new Date());

        if (request.userId() != null) {
            User searchedUser = userRepository.findById(request.userId()).orElse(null);
            if (searchedUser == null || Boolean.TRUE.equals(searchedUser.getIsDeleted())) {
                throw new ResourceNotFoundException("userNotFound");
            }
            if (!securityUtils.canAccessUser(searchedUser)) throw new ForbiddenOperationException();
            newOrder.setOrderUser(searchedUser);
        }

        int sumPrice = 0;
        List<OrderProduct> orderedProductList = new ArrayList<>();
        for (CartProduct productFromCart : searchedCart.getCartProductList()) {
            if (productFromCart == null || Boolean.TRUE.equals(productFromCart.getIsDeleted())) continue;

            Product product = productFromCart.getCartProduct();
            if (product == null || Boolean.TRUE.equals(product.getIsDeleted())) {
                throw new ConflictException("productNotAvailable");
            }
            if (productFromCart.getAmount() == null || productFromCart.getAmount() <= 0) {
                throw new BusinessValidationException("invalidAmount");
            }
            if (product.getAmount() < productFromCart.getAmount()) {
                throw new ConflictException("insufficientStock");
            }

            product.setAmount(product.getAmount() - productFromCart.getAmount());
            OrderProduct newOrderProduct = new OrderProduct(productFromCart.getAmount(), product);
            newOrderProduct.setOrderHistory(newOrder);
            newOrderProduct.setCreatedAt(new Date());
            orderedProductList.add(newOrderProduct);
            productRepository.save(product);

            // Fix #17: Kedvezmény figyelembe vétele az összárnál
            int discount = product.getDiscount() != null ? product.getDiscount() : 0;
            int discountedPrice = product.getPrice() * (100 - discount) / 100;
            sumPrice += (discountedPrice * productFromCart.getAmount());
        }

        if (orderedProductList.isEmpty()) throw new ConflictException("cartEmpty");

        newOrder.setOrderTransportDetail(transportDetailRepository.save(transportDetail));
        newOrder.setOrderBillingDetail(billingDetailRepository.save(billingDetail));
        // Fix #1: OrderProduct-ok CascadeType.PERSIST-tel automatikusan mentődnek
        newOrder.setProducts(orderedProductList);

        Status initialStatus = statusRepository.findById(OrderStatusConstants.PENDING).orElse(null);
        if (initialStatus == null) throw new ResourceNotFoundException("statusNotFound");

        newOrder.setStatus(initialStatus);
        newOrder.setIsCanceled(false);

        // Fix #11: Egyedibb orderId generálás
        int generatedOrderId = generateUniqueOrderId();
        newOrder.setOrderId(generatedOrderId);

        orderHistoryRepository.save(newOrder);
        cartRepository.clearCart(cartId);

        // Async email – egyszerű rendelés-megerősítő (verifikációs kód eltávolítva, mert nem volt eltárolva)
        emailSender.sendEmailAboutOrder(newOrder.getEmail());

        return new OrderResponse(newOrder.getOrderId(), sumPrice);
    }

    // Fix: Pagination metaadatok megőrzése – Page-et adunk vissza DTO-val
    @Transactional(readOnly = true)
    public Page<OrderHistoryResponse> getAllOrderHistory(Pageable pageable) {
        if (!securityUtils.isAdmin()) throw new ForbiddenOperationException();
        return orderHistoryRepository.findAll(pageable)
                .map(OrderHistoryResponse::fromEntity);
    }

    /**
     * Egyedi rendelés-azonosító generálása, ütközés-ellenőrzéssel.
     * Az OrderHistory.orderId mezőn unique constraint is van (DB szintű védelem),
     * így még ha két szál egyszerre generálna azonos ID-t, a DB megakadályozza a duplikációt.
     */
    private int generateUniqueOrderId() {
        int maxAttempts = 20;
        for (int i = 0; i < maxAttempts; i++) {
            int candidate = (UUID.randomUUID().hashCode() & Integer.MAX_VALUE);
            if (candidate == 0) candidate = 1;
            if (orderHistoryRepository.findByOrderId(candidate).isEmpty()) {
                return candidate;
            }
            log.debug("OrderId ütközés, újrapróbálkozás: kísérlet {}/{}", i + 1, maxAttempts);
        }
        throw new ConflictException("orderIdGenerationFailed");
    }

    private Boolean isValidAddress(Integer postCode, String town) {
        if (postCode == null || postCode < 1000 || postCode > 9999 || town == null) return false;
        String normalizedTown = town.trim();
        if (normalizedTown.isEmpty() || normalizedTown.length() > 100) return false;
        return normalizedTown.matches("^[\\p{L} .'-]+$");
    }

    private Boolean isValidTaxNumber(Long taxNumber) {
        if (taxNumber == null || taxNumber < 0) return false;
        String taxNumberAsText = String.valueOf(taxNumber);
        List<String> taxNumbersOfArea = List.of("02", "22", "03", "23", "04", "24", "05", "25", "06", "26", "07", "27", "08", "28", "09", "29", "10", "30", "11", "31", "12", "32", "13", "33", "14", "34", "15", "35", "16", "36", "17", "37", "18", "38", "19", "39", "20", "40", "41", "42", "43", "44", "51");
        List<String> typeOfTaxes = List.of("1", "2", "3", "4", "5");
        if (taxNumberAsText.length() != 11) return false;
        if (!typeOfTaxes.contains(String.valueOf(taxNumberAsText.charAt(10)))) return false;
        return taxNumbersOfArea.contains(taxNumberAsText.substring(8, 10));
    }

    private Boolean isPhoneValid(String phoneNumber) {
        if (phoneNumber == null) return false;
        String normalizedPhone = phoneNumber.trim();
        if (normalizedPhone.length() != 9 || !normalizedPhone.chars().allMatch(Character::isDigit)) return false;
        List<String> phoneServiceCodes = List.of("30", "20", "70", "50", "31");
        return phoneServiceCodes.contains(normalizedPhone.substring(0, 2));
    }
}