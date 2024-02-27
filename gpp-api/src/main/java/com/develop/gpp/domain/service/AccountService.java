package com.develop.gpp.domain.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.develop.gpp.domain.entity.Account;
import com.develop.gpp.domain.entity.PerfilUsuarioModel;
import com.develop.gpp.domain.entity.dto.LoginDTO;
import com.develop.gpp.domain.entity.dto.RegisterDTO;
import com.develop.gpp.domain.repository.AccountRepository;
import com.develop.gpp.domain.repository.PerfilRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AccountService {

    @Autowired
    private AccountRepository repository;

    public Account register(RegisterDTO dto) {
        existsByUsername(dto.getUsername());
        Account novoUser = new Account();
        novoUser.setName(dto.getName());
        novoUser.setAtivo(1);// - 1 Sim,2-Não;
        novoUser.setPassword(dto.getPassword());
        novoUser.setUsername(dto.getUsername());
        novoUser.setPerfilUsuario(null);
        return repository.save(novoUser);
    }

    public List<Account> todosUsuarios() {
        return repository.findAll();
    }

    public Account buscarPorId(Long id) {
        Optional<Account> acc = repository.findById(id);
        if (acc.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Usuário não encontrado!");
        }
        return acc.get();
    }

    public Account getByLogin(LoginDTO dto) {
        Optional<Account> acc = repository.findByUsernameAndPassword(dto.getUsername(), dto.getPassword());

        if (acc.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalido Usuário ou Senha");
        } else if (acc.get().getPerfilUsuario() == null) {

            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED,
                    "Usuário sem perfil vinculado! Solicite acesso ao Administrador do sistema!");
        }

        return acc.get();
    }

    private void existsByUsername(String username) {
        if (repository.findByUsername(username).isPresent()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Usuário já registrado!");
        }
    }
}
