package com.example.badogosShop.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Null;
import javax.validation.constraints.Size;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "brand")
@Getter
@Setter
@ToString
@NoArgsConstructor

public class Brand {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "name")
    @NotNull
    @Size(max = 100)
    private String name;

    @Column(name = "is_deleted")
    @NotNull
    @JsonIgnore
    private boolean isDeleted = false;

    @Column(name = "deleted_at")
    @Null
    @JsonIgnore
    private LocalDateTime deletedAt;

    @OneToMany(mappedBy = "brand", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnore
    private List<Product> productList;


}
