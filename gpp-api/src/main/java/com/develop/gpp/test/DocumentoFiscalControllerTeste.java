package com.develop.gpp.test;

import com.develop.gpp.domain.entity.*;
import com.develop.gpp.domain.repository.*;
import com.develop.gpp.domain.service.DocumentoFiscalService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.annotation.PostConstruct;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

@RestController
@RequestMapping("/docteste")
public class DocumentoFiscalControllerTeste {

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

//   @PostConstruct
//    public void init() {

//     for (int i = 0; i < 3; i++) {

//         // populando valores nos itens
//         Random random = new Random();
//         Double valor1 = 100.0 + (400.0 - 100.0) * random.nextDouble();
//         Integer qtd1 = random.nextInt(8) + 1; // random number between 1 and 10

//         Double valor2 = 10.0 + (50.0 - 10.0) * random.nextDouble();
//         Integer qtd2 = random.nextInt(8) + 1; // random number between 1 and 10

//         ItemDocumentoFiscalModel item = new ItemDocumentoFiscalModel();
//         ItemDocumentoFiscalModel item2 = new ItemDocumentoFiscalModel();
//         DocumentoFiscalModel doc = new DocumentoFiscalModel();
//         List<ProdutoModel> prod = produtoRepository.findAll();
//         List<ClienteModel> cli = clienteRepository.findAll();
//         List<FilialModel> fi = filialRepository.findAll();


//         Integer id1a10Aleatorio = (random.nextInt(8 + 1)); // random number between 1 and 10

//         // item 1
//         //item.setDocumentoFiscal(doc);
//         item.setProduto(prod.get((random.nextInt(8) + 1)));
//         item.setQtde(qtd1);
//         item.setValorVenda(valor1);
//         item.valorTotal(qtd1, valor1);
//         // item.setDocumentoFiscal(doc);
//         item.setIdItemDocFiscal(doc.getIdDocumentoFiscal());

//         // item2
//         item2.setProduto(prod.get((random.nextInt(8) + 1)));
//         item2.setQtde(qtd2);
//         item2.setValorVenda(valor2);
//         item2.valorTotal(qtd2, valor2);
//         // item.setDocumentoFiscal(doc);
//         item2.setIdItemDocFiscal(doc.getIdDocumentoFiscal());

//         // lista de itens
//         List<ItemDocumentoFiscalModel> listaItens = new ArrayList<>();
//         listaItens.add(item);
//         listaItens.add(item2);

//         // documento
//         doc.setCliente(cli.get((random.nextInt(8) + 1)));
//         doc.setCpfCnpj(cli.get((random.nextInt(8) + 1)).getCpfCnpj());
//         doc.setDataEmissao(LocalDateTime.now());
//         doc.setFornecedor(prod.get((random.nextInt(8) + 1)).getFornecedor().getNomeFornecedor());
//         doc.setItens(listaItens);
//         doc.setSerieDocFiscal(Integer.toString(random.nextInt(8) + 1));
//         doc.setNumDocFiscal((random.nextInt(8) + 1));
//         doc.setIdFilialSaida(fi.get((random.nextInt(8) + 1)).getIdFilial());
//         doc.setDescricao(prod.get((random.nextInt(8) + 1)).getDescricao());

//         documentoFiscalRepository.save(doc);
//         docFiscalRepository.saveAll(listaItens);
//     }
//    }

}
