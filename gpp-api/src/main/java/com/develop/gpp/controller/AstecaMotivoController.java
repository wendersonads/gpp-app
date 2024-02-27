package com.develop.gpp.controller;

import com.develop.gpp.domain.entity.AstecaMotivoModel;
import com.develop.gpp.domain.service.AstecaMotivoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/astecamotivo")
public class AstecaMotivoController {

    @Autowired
    private AstecaMotivoService astecaMotivoService;

    @GetMapping("/")
    public List<AstecaMotivoModel> astecaMotivoList(){

        List<AstecaMotivoModel> motivos = astecaMotivoService.listaAstecaMotivo();

        List<AstecaMotivoModel> sortedMotivos = motivos.stream()
                .sorted(Comparator.comparing(AstecaMotivoModel::getDenominacao))
                .collect(Collectors.toList());

        return sortedMotivos;

    }

    public ResponseEntity<AstecaMotivoModel> atescaMotivoBuscarPorId(@PathVariable Integer id ) {

        ResponseEntity<AstecaMotivoModel> motivo = astecaMotivoService.atescaMotivoBuscarPorId(id);

        return motivo;

    }

}
