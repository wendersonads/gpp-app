package dev.auth.auth_api.controller;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(ApiController.PATH)
public class ApiController {

    public static final String PATH = "/api";

    @Value("${spring.application.name}")
    private String applicationName;


    @GetMapping("/name")
    public String getApplicationName() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication.getName() + " " + LocalDateTime.now();
    }
}
