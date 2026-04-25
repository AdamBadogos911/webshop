package com.example.badogosShop.config.security;

import com.example.badogosShop.entity.User;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

@Component
public class SecurityUtils {

    public String getAuthenticatedEmail() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated() || authentication instanceof AnonymousAuthenticationToken) {
            return null;
        }

        Object principal = authentication.getPrincipal();
        if (principal instanceof UserDetails userDetails) {
            return userDetails.getUsername();
        }
        if (principal instanceof String principalName && !"anonymousUser".equalsIgnoreCase(principalName)) {
            return principalName;
        }

        return null;
    }

    public boolean isAdmin() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null) {
            return false;
        }

        return authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .anyMatch(authority -> authority.equalsIgnoreCase("ROLE_admin") || authority.equalsIgnoreCase("ROLE_ADMIN"));
    }

    public boolean canAccessUser(User user) {
        return user != null && canAccessEmail(user.getEmail());
    }

    public boolean canAccessEmail(String email) {
        String authenticatedEmail = getAuthenticatedEmail();
        return authenticatedEmail != null && (isAdmin() || authenticatedEmail.equalsIgnoreCase(email));
    }
}
