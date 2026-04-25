package com.example.badogosShop.config.security;

import com.example.badogosShop.entity.User;
import com.example.badogosShop.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class UserSetter implements UserDetailsService {

    private final UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User loggedUser = userRepository.findByEmail(email).orElseThrow(() -> new UsernameNotFoundException("userNotFound"));

        if (Boolean.TRUE.equals(loggedUser.getIsDeleted())) {
            throw new UsernameNotFoundException("userNotFound");
        }

        // Null-safe role kezelés — ha nincs role, default "ROLE_user" jön
        String roleName = (loggedUser.getRole() != null && loggedUser.getRole().getName() != null)
                ? loggedUser.getRole().getName()
                : "ROLE_user";

        List<GrantedAuthority> authorities = List.of(new SimpleGrantedAuthority(roleName));
        return new org.springframework.security.core.userdetails.User(loggedUser.getEmail(), loggedUser.getPassword(), authorities);
    }
}