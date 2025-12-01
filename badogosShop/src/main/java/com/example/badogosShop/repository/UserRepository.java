package com.example.badogosShop.repository;

import com.example.badogosShop.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

public interface UserRepository extends JpaRepository<User, Integer> {

    @Procedure(name = "login", procedureName = "login")
    User login(@Param("emailIN") String email, @Param("passwordIN") String password);
}