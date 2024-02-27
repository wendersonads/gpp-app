package com.develop.gpp.controller;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.develop.gpp.domain.entity.AstecaMotivoModel;
import com.develop.gpp.domain.entity.DocumentoFiscalModel;
import com.develop.gpp.domain.entity.ItemSolicitacaoAstecaModel;
import com.develop.gpp.domain.entity.PecasEstoqueModel;
import com.develop.gpp.domain.entity.SolicitacaoAstecaModel;
import com.develop.gpp.domain.enumeradores.SituacaoAstecaEnum;
import com.develop.gpp.domain.enumeradores.TipoAstecaEnum;
import com.develop.gpp.domain.repository.AstecaMotivoRepository;
import com.develop.gpp.domain.repository.DocumentoFiscalRepository;
import com.develop.gpp.domain.repository.ItemAstecaRepository;
import com.develop.gpp.domain.repository.PecasEstoqueRepository;
import com.develop.gpp.domain.repository.ProdutoRepository;
import com.develop.gpp.domain.repository.SolicitacaoAstecaRepository;
import com.develop.gpp.domain.service.AstecaMotivoService;
import com.develop.gpp.domain.service.PecasEstoqueService;
import com.develop.gpp.domain.service.SolicitacaoAstecaService;

@RestController
@RequestMapping("/asteca")
public class SolicitacaoAstecaController {

    @Autowired
    private SolicitacaoAstecaService solicitacaoAstecaService;

    @Autowired
    private ItemAstecaRepository itemAstecaRepository;

    @Autowired
    private PecasEstoqueRepository pecasEstoqueRepository;

    @Autowired
    private DocumentoFiscalRepository documentoFiscalRepository;

    @Autowired
    private AstecaMotivoRepository astecaMotivoRepository;
    
    @GetMapping("/")
    public List<SolicitacaoAstecaModel> listarTodas(){

        return solicitacaoAstecaService.listarTodas();
    }


    @PostMapping("/")
    public ResponseEntity<SolicitacaoAstecaModel> salvarAsteca(@RequestBody SolicitacaoAstecaModel asteca){

        return solicitacaoAstecaService.salvarAsteca(asteca);
    }

    @GetMapping("/{id}")
    public SolicitacaoAstecaModel solicitacaoId(@PathVariable Integer id){
        return solicitacaoAstecaService.solicitacaoId(id);
    }

    @PutMapping("/{situacao}")
    public ResponseEntity<SolicitacaoAstecaModel> executarSolicitacao(@RequestBody SolicitacaoAstecaModel asteca, @PathVariable Integer situacao){

        return solicitacaoAstecaService.atualizarSolicitacao(asteca, situacao);
    }
}
