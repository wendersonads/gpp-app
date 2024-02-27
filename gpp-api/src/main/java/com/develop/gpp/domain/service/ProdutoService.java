package com.develop.gpp.domain.service;

import java.util.Optional;

import java.util.List;

import com.develop.gpp.domain.entity.FornecedorModel;
import com.develop.gpp.domain.entity.ProdutoModel;
import com.develop.gpp.domain.repository.FornecedorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.annotation.ReadOnlyProperty;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.server.ResponseStatusException;

import com.develop.gpp.domain.entity.ProdutoModel;
import com.develop.gpp.domain.entity.ProdutoModel;
import com.develop.gpp.domain.repository.ProdutoRepository;
import com.develop.gpp.domain.repository.ProdutoRepository;

@Service
public class ProdutoService {

    @Autowired
    public ProdutoRepository produtoRepository;

    @Autowired
    public FornecedorRepository fornecedorRepository;

    public ProdutoModel salvarProduto(@RequestBody ProdutoModel prod) {

        Optional<FornecedorModel> validacao = fornecedorRepository.findById(prod.getFornecedor().getIdFornecedor());

        Optional<ProdutoModel> validacaoProduto = produtoRepository.findByDescricao(prod.getDescricao());

        if (validacao.isPresent()) {

            if (validacaoProduto.isPresent()) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Nome de Produto já cadastrado!!");

            } else {
                return produtoRepository.save(prod);

            }

        } else {

            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Fornecedor não encontrado");
        }

    }


    public List<ProdutoModel> listaProduto() {
        Sort sortByDescricao = Sort.by(Sort.Direction.ASC, "descricao");
        return produtoRepository.findAll(sortByDescricao);
    }

    public ResponseEntity<Integer> deleteProduto(Integer id) {
        Optional<ProdutoModel> optionalProduto = produtoRepository.findById(id);
        if (optionalProduto.isPresent()) {
            produtoRepository.delete(optionalProduto.get());
            return ResponseEntity.ok(id); // Return the ID of the deleted product
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    public ResponseEntity<ProdutoModel> BuscarPorId(@PathVariable Integer id) {

        Optional<ProdutoModel> optionalProduto = produtoRepository.findById(id);

        if (optionalProduto.isPresent()) {
            return ResponseEntity.ok(optionalProduto.get());
        } else {
            return ResponseEntity.notFound().build();
        }

    }
}
