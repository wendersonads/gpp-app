package com.develop.gpp.domain.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.query.Param;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.server.ResponseStatusException;

import com.develop.gpp.domain.entity.ItemDocumentoFiscalModel;
import com.develop.gpp.domain.entity.ProdutoModel;
import com.develop.gpp.domain.repository.ItemDocFiscalRepository;

@Service
public class itemDocService {

    @Autowired
    private ItemDocFiscalRepository itemDocFiscalRepository;

    public List<ItemDocumentoFiscalModel> listarPorDoc(Integer doc) {

        List<ItemDocumentoFiscalModel> listaItens = itemDocFiscalRepository.listarPorDocumento(doc);

       
        if (listaItens.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Sem itens para essa nota!");

        } else {

            return listaItens;
        }
    }

     

}
