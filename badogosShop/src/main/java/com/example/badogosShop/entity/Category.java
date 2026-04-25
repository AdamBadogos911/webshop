package com.example.badogosShop.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "category")
@Getter
@Setter
@ToString(exclude = {"mainCategory", "subCategories", "productList"})
@NoArgsConstructor
@NamedStoredProcedureQueries({
        @NamedStoredProcedureQuery(name = "getMainCategory", procedureName = "getMainCategory", resultClasses = Category.class),
        @NamedStoredProcedureQuery(name = "getSubCatByPrimCat", procedureName = "getSubCatByPrimCat", parameters = {
                @StoredProcedureParameter(name = "primCategoryIdIN", mode = ParameterMode.IN, type = Integer.class)
        }, resultClasses = Category.class)
})
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "name")
    @NotNull
    private String name;

    @Column(name = "is_deleted")
    @NotNull
    private Boolean isDeleted = false;

    @ManyToOne(cascade = {})
    @JoinColumn(name = "category_id")
    @JsonIgnore
    private Category mainCategory;

    @OneToMany(mappedBy = "mainCategory", cascade = {})
    @JsonIgnore
    private List<Category> subCategories;

    @Column(name = "deleted_at")
    @JsonIgnore
    private LocalDateTime deletedAt;

    @OneToMany(mappedBy = "category")
    @JsonIgnore
    private List<Product> productList;
}
