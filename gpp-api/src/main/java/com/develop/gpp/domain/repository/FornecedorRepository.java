package com.develop.gpp.domain.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.develop.gpp.domain.entity.FornecedorModel;
import org.springframework.web.bind.annotation.PathVariable;

@Repository
public interface FornecedorRepository extends JpaRepository<FornecedorModel, Integer> {

    Optional<FornecedorModel> findByNomeFornecedor(String nome);

    Optional<FornecedorModel> findByCnpj(String cnpj);

    Optional<FornecedorModel> findByEmail(String email);

    Optional<FornecedorModel> findById(@PathVariable Integer id);

    @Query(nativeQuery = true, value = "select * from fornecedor f where f.cnpj is not null and f.email is not null;")
    List<FornecedorModel> validacaoEmailCnpj();

    @Query(nativeQuery = true, value = "select * from fornecedor f where lower(f.nome_fornecedor) like lower(:nome)")
    List<FornecedorModel> listarPorNome(@Param("nome") String nome);

}
