package com.develop.gpp.controller;

import com.develop.gpp.domain.entity.*;
import com.develop.gpp.domain.entity.ItemDocumentoFiscalModel;
import com.develop.gpp.domain.entity.dto.PecaDTO;
import com.develop.gpp.domain.service.PecaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.annotation.PostConstruct;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

@RestController
@RequestMapping("/pecas")
public class PecaController {

    private final PecaService pecaService;

    @Autowired
    public PecaController(PecaService pecaService) {
        this.pecaService = pecaService;
    }

    @GetMapping("/")
    public List<PecaDTO> listaPecas() {
        return pecaService.listaPecas();
    }

    @PostMapping("/")
    @ResponseStatus(HttpStatus.CREATED)
    public PecaModel salvarPeca(@RequestBody PecaModel peca) {
        return pecaService.salvarPeca(peca);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<PecaModel> deletePeca(@PathVariable Integer id) {
        return pecaService.deletePeca(id);
    }

    @GetMapping("/{prod}")
    public List<PecaDTO> buscarPorProduto(@PathVariable Integer prod) {
        return pecaService.buscarPorProduto(prod);
    }

    @GetMapping("/id/{id}")
    public ResponseEntity<PecaModel> buscarPorId(@PathVariable Integer id) {
        return pecaService.buscarPorId(id);
    }

//    @PostConstruct
//    public void init() {
//
//        PecaModel peca = new PecaModel();
//        peca.setNumero("12345");
//        peca.setCodigoFabrica("ABC123");
//        peca.setUnidade(1);
//        peca.setDescricao("Sample description");
//        peca.setAltura(10);
//        peca.setLargura(20);
//        peca.setProfundidade(30);
//        peca.setUnidadeMedida(2);
//        peca.setVolumes("5");
//        peca.setActive(true);
//        peca.setCusto(100.0);
//        peca.setCor("Red");
//        peca.setMaterial("Metal");
//        peca.setIdFornecedor(1L);
//        peca.setMaterialFabricacao("Steel");
//
//        PecaModel savedPeca = pecaService.salvarPeca(peca);
//
//
//    }
}