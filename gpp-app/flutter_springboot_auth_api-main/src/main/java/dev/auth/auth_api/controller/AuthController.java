package dev.auth.auth_api.controller;


import dev.auth.auth_api.domain.dto.RegisterDTO;
import dev.auth.auth_api.domain.service.UserService;
import dev.auth.auth_api.domain.service.TokenStore;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@RestController
@RequestMapping(AuthController.PATH)
public class AuthController {

    public static final String PATH = "/auth";

    @Autowired
    private UserService service;

    @Autowired
    private TokenStore tokenStore;
    
    @PostMapping("/register")
    public void register(@RequestBody RegisterDTO register) {
        service.register(register);
    }

    @GetMapping("/check")
    public void check() {};

    @GetMapping("/revoke")
    public void revoke(HttpServletRequest request) {
        tokenStore.revoke(request);
    }

    @GetMapping("/refresh")
    public void refresh(HttpServletRequest request, HttpServletResponse response) throws IOException {
        tokenStore.refresh(request, response);
    }
    
}
