package com.example.badogosShop.config.ratelimit;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Rate Limiting Filter – védi a szervert a túlzott kéréstől.
 *
 * IP cím alapján korlátozza a kérések számát:
 * - Általános végpontok: 60 kérés / perc (alapértelmezett)
 * - Autentikációs végpontok (login, register, jelszó reset): 10 kérés / perc
 *
 * Ha a limit túl van lépve, 429 Too Many Requests választ ad.
 */
@Slf4j
@Component
@Order(Ordered.HIGHEST_PRECEDENCE + 1)
public class RateLimitFilter extends OncePerRequestFilter {

    @Value("${app.rate-limit.general.max-requests:60}")
    private int generalMaxRequests;

    @Value("${app.rate-limit.general.time-window-seconds:60}")
    private int generalTimeWindowSeconds;

    @Value("${app.rate-limit.auth.max-requests:10}")
    private int authMaxRequests;

    @Value("${app.rate-limit.auth.time-window-seconds:60}")
    private int authTimeWindowSeconds;

    // Key: "IP:windowNumber" → Value: request count
    private final Map<String, AtomicInteger> requestCounts = new ConcurrentHashMap<>();

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        String clientIp = getClientIp(request);
        String path = request.getRequestURI();

        boolean isAuthEndpoint = isAuthEndpoint(path);
        int maxRequests = isAuthEndpoint ? authMaxRequests : generalMaxRequests;
        int timeWindowSeconds = isAuthEndpoint ? authTimeWindowSeconds : generalTimeWindowSeconds;

        String bucket = isAuthEndpoint ? "auth" : "general";
        long windowNumber = System.currentTimeMillis() / (timeWindowSeconds * 1000L);
        String key = clientIp + ":" + bucket + ":" + windowNumber;

        AtomicInteger counter = requestCounts.computeIfAbsent(key, k -> new AtomicInteger(0));
        int currentCount = counter.incrementAndGet();

        // Rate limit headers hozzáadása
        response.setHeader("X-RateLimit-Limit", String.valueOf(maxRequests));
        response.setHeader("X-RateLimit-Remaining", String.valueOf(Math.max(0, maxRequests - currentCount)));

        if (currentCount > maxRequests) {
            log.warn("Rate limit túllépve – IP: {}, végpont: {}, bucket: {}, count: {}/{}",
                    clientIp, path, bucket, currentCount, maxRequests);

            response.setStatus(429);
            response.setContentType("application/json");
            response.setCharacterEncoding(StandardCharsets.UTF_8.name());
            response.setHeader("Retry-After", String.valueOf(timeWindowSeconds));

            String jsonResponse = """
                    {"statusText":"tooManyRequests","message":"Túl sok kérés. Próbáld újra %d másodperc múlva.","timestamp":%d}"""
                    .formatted(timeWindowSeconds, System.currentTimeMillis());

            response.getWriter().write(jsonResponse);
            return;
        }

        filterChain.doFilter(request, response);
    }

    /**
     * Autentikációs végpontok – ezekre szigorúbb limit vonatkozik.
     */
    private boolean isAuthEndpoint(String path) {
        return path.startsWith("/user/login")
                || path.startsWith("/user/register")
                || path.startsWith("/user/verificationCode")
                || path.startsWith("/user/check")
                || path.startsWith("/user/password");
    }

    /**
     * Kliens IP cím meghatározása (proxy mögötti IP is).
     */
    private String getClientIp(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isBlank()) {
            return xForwardedFor.split(",")[0].trim();
        }
        String xRealIp = request.getHeader("X-Real-IP");
        if (xRealIp != null && !xRealIp.isBlank()) {
            return xRealIp.trim();
        }
        return request.getRemoteAddr();
    }

    /**
     * Régi counter bejegyzések takarítása – 5 percenként fut.
     * Eltávolítja azokat az entry-ket, amelyek már régebbi időablakhoz tartoznak.
     */
    @Scheduled(fixedRate = 300_000) // 5 percenként
    public void cleanup() {
        long currentGeneralWindow = System.currentTimeMillis() / (generalTimeWindowSeconds * 1000L);
        long currentAuthWindow = System.currentTimeMillis() / (authTimeWindowSeconds * 1000L);

        int removed = 0;
        var iterator = requestCounts.entrySet().iterator();
        while (iterator.hasNext()) {
            var entry = iterator.next();
            String key = entry.getKey();
            // Key formátum: "IP:bucket:windowNumber"
            String[] parts = key.split(":");
            if (parts.length >= 3) {
                try {
                    long windowNumber = Long.parseLong(parts[parts.length - 1]);
                    String bucket = parts[parts.length - 2];
                    long currentWindow = "auth".equals(bucket) ? currentAuthWindow : currentGeneralWindow;
                    if (windowNumber < currentWindow) {
                        iterator.remove();
                        removed++;
                    }
                } catch (NumberFormatException ignored) {
                    iterator.remove();
                    removed++;
                }
            }
        }
        if (removed > 0) {
            log.debug("Rate limiter cleanup: {} régi bejegyzés eltávolítva", removed);
        }
    }

    /**
     * Swagger / Actuator / statikus fájlok kihagyása a rate limitingből.
     */
    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI();
        return path.startsWith("/v3/api-docs")
                || path.startsWith("/swagger-ui")
                || path.startsWith("/actuator")
                || path.startsWith("/pfp/")
                || path.startsWith("/products/");
    }
}
