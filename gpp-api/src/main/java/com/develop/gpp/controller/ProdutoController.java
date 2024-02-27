package com.develop.gpp.controller;
import com.develop.gpp.domain.entity.ProdutoModel;
import com.develop.gpp.domain.entity.ProdutoModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.develop.gpp.domain.entity.ProdutoModel;
import com.develop.gpp.domain.service.ProdutoService;

@RestController
@RequestMapping("/produto")
public class ProdutoController {
    private static final Logger logger = LoggerFactory.getLogger(ProdutoController.class);

    @Autowired
    public ProdutoService produtoService;

    @PostMapping("/")
    public ProdutoModel salvarProduto(@RequestBody ProdutoModel prod) {
        logger.info("Received produto: {}", prod);
        return produtoService.salvarProduto(prod);
    }

    @GetMapping("/")
    public List<ProdutoModel> listarTodos() {

        return produtoService.listaProduto();

    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Integer> deleteProduto(@PathVariable Integer id) {
        return produtoService.deleteProduto(id);
    }

    @GetMapping("/{id}")
    @ResponseStatus(code = HttpStatus.OK)
    public ResponseEntity<ProdutoModel> BuscarPorId(@PathVariable Integer id) {

        return produtoService.BuscarPorId(id);

    }


}
