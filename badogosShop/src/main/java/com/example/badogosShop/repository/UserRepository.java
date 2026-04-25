package com.example.badogosShop.repository;

import com.example.badogosShop.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Integer> {

    Optional<User> findByEmail(String email);

    @Procedure(name = "deleteUserById", procedureName = "deleteUserById")
    void deleteUserById(@Param("idIN") Integer id);
}