package com.develop.gpp.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.develop.gpp.domain.entity.Account;
import com.develop.gpp.domain.entity.PerfilUsuarioModel;
import com.develop.gpp.domain.entity.dto.LoginDTO;
import com.develop.gpp.domain.entity.dto.RegisterDTO;
import com.develop.gpp.domain.service.AccountService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
public class AccountController {
    
    @Autowired
	private final AccountService service = new AccountService();

    @PostMapping("register")
    public Account register(@RequestBody RegisterDTO dto) {
        return service.register(dto);
    }

    @GetMapping("account/")
    public List<Account> todosUsuarios(){
        return service.todosUsuarios();
    }

    @GetMapping("account/{id}")
    public Account buscarPorId(@PathVariable Long id){

        return service.buscarPorId(id);
    }
}
