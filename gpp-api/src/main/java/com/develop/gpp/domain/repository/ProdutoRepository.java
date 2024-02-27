package com.develop.gpp.domain.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.develop.gpp.domain.entity.FornecedorModel;
import com.develop.gpp.domain.entity.ProdutoModel;

@Repository
public interface ProdutoRepository extends JpaRepository<ProdutoModel, Integer> {

    Optional<ProdutoModel> findByDescricao(String descricao);

    Optional<ProdutoModel> findByFornecedor(Integer fornec);
}
