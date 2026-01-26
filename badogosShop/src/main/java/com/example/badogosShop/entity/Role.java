package com.example.badogosShop.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import javax.validation.constraints.NotNull;
import java.util.List;

@Entity
@Table(name = "role")
@Getter
@Setter
@NoArgsConstructor
@ToString
@AllArgsConstructor
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name="name")
    @NotNull
    private String name;


    @OneToMany(
            mappedBy = "role",
            cascade = {}
    )
    @JsonIgnore
    private List<User> users;

    public Role(Integer id, String name) {
        this.id = id;
        this.name = name;
    }
}

