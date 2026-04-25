package com.example.badogosShop.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
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
@Table(name = "`user`")
@Getter
@Setter
@ToString(exclude = {"password", "reviewList", "orderHistoryList", "canceledOrderHistory", "savedDetails", "cart", "role"})
@NoArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "email", unique = true)
    @Size(max = 255)
    @NotNull
    private String email;

    @Column(name = "password")
    @NotNull
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String password;

    @Column(name = "first_name")
    @NotNull
    @Size(max = 100)
    private String firstName;

    @Column(name = "last_name")
    @NotNull
    @Size(max = 100)
    private String lastName;

    @Column(name = "phone_number")
    @Size(max = 30)
    private String phoneNumber;

    @Column(name = "pfp_path")
    @NotNull
    private String pfpPath = "";

    @Column(name = "is_deleted")
    @JsonIgnore
    private Boolean isDeleted = false;

    @Column(name = "deleted_at")
    @JsonIgnore
    private LocalDateTime deletedAt;

    @Column(name = "last_login")
    private LocalDateTime lastLogin;

    @Column(name = "register_finished_at")
    private Date registerFinishedAt;

    @Column(name = "verification_code")
    @JsonIgnore
    private String verificationCode;

    @Column(name = "verification_code_expires_at")
    @JsonIgnore
    private LocalDateTime verificationCodeExpiresAt;

    @OneToMany(mappedBy = "author", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnoreProperties({"author"})
    private List<Review> reviewList;

    @OneToMany(mappedBy = "orderUser", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnoreProperties(value = {"orderUser"}, allowSetters = true)
    private List<OrderHistory> orderHistoryList;

    @OneToMany(mappedBy = "cancelerUser", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnore
    private List<OrderHistory> canceledOrderHistory;

    @OneToMany(mappedBy = "addressUser", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnoreProperties({"addressUser"})
    private List<AddressUser> savedDetails;

    @OneToOne(mappedBy = "cartUser", fetch = FetchType.LAZY, cascade = {})
    private Cart cart;

    @ManyToOne()
    @JoinColumn(name = "role_id")
    private Role role;
}