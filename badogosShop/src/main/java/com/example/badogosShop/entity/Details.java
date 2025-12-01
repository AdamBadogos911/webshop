package com.example.badogosShop.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.Null;

@Entity
@Table(name = "details")
@Getter
@Setter
@ToString
@NoArgsConstructor

public class Details {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "weight")
    @Null
    private Double weightInKg;

    @Column(name = "material")
    @Null
    private String material;

    @Column(name = "length")
    @Null
    private Double lengthInCm;

    @Column(name = "height")
    @Null
    private Double heightInCm;

    @Column(name = "width")
    @Null
    private Double widthInCm;

    @Column(name = "size")
    @Null
    private Integer size;

    @Column(name = "is_set")
    @Null
    private Boolean isSet;

    @OneToOne(mappedBy = "detail", cascade = {})
    @JsonIgnore
    private Product product;


}
