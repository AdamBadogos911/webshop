package com.example.badogosShop.dto;

import com.example.badogosShop.entity.*;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

/**
 * DTO az OrderHistory entitáshoz – megoldja a LazyInitializationException problémát.
 * Minden lazy-loaded mező a @Transactional service metóduson belül kerül kiolvasásra.
 */
public record OrderHistoryResponse(
        Integer id,
        String firstName,
        String lastName,
        String phone,
        String email,
        Date orderedAt,
        LocalDateTime canceledAt,
        Boolean isCanceled,
        Integer orderId,
        SimpleUserInfo orderUser,
        SimpleUserInfo cancelerUser,
        SimpleInfo paymentMethod,
        SimpleInfo status,
        BillingDetailInfo billingDetail,
        TransportDetailInfo transportDetail,
        List<OrderProductInfo> products
) {
    public record SimpleUserInfo(Integer id, String email, String firstName, String lastName, String pfpPath) {}
    public record SimpleInfo(Integer id, String name) {}
    public record BillingDetailInfo(Integer id, Integer postCode, String town, String address, Integer houseNumber, String companyName, Long taxNumber, String other, String addressTypeName) {}
    public record TransportDetailInfo(Integer id, Integer postCode, String town, String address, Integer houseNumber, String other, String addressTypeName) {}
    public record OrderProductInfo(Integer id, Integer amount, Date createdAt, ProductResponse product) {}

    public static OrderHistoryResponse fromEntity(OrderHistory o) {
        SimpleUserInfo userInfo = null;
        if (o.getOrderUser() != null) {
            User u = o.getOrderUser();
            userInfo = new SimpleUserInfo(u.getId(), u.getEmail(), u.getFirstName(), u.getLastName(), u.getPfpPath());
        }

        SimpleUserInfo cancelerInfo = null;
        if (o.getCancelerUser() != null) {
            User c = o.getCancelerUser();
            cancelerInfo = new SimpleUserInfo(c.getId(), c.getEmail(), c.getFirstName(), c.getLastName(), c.getPfpPath());
        }

        SimpleInfo paymentInfo = null;
        if (o.getPaymentMethod() != null) {
            paymentInfo = new SimpleInfo(o.getPaymentMethod().getId(), o.getPaymentMethod().getName());
        }

        SimpleInfo statusInfo = null;
        if (o.getStatus() != null) {
            statusInfo = new SimpleInfo(o.getStatus().getId(), o.getStatus().getName());
        }

        BillingDetailInfo billingInfo = null;
        if (o.getOrderBillingDetail() != null) {
            BillingDetail b = o.getOrderBillingDetail();
            billingInfo = new BillingDetailInfo(b.getId(), b.getPostCode(), b.getTown(), b.getAddress(),
                    b.getHouseNumber(), b.getCompanyName(), b.getTaxNumber(), b.getOther(),
                    b.getBillingAddressType() != null ? b.getBillingAddressType().getName() : null);
        }

        TransportDetailInfo transportInfo = null;
        if (o.getOrderTransportDetail() != null) {
            TransportDetail t = o.getOrderTransportDetail();
            transportInfo = new TransportDetailInfo(t.getId(), t.getPostCode(), t.getTown(), t.getAddress(),
                    t.getHouseNumber(), t.getOther(),
                    t.getTransportAddressType() != null ? t.getTransportAddressType().getName() : null);
        }

        List<OrderProductInfo> productInfoList = List.of();
        if (o.getProducts() != null) {
            productInfoList = o.getProducts().stream()
                    .map(op -> new OrderProductInfo(
                            op.getId(),
                            op.getAmount(),
                            op.getCreatedAt(),
                            op.getOrderProduct() != null ? ProductResponse.fromEntity(op.getOrderProduct()) : null
                    ))
                    .toList();
        }

        return new OrderHistoryResponse(
                o.getId(), o.getFirstName(), o.getLastName(), o.getPhone(), o.getEmail(),
                o.getOrderedAt(), o.getCanceledAt(), o.getIsCanceled(), o.getOrderId(),
                userInfo, cancelerInfo, paymentInfo, statusInfo, billingInfo, transportInfo, productInfoList
        );
    }
}
