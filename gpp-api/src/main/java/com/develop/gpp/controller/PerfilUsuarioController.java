package com.develop.gpp.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.develop.gpp.domain.entity.Account;
import com.develop.gpp.domain.entity.PerfilUsuarioFuncionalidades;
import com.develop.gpp.domain.entity.PerfilUsuarioModel;
import com.develop.gpp.domain.entity.dto.LoginDTO;
import com.develop.gpp.domain.service.PerfilUsuarioService;

@RestController
@RequestMapping("/perfil")
public class PerfilUsuarioController {

    @Autowired
    private  PerfilUsuarioService service;
    
    
    public PerfilUsuarioController(PerfilUsuarioService service) {
        this.service = service;
    }

    @GetMapping("/user")
    public Account getUser(@RequestParam String username) {
        return service.getUser(username);
    }

    @PostMapping("/vincular")
    public Account vincularPerfil(@RequestParam Long idconta, @RequestParam Long id) {

        return service.vincularPerfil(idconta, id);
    }

    @GetMapping("/")
    public List<PerfilUsuarioModel> listaTodos(){
        return service.listarTodos();
    }

}
