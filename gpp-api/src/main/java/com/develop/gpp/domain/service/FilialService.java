package com.develop.gpp.domain.service;

import java.lang.StackWalker.Option;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.develop.gpp.domain.entity.FilialModel;
import com.develop.gpp.domain.repository.FilialRepository;

import lombok.RequiredArgsConstructor;

@Service
public class FilialService {

    @Autowired
    private FilialRepository filialRepository;

    public List<FilialModel> todasFiliais() {

        return filialRepository.findAll();

    }

    public FilialModel salvarFilial(@RequestBody FilialModel filial) {

        Optional<FilialModel> validacao = filialRepository.findByNumeroFilial(filial.getNumeroFilial());

        if (validacao.isPresent()) {

            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Número de Filial Ja existe!");

        } else {

            return filialRepository.save(filial);

        }

    }

}
