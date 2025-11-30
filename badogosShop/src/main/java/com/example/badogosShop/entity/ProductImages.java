package com.example.badogosShop.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

@Entity
@Table(name = "product_images")
@Getter
@Setter
@ToString
@NoArgsConstructor

public class ProductImages {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "image_path")
    @NotNull
    private String imagePath;

    @Column(name = "placement")
    @NotNull
    @Size(max = 2)
    private Integer placement;

    @OneToOne(mappedBy = "images", cascade = {})
    @JsonIgnore
    private Product product;


}
