package com.example.badogosShop.config.email;

import jakarta.mail.internet.MimeMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

/**
 * Email küldésért felelős komponens.
 *
 * Minden publikus email metódus @Async – háttérszálon fut,
 * nem blokkolja az API választ. A hívó azonnal visszakapja a response-t,
 * az email "majd megérkezik" (általában másodperceken belül).
 *
 * Ha a JavaMailSender nincs konfigurálva (spring.mail.host nincs beállítva),
 * az email küldés kihagyásra kerül (warning log), de az alkalmazás elindul.
 */
@Slf4j
@Component
public class EmailSender {

    private final JavaMailSender javaMailSender;

    @Value("${app.mail.from:noreply@badogosShop.com}")
    private String fromEmail;

    // Ha JavaMailSender nincs konfigurálva → null (alkalmazás nem dob hibát)
    public EmailSender(@Autowired(required = false) JavaMailSender javaMailSender) {
        this.javaMailSender = javaMailSender;
        if (javaMailSender == null) {
            log.warn("JavaMailSender nincs konfigurálva. Email küldés nem lehetséges. Állítsd be a spring.mail.* property-ket.");
        }
    }

    @Async("emailTaskExecutor")
    public void sendVerificationCodeForPasswordReset(String toEmail, String verificationCode) {
        try {
            String htmlContent = loadEmailTemplate("VerificationCodeForPasswordResetTemplate.html");
            htmlContent = htmlContent.replace("%VERIFICATION_CODE%", verificationCode);
            sendHtmlEmail(toEmail, "BadogosShop - Jelszó Visszaállítás", htmlContent);
            log.info("Jelszó visszaállítás email sikeresen elküldve: {}", toEmail);
        } catch (Exception e) {
            log.error("Hiba a jelszó visszaállítás email küldésénél: {}", toEmail, e);
        }
    }

    @Async("emailTaskExecutor")
    public void sendEmailAboutRegistration(String toEmail) {
        try {
            String htmlContent = loadEmailTemplate("EmailAboutRegistrationTemplate.html");
            sendHtmlEmail(toEmail, "BadogosShop - Üdvözöljük!", htmlContent);
            log.info("Regisztrációs email sikeresen elküldve: {}", toEmail);
        } catch (Exception e) {
            log.error("Hiba a regisztrációs email küldésénél: {}", toEmail, e);
        }
    }

    @Async("emailTaskExecutor")
    public void sendEmailAboutOrder(String toEmail) {
        try {
            String htmlContent = loadEmailTemplate("EmailAboutOrderTemplate.html");
            sendHtmlEmail(toEmail, "BadogosShop - Rendelés Megerősítés", htmlContent);
            log.info("Rendelés megerősítő email sikeresen elküldve: {}", toEmail);
        } catch (Exception e) {
            log.error("Hiba a rendelés megerősítő email küldésénél: {}", toEmail, e);
        }
    }

    @Async("emailTaskExecutor")
    public void sendEmailAboutOrderWithVerificationCode(String toEmail, String verificationCode) {
        try {
            String htmlContent = loadEmailTemplate("EmailAboutOrderWithVCode.html");
            htmlContent = htmlContent.replace("%VERIFICATION_CODE%", verificationCode);
            sendHtmlEmail(toEmail, "BadogosShop - Rendelés Megerősítés + Verifikáció", htmlContent);
            log.info("Verifikációs kódos rendelés email sikeresen elküldve: {}", toEmail);
        } catch (Exception e) {
            log.error("Hiba a verifikációs kódos rendelés email küldésénél: {}", toEmail, e);
        }
    }

    @Async("emailTaskExecutor")
    public void sendEmailAboutCancelledOrder(String toEmail) {
        try {
            String htmlContent = loadEmailTemplate("EmailAboutCancelledOrderTemplate.html");
            sendHtmlEmail(toEmail, "BadogosShop - Rendelés Törlése", htmlContent);
            log.info("Rendelés törlés email sikeresen elküldve: {}", toEmail);
        } catch (Exception e) {
            log.error("Hiba a rendelés törlés email küldésénél: {}", toEmail, e);
        }
    }

    private void sendHtmlEmail(String to, String subject, String htmlContent) {
        if (javaMailSender == null) {
            log.warn("Email küldés kihagyva (mail nincs konfigurálva). Címzett: {}, Tárgy: {}", to, subject);
            return;
        }
        try {
            MimeMessage message = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, StandardCharsets.UTF_8.name());

            helper.setFrom(fromEmail);
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(htmlContent, true);

            javaMailSender.send(message);
        } catch (Exception e) {
            log.error("Hiba az HTML email küldésénél – címzett: {}, tárgy: {}", to, subject, e);
        }
    }

    /**
     * Email template betöltése a classpath-ról.
     * A templates a com/example/badogosShop/config/email/templates/ alatt vannak
     * (a Maven build bemásolja a pom.xml resource config miatt).
     */
    private String loadEmailTemplate(String templateName) {
        try {
            // Relatív útvonal az EmailSender osztályhoz képest
            var inputStream = getClass().getResourceAsStream("templates/" + templateName);

            if (inputStream == null) {
                log.warn("Email template nem található: {}", templateName);
                return "<h1>Email sablon nem érhető el</h1>";
            }

            StringBuilder contentBuilder = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(inputStream, StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    contentBuilder.append(line).append("\n");
                }
            }
            return contentBuilder.toString();
        } catch (Exception e) {
            log.error("Hiba az email template betöltésénél: {}", templateName, e);
            return "<h1>Email sablon betöltési hiba</h1>";
        }
    }
}
