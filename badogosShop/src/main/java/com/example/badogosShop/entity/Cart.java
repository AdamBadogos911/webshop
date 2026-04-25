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
import java.util.List;

@Entity
@Table(name = "cart")
@Getter
@Setter
@ToString(exclude = {"cartUser", "cartProductList"})
@NoArgsConstructor
@NamedStoredProcedureQueries({
        @NamedStoredProcedureQuery(name = "getCartByUserId", procedureName = "getCartByUserId", parameters = {
                @StoredProcedureParameter(name = "idIN", mode = ParameterMode.IN, type = Integer.class)
        }, resultClasses = Cart.class),
        @NamedStoredProcedureQuery(name = "clearCart", procedureName = "clearCart", parameters = {
                @StoredProcedureParameter(name = "idIN", mode = ParameterMode.IN, type = Integer.class)
        })
})
public class Cart {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "last_modified_at")
    private LocalDateTime lastModifiedAt;

    @Column(name = "created_at")
    private Date createdAt;

    @OneToOne(cascade = {})
    @JoinColumn(name = "user_id")
    @JsonIgnore
    private User cartUser;

    @OneToMany(mappedBy = "cart", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnoreProperties({"cart"})
    private List<CartProduct> cartProductList;

    public Cart(User cartUser) {
        this.cartUser = cartUser;
        this.createdAt = new Date();
    }
}
