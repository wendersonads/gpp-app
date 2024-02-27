package com.develop.gpp.domain.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.develop.gpp.domain.entity.DocumentoFiscalModel;

@Repository
public interface DocumentoFiscalRepository extends JpaRepository<DocumentoFiscalModel, Integer> {

    @Query(nativeQuery = true, value = "SELECT DISTINCT df.* FROM documento_fiscal df INNER JOIN item_documento_fiscal idf ON idf.item_doc_id = df.id_documento_fiscal INNER JOIN produto p ON idf.id_produto = p.id_produto WHERE p.id_produto = :prod")
    List<DocumentoFiscalModel> listarPorProduto(@Param("prod") Integer prod);

//    @Query(nativeQuery = true, value = "SELECT * FROM documento_fiscal df INNER JOIN item_documento_fiscal idf ON idf.id_item_doc_fiscal = df.id_documento_fiscal INNER JOIN produto p ON idf.id_produto = p.id_produto WHERE p.id_produto = :prod")
//    List<DocumentoFiscalModel> listarPorProduto(@Param("prod") Integer prod);

    //List<DocumentoFiscalModel> listarPor

}
