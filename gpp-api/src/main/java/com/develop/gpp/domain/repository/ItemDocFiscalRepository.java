package com.develop.gpp.domain.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.develop.gpp.domain.entity.ItemDocumentoFiscalModel;

@Repository
public interface ItemDocFiscalRepository extends JpaRepository<ItemDocumentoFiscalModel,Integer>{

    @Query(nativeQuery = true, value = "SELECT * FROM item_documento_fiscal idf INNER JOIN documento_fiscal df ON idf.item_doc_id = df.id_documento_fiscal  WHERE df.id_documento_fiscal = :doc")
    List<ItemDocumentoFiscalModel> listarPorDocumento(@Param("doc")Integer doc); 

    //SELECT * FROM item_documento_fiscal idf INNER JOIN documento_fiscal df ON idf.item_doc_id = df.id_documento_fiscal  WHERE df.id_documento_fiscal = :doc
    
}
