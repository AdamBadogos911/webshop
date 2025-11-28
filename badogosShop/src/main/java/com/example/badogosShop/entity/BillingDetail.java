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
import java.util.List;

@Entity
@Table(name = "billing_detail")
@Getter
@Setter
@ToString
@NoArgsConstructor
public class BillingDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "post_code")
    @NotNull
    @Size(max = 4)
    private Integer postCode;

    @Column(name = "town")
    @NotNull
    @Size(max = 100)
    private String town;

    @Column(name = "address")
    @NotNull
    @Size(max = 100)
    private String address;

    @Column(name = "house_number")
    @NotNull
    @Size(max = 3)
    private Integer houseNumber;

    @Column(name = "company_name")
    @Null
    @Size(max = 100)
    private String companyName;

    @Column(name = "company_tax_number")
    @Null
    private Integer taxNumber;

    @Column(name = "other")
    @Null
    private String other;

    @ManyToOne(cascade = {})
    @JoinColumn(name = "address_type_id")
    private AddressType billingAddressType;

    @OneToMany(mappedBy = "orderBillingDetail", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnore
    private List<OrderHistory> billingDetailsOrders;

    @OneToMany(mappedBy = "savedBillingDetails", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnore
    private List<AddressUser> savedDetails;


}
