package com.example.badogosShop.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Entity
@Table(name = "transport_detail")
@Getter
@Setter
@ToString(exclude = {"transportAddressType", "orderHistoryList", "savedDetails"})
@NoArgsConstructor
public class TransportDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "post_code")
    @NotNull
    @Min(1000)
    @Max(9999)
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
    @Min(1)
    @Max(999)
    private Integer houseNumber;

    @Column(name = "other")
    private String other;

    @ManyToOne(cascade = {})
    @JoinColumn(name = "address_type_id")
    private AddressType transportAddressType;

    @OneToMany(mappedBy = "orderTransportDetail", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnore
    private List<OrderHistory> orderHistoryList;

    @OneToMany(mappedBy = "savedTransportDetails", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnore
    private List<AddressUser> savedDetails;
}
