package com.develop.gpp.domain.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.jpa.domain.JpaSort;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;

import com.develop.gpp.domain.entity.PecaModel;
import com.develop.gpp.domain.entity.dto.PecaDTO;
import com.develop.gpp.domain.repository.PecaRepository;

import net.bytebuddy.asm.Advice.OffsetMapping.Sort;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class PecaService {

    private final PecaRepository pecaRepository;

    @Autowired
    public PecaService(PecaRepository pecaRepository) {
        this.pecaRepository = pecaRepository;
    }

    public List<PecaDTO> listaPecas() {

          
        //PageRequest.of(0, 0, JpaSort.by(Direction.DESC, "peca.id_peca"));

        
        List<PecaModel> lista = pecaRepository.findAll();
        return lista.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public List<PecaDTO> buscarPorProduto(Integer prod) {
        List<PecaModel> lista = pecaRepository.buscarPorProduto(prod);
        return lista.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public PecaModel salvarPeca(PecaModel peca) {
        return pecaRepository.save(peca);
    }

    public ResponseEntity<PecaModel> buscarPorId(Integer id) {
        Optional<PecaModel> optionalPeca = pecaRepository.findById(id);

        return optionalPeca.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    public ResponseEntity<PecaModel> deletePeca(Integer id) {
        Optional<PecaModel> optionalPeca = pecaRepository.findById(id);

        if (optionalPeca.isPresent()) {
            pecaRepository.delete(optionalPeca.get());
            return ResponseEntity.ok().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    private PecaDTO convertToDTO(PecaModel pecaModel) {
        PecaDTO pecaDTO = new PecaDTO();
        pecaDTO.setIdPeca(pecaModel.getIdPeca());
        pecaDTO.setCor(pecaModel.getCor());
        pecaDTO.setDescricao(pecaModel.getDescricao());
        pecaDTO.setMaterial(pecaModel.getMaterial());
        pecaDTO.setProduto(pecaModel.getProduto());
        return pecaDTO;
    }
}