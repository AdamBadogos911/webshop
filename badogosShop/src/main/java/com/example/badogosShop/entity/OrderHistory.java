package com.example.badogosShop.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "order_history")
@Getter
@Setter
@ToString(exclude = {"orderUser", "orderBillingDetail", "orderTransportDetail", "paymentMethod", "status", "cancelerUser", "products"})
@NoArgsConstructor
public class OrderHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "first_name")
    @NotNull
    @Size(max = 100)
    private String firstName;

    @Column(name = "last_name")
    @NotNull
    @Size(max = 100)
    private String lastName;

    @Column(name = "phone")
    @NotNull
    @Size(max = 100)
    private String phone;

    @Column(name = "email")
    @NotNull
    @Size(max = 100)
    private String email;

    @Column(name = "ordered_at")
    private Date orderedAt;

    @Column(name = "canceled_at")
    private LocalDateTime canceledAt;

    @Column(name = "is_canceled")
    private Boolean isCanceled;

    @Column(name = "order_id", unique = true)
    @NotNull
    private Integer orderId;

    @ManyToOne(cascade = {})
    @JoinColumn(name = "user_id")
    @JsonIgnoreProperties({"cart", "savedDetails"})
    private User orderUser;

    @ManyToOne(cascade = {})
    @JoinColumn(name = "billing_detail_id")
    private BillingDetail orderBillingDetail;

    @ManyToOne(cascade = {})
    @JoinColumn(name = "transport_detail_id")
    private TransportDetail orderTransportDetail;

    @ManyToOne(cascade = {})
    @JoinColumn(name = "payment_method_id")
    private PaymentMethod paymentMethod;

    @ManyToOne(cascade = {})
    @JoinColumn(name = "status_id")
    private Status status;

    @ManyToOne(cascade = {})
    @JoinColumn(name = "canceler_user_id")
    private User cancelerUser;

    @OneToMany(mappedBy = "orderHistory", fetch = FetchType.LAZY, cascade = {CascadeType.PERSIST})
    @JsonIgnoreProperties({"orderHistory"})
    private List<OrderProduct> products;
}