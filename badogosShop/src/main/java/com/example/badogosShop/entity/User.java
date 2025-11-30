package com.example.badogosShop.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Null;
import javax.validation.constraints.Size;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "user")
@Getter
@Setter
@ToString
@NoArgsConstructor
@NamedStoredProcedureQueries({
        @NamedStoredProcedureQuery(name = "login", procedureName = "login", parameters = {
                @StoredProcedureParameter(name = "emailIn", mode = ParameterMode.IN, type = String.class),
                @StoredProcedureParameter(name = "passwordIN", mode = ParameterMode.IN, type = String.class),

        }, resultClasses = User.class)
})

public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "email")
    @Size(max = 255)
    @NotNull
    private String email;

    @Column(name = "password")
    @NotNull
    private String password;

    @Column(name = "first_name")
    @NotNull
    @Size(max = 100)
    private String lastName;

    @Column(name = "phone_number")
    @Null
    @Size(max = 30)
    private String phoneNumber;

    @Column(name = "pfp_path")
    @NotNull
    private String pfpPath="";

    @Column(name = "is_admin")
    private Boolean isAdmin = false;

    @Column(name = "is_deleted")
    private Boolean isDeleted = false;

    @Column(name = "deleted_at")
    @Null
    private LocalDateTime deletedAt;

    @Column(name = "last_login")
    @Null
    private LocalDateTime lastLogin;

    @Column(name = "register_finished_at")
    private Date registerFinishedAt;


    @OneToMany(mappedBy = "author", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnoreProperties({"author"})
    @Null
    private List<Review> reviewList;

    @OneToMany(mappedBy = "orderUser", fetch = FetchType.LAZY, cascade = {})
    @Null
    @JsonIgnoreProperties({"orderUser"})
    private List<OrderHistory> orderHistoryList;

    @OneToMany(mappedBy = "cancelerUser", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnore
    @Null
    private List<OrderHistory> canceledOrderHistory;

    @OneToMany(mappedBy = "addressUser", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnoreProperties({"addressUser"})
    @Null
    private List<AddressUser> savedDetails;

    @OneToMany(mappedBy = "cartUser", fetch = FetchType.LAZY, cascade = {})
    @Null
    private List<Cart> cart;


}
