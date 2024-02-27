package com.develop.gpp.domain.service;

import com.develop.gpp.domain.entity.AstecaMotivoModel;
import com.develop.gpp.domain.repository.AstecaMotivoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;
import java.util.Optional;

@Service
public class AstecaMotivoService {

    @Autowired
    private AstecaMotivoRepository astecaMotivoRepository;

    public List<AstecaMotivoModel> listaAstecaMotivo(){
        List<AstecaMotivoModel> motivos = astecaMotivoRepository.findAll();

        return motivos;
    }

    public ResponseEntity<AstecaMotivoModel> atescaMotivoBuscarPorId(@PathVariable Integer id){
        Optional<AstecaMotivoModel> optionalAstecaMotivoModel = astecaMotivoRepository.findById(id);

        if (optionalAstecaMotivoModel.isPresent()){
            return ResponseEntity.ok(optionalAstecaMotivoModel.get());
        } else {
            return ResponseEntity.notFound().build();
        }

    }

}
