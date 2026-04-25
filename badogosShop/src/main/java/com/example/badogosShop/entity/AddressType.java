package com.example.badogosShop.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Entity
@Table(name = "address_type")
@Getter
@Setter
@ToString(exclude = {"billingDetails", "transportDetails"})
@NoArgsConstructor
public class AddressType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "name")
    @NotNull
    @Size(max = 100)
    private String name;

    @OneToMany(mappedBy = "billingAddressType", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnore
    private List<BillingDetail> billingDetails;

    @OneToMany(mappedBy = "transportAddressType", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnore
    private List<TransportDetail> transportDetails;
}
