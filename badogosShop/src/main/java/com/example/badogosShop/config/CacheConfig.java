package com.example.badogosShop.config;

import com.github.benmanes.caffeine.cache.Caffeine;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.caffeine.CaffeineCache;
import org.springframework.cache.support.SimpleCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.Duration;
import java.util.List;

/**
 * Cache konfiguráció Caffeine-nel.
 *
 * Különböző cache-ek különböző lejárati idővel (TTL):
 * - Ritkán változó adatok (kategóriák, márkák, stb.): 30-60 perc
 * - Gyakrabban változó adatok (mostViewed): 5 perc
 * - Termék lista: 10 perc
 */
@Configuration
@EnableCaching
public class CacheConfig {

    @Bean
    public CacheManager cacheManager() {
        SimpleCacheManager cacheManager = new SimpleCacheManager();
        cacheManager.setCaches(List.of(
                buildCache("categories", 30, 200),
                buildCache("mainCategories", 30, 50),
                buildCache("subCategories", 30, 500),
                buildCache("brands", 60, 100),
                buildCache("paymentMethods", 60, 20),
                buildCache("addressTypes", 60, 20),
                buildCache("mostViewedProducts", 5, 50),
                buildCache("allProducts", 10, 500)
        ));
        return cacheManager;
    }

    private CaffeineCache buildCache(String name, int minutesToExpire, int maxSize) {
        return new CaffeineCache(name, Caffeine.newBuilder()
                .expireAfterWrite(Duration.ofMinutes(minutesToExpire))
                .maximumSize(maxSize)
                .recordStats()
                .build());
    }
}
