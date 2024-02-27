package com.develop.gpp.controller;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.develop.gpp.domain.entity.ClienteModel;
import com.develop.gpp.domain.entity.DocumentoFiscalModel;
import com.develop.gpp.domain.entity.FilialModel;
import com.develop.gpp.domain.entity.FornecedorModel;
import com.develop.gpp.domain.entity.ItemDocumentoFiscalModel;
import com.develop.gpp.domain.entity.ProdutoModel;
import com.develop.gpp.domain.repository.ClienteRepository;
import com.develop.gpp.domain.repository.DocumentoFiscalRepository;
import com.develop.gpp.domain.repository.FilialRepository;
import com.develop.gpp.domain.repository.FornecedorRepository;
import com.develop.gpp.domain.repository.ItemDocFiscalRepository;
import com.develop.gpp.domain.repository.ProdutoRepository;
import com.develop.gpp.domain.service.DocumentoFiscalService;

@RestController
@RequestMapping("/doc")
public class DocumentoFiscalController {

    @Autowired
    public DocumentoFiscalRepository documentoFiscalRepository;

    @Autowired
    public ProdutoRepository produtoRepository;

    @Autowired
    public FornecedorRepository fornecedorRepository;

    @Autowired
    public ClienteRepository clienteRepository;

    @Autowired
    public FilialRepository filialRepository;

    @Autowired
    public ItemDocFiscalRepository docFiscalRepository;

    @Autowired
    private DocumentoFiscalService documentoFiscalService;

    @PostMapping("/")
    public DocumentoFiscalModel salvarDoc(@RequestBody DocumentoFiscalModel doc) {

        return documentoFiscalService.salvarDoc(doc);
    }

    @GetMapping("/{prod}")
    public List<DocumentoFiscalModel> listaPorProduto(@PathVariable Integer prod) {

        List<DocumentoFiscalModel> doc = documentoFiscalService.listaPorProduto(prod);

        return doc;

    }

    @GetMapping("/")
    public List<DocumentoFiscalModel> todas() {

        return documentoFiscalService.todas();

    }

}
