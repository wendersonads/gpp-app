package com.develop.gpp.domain.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.develop.gpp.domain.entity.Account;
import com.develop.gpp.domain.entity.PerfilUsuarioFuncionalidades;
import com.develop.gpp.domain.entity.PerfilUsuarioModel;
import com.develop.gpp.domain.entity.dto.LoginDTO;
import com.develop.gpp.domain.repository.AccountRepository;
import com.develop.gpp.domain.repository.PerfilRepository;

@Service
public class PerfilUsuarioService {

    @Autowired
    private AccountRepository repository;

    @Autowired
    private PerfilRepository perfilRepository;

    public Account getUser(String username) {
        Optional<Account> user = repository.findByUsername(username);
       System.out.println(username);
        if (user.isEmpty()) {

            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Usuário não encontrado!");

        }
        return user.get();
    }

    public Account vincularPerfil(Long idconta , Long id) {
        Optional<Account> user = repository.findById(idconta);
        Optional<PerfilUsuarioModel> perfil = perfilRepository.findById(id);
        try {

            if (user.isEmpty()) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Usuário não encontrado!");
            }
            if (perfil.isEmpty()) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Perfil inváliido!");
            }

             user.get().setPerfilUsuario(perfil.get());

            return repository.save(user.get());
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Erro ao vincular Perfil! " + e.getMessage());
        }

    }
    public List<PerfilUsuarioModel> listarTodos(){
        return perfilRepository.findAll();
    }

}
