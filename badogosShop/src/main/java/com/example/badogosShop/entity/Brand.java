package com.example.badogosShop.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "brand")
@Getter
@Setter
@ToString(exclude = {"productList"})
@NoArgsConstructor
@NamedStoredProcedureQueries({
        @NamedStoredProcedureQuery(name = "getAllBrand", procedureName = "getAllBrand", resultClasses = Brand.class),
        @NamedStoredProcedureQuery(name = "getBrandById", procedureName = "getBrandById", parameters = {
                @StoredProcedureParameter(name = "idIN", mode = ParameterMode.IN, type = Integer.class)
        }, resultClasses = Brand.class)
})
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
    private Boolean isDeleted = false;

    @Column(name = "deleted_at")
    @JsonIgnore
    private LocalDateTime deletedAt;

    @OneToMany(mappedBy = "brand", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnore
    private List<Product> productList;
}
