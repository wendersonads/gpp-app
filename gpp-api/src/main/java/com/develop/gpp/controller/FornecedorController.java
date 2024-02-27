package com.develop.gpp.controller;

import java.util.List;

import com.develop.gpp.domain.entity.PecaModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.develop.gpp.domain.entity.FornecedorModel;
import com.develop.gpp.domain.service.FornecedorService;

@RestController
@RequestMapping("/fornecedor")
public class FornecedorController {

    @Autowired
    private FornecedorService fornecedorService;

    @GetMapping("/")
    public List<FornecedorModel> listarTodos() {

        return fornecedorService.listarTodos();
    }

    // @GetMapping("/{nome}")
    // public List<FornecedorModel> listarPorNome(@PathVariable String nome) {
    //
    // return fornecedorService.listarPorNome(nome);
    // }

    @GetMapping("/{id}")
    @ResponseStatus(code = HttpStatus.OK)
    public ResponseEntity<FornecedorModel> BuscarPorId(@PathVariable Integer id) {

        return fornecedorService.BuscarPorId(id);

    }

    @DeleteMapping("/{id}")
    public void deletarFornec(@PathVariable Integer id) {

        fornecedorService.deletarFornec(id);

    }

    @PostMapping("/")
    public FornecedorModel salvarFornec(@RequestBody FornecedorModel fornec) {

        return fornecedorService.salvarFornec(fornec);
    }

    @PutMapping("/")
    public FornecedorModel editarFornec(@RequestBody FornecedorModel fornec) {

        return fornecedorService.editarFornec(fornec);
    }

}
