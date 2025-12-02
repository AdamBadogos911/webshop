package com.example.badogosShop.entity;


import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.antlr.v4.runtime.misc.NotNull;

import javax.validation.constraints.Size;
import java.util.List;

@Entity
@Table(name = "address_type")
@Getter
@Setter
@ToString
@NoArgsConstructor
public class AddressType {

        @Id
        @GeneratedValue
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
