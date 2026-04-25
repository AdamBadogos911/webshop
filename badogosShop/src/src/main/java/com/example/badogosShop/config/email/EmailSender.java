package com.example.badogosShop.config.email;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class EmailSender {

    public void sendVerificationCodeForPasswordReset(String toEmail, String verificationCode) {

    }

    public void sendEmailAboutCancelledOrder(String toEmail) {

    }

    public void sendEmailAboutRegistration(String toEmail) {

    }

    public void sendEmailAboutOrder(String toEmail) {

    }

    public void sendEmailAboutOrderWithVerificationCode(String toEmail, String verificationCode) {

    }
}
