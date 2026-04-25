package com.example.badogosShop.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name = "address_user")
@Getter
@Setter
@ToString
@NoArgsConstructor

public class AddressUser {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @ManyToOne(cascade = {})
    @JoinColumn(name = "user_id")
    @JsonIgnoreProperties({"cart", "savedDetails"})
    private User addressUser;

    @ManyToOne(cascade = {})
    @JoinColumn(name = "billing_detail_id")
    private BillingDetail savedBillingDetails;

    @ManyToOne(cascade = {})
    @JoinColumn(name = "transport_detail_id")
    private TransportDetail savedTransportDetails;
}
