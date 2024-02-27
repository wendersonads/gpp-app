package com.develop.gpp.controller;

import com.develop.gpp.domain.entity.PecaModel;
import com.develop.gpp.domain.entity.PecasEstoqueModel;
import com.develop.gpp.domain.entity.dto.PecaDTO;
import com.develop.gpp.domain.service.PecaService;
import com.develop.gpp.domain.service.PecasEstoqueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/pecasestoque")
public class PecasEstoqueController {

    @Autowired
    private PecasEstoqueService pecasEstoqueService;

    @GetMapping("/")
    public List<PecasEstoqueModel> listaPecasEstoque() {
        return pecasEstoqueService.listarTodos();
    }

    @GetMapping("/prod/{prod}")
    public List<PecasEstoqueModel> listarPorProduto(@PathVariable Integer prod){
        return pecasEstoqueService.listarPorProduto(prod);
    }

    @GetMapping("/{idPeca}")
    public ResponseEntity<PecasEstoqueModel> getPecasEstoqueByIdPeca(@PathVariable Integer idPeca) {
        PecasEstoqueModel pecasEstoque = pecasEstoqueService.getPecasEstoqueByIdPeca(idPeca);
        if (pecasEstoque != null) {
            return new ResponseEntity<>(pecasEstoque, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @PostMapping("/")
    public PecasEstoqueModel salvarPeca(@RequestBody PecasEstoqueModel pecasEstoque) {

        return pecasEstoqueService.salvarPecaEstoque(pecasEstoque);
    }

}
