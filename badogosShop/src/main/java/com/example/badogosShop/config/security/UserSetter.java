package com.example.badogosShop.config.security;

import com.example.badogosShop.entity.User;
import com.example.badogosShop.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class UserSetter implements UserDetailsService {

    private final UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User loggedUser = userRepository.findByEmail(email).orElseThrow(() -> new UsernameNotFoundException("userNotFound"));
        List<GrantedAuthority> authorities = List.of(new SimpleGrantedAuthority(loggedUser.getRole().getName()));
        return new org.springframework.security.core.userdetails.User(loggedUser.getEmail(), loggedUser.getPassword(), authorities);
    }
}
