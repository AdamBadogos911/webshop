package com.example.badogosShop.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name = "product_image")
@Getter
@Setter
@ToString(exclude = {"product"})
@NoArgsConstructor
public class ProductImage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "image_path")
    @NotNull
    private String imagePath;

    @Column(name = "placement")
    @NotNull
    private Integer placement;

    @ManyToOne()
    @JoinColumn(name = "product_id")
    @JsonIgnore
    private Product product;
}
