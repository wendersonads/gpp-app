package com.develop.gpp.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.develop.gpp.domain.service.itemDocService;
import com.develop.gpp.domain.entity.ItemDocumentoFiscalModel;
import com.develop.gpp.domain.entity.ProdutoModel;

@RestController
@RequestMapping("/itens")
public class itemDocController {

    @Autowired
    private itemDocService itemDocService;

    @GetMapping("/{doc}")
    public List<ItemDocumentoFiscalModel> listarPorDoc(@PathVariable Integer doc) {

        List<ItemDocumentoFiscalModel> listaItens = itemDocService.listarPorDoc(doc);

        return listaItens;

    }

}
