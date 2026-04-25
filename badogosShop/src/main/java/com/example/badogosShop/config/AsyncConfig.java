package com.example.badogosShop.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.Executor;

/**
 * Async és Scheduling konfiguráció.
 *
 * Az @EnableAsync lehetővé teszi az @Async annotáció használatát,
 * így az email küldés háttérszálon fut, nem blokkolja az API választ.
 *
 * Az @EnableScheduling lehetővé teszi a @Scheduled annotáció használatát
 * (pl. rate limiter cleanup task).
 */
@Configuration
@EnableAsync
@EnableScheduling
public class AsyncConfig {

    @Bean(name = "emailTaskExecutor")
    public Executor emailTaskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(2);
        executor.setMaxPoolSize(5);
        executor.setQueueCapacity(50);
        executor.setThreadNamePrefix("email-");
        executor.initialize();
        return executor;
    }
}
