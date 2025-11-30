package com.example.badogosShop.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;
import java.util.Date;

@Entity
@Table(name = "cart")
@Getter
@Setter
@ToString
@NoArgsConstructor

public class Cart {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "last_modified_at")
    private LocalDateTime lastModifiedAt;

    @Column(name = "created_at")
    private Date createdAt;

    @ManyToOne(cascade = {})
    @JoinColumn(name = "user_id")
    @JsonIgnore
    private User cartUser;

    @OneToMany(mappedBy = "cart", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnoreProperties({"cart"})
    private List<CartProduct> cartProductList;


}
