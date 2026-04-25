package com.example.badogosShop.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name = "details")
@Getter
@Setter
@ToString(exclude = {"product"})
@NoArgsConstructor
public class Details {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "weight")
    private Double weightInKg;

    @Column(name = "material")
    private String material;

    @Column(name = "length")
    private Double lengthInCm;

    @Column(name = "height")
    private Double heightInCm;

    @Column(name = "width")
    private Double widthInCm;

    @Column(name = "size")
    private String size;

    @Column(name = "is_set")
    private Boolean isSet;

    @OneToOne(mappedBy = "detail", cascade = CascadeType.ALL)
    @JsonIgnore
    private Product product;

    public Details(Double weightInKg, String material, Double lengthInCm, Double heightInCm, Double widthInCm, String size, Boolean isSet) {
        this.weightInKg = weightInKg;
        this.material = material;
        this.lengthInCm = lengthInCm;
        this.heightInCm = heightInCm;
        this.widthInCm = widthInCm;
        this.size = size;
        this.isSet = isSet;
    }

    public Details(Integer id, Double weightInKg, String material, Double lengthInCm, Double heightInCm, Double widthInCm, String size, Boolean isSet, Product product) {
        this.id = id;
        this.weightInKg = weightInKg;
        this.material = material;
        this.lengthInCm = lengthInCm;
        this.heightInCm = heightInCm;
        this.widthInCm = widthInCm;
        this.size = size;
        this.isSet = isSet;
        this.product = product;
    }
}
