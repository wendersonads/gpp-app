package dev.auth.auth_api;

import dev.auth.auth_api.base.repository.impl.AbstractRepositoryImpl;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.client.RestTemplate;

@EnableScheduling
@SpringBootApplication
@EnableJpaRepositories(repositoryBaseClass = AbstractRepositoryImpl.class)
public class AuthApiApplication {

    public static void main(String[] args) {
        SpringApplication.run(AuthApiApplication.class, args);
    }

    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Scheduled(cron = "0 0/5 * * * *")
    public void preventIdle() {
        RestTemplate restTemplate = new RestTemplate();
        String response = restTemplate.getForObject("https://flutter-springboot-auth.herokuapp.com/api/name", String.class);
        System.out.println(response);
    }
}
