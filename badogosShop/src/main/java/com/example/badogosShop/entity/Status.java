package com.example.badogosShop.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Entity
@Table(name = "status")
@Getter
@Setter
@ToString(exclude = {"orderHistoryList"})
@NoArgsConstructor
public class Status {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "name")
    @NotNull
    @Size(max = 100)
    private String name;

    @OneToMany(mappedBy = "status", fetch = FetchType.LAZY, cascade = {})
    @JsonIgnore
    private List<OrderHistory> orderHistoryList;
}
