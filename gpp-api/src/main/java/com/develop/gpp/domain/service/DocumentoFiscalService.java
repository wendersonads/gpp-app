package com.develop.gpp.domain.service;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.server.ResponseStatusException;

import com.develop.gpp.domain.entity.DocumentoFiscalModel;
import com.develop.gpp.domain.entity.ItemDocumentoFiscalModel;
import com.develop.gpp.domain.repository.DocumentoFiscalRepository;

@Service
public class DocumentoFiscalService {

    @Autowired
    private DocumentoFiscalRepository documentoFiscalRepository;

    public DocumentoFiscalModel salvarDoc(@RequestBody DocumentoFiscalModel doc) {

        return documentoFiscalRepository.save(doc);
    }

    public List<DocumentoFiscalModel> listaPorProduto(Integer prod) {

        List<DocumentoFiscalModel> listaDoc = documentoFiscalRepository.listarPorProduto(prod);

        if(listaDoc.isEmpty()){
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Sem notas para esse produto!"); 
        }else{
            return listaDoc;
        }

       

    }

    public List<DocumentoFiscalModel> todas() {

        List<DocumentoFiscalModel> listaDoc = documentoFiscalRepository.findAll();

       

        return listaDoc;

    }

}
