package com.example.badogosShop.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.NotNull;
import java.time.LocalDateTime;
import java.util.Date;

@Entity
@Table(name = "cart_product")
@Getter
@Setter
@ToString
@NoArgsConstructor

public class CartProduct {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "last_modified_at")
    private LocalDateTime lastModifiedAt;

    @Column(name = "created_at")
    private Date createdAt;

    @Column(name = "amount")
    @NotNull
    private Integer amount;

    @ManyToOne(cascade = {})
    @JoinColumn(name = "cart_id")
    private Cart cart;

}
