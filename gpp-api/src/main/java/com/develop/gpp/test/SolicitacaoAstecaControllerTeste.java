// package com.develop.gpp.test;

// import com.develop.gpp.domain.entity.SolicitacaoAstecaModel;
// import com.develop.gpp.domain.entity.ItemSolicitacaoAstecaModel;
// import com.develop.gpp.domain.entity.AstecaMotivoModel;
// import com.develop.gpp.domain.entity.DocumentoFiscalModel;
// import com.develop.gpp.domain.enumeradores.SituacaoAstecaEnum;
// import com.develop.gpp.domain.enumeradores.TipoAstecaEnum;
// import com.develop.gpp.domain.entity.PecasEstoqueModel;
// import com.develop.gpp.domain.repository.AstecaMotivoRepository;
// import com.develop.gpp.domain.repository.DocumentoFiscalRepository;
// import com.develop.gpp.domain.repository.ItemAstecaRepository;
// import com.develop.gpp.domain.repository.PecasEstoqueRepository;
// import com.develop.gpp.domain.service.SolicitacaoAstecaService;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.http.ResponseEntity;
// import org.springframework.web.bind.annotation.*;

// import java.time.LocalDateTime;
// import java.util.ArrayList;
// import java.util.List;
// import java.util.Random;

// @RestController
// @RequestMapping("/astecateste")
// public class SolicitacaoAstecaControllerTeste {

//     @Autowired
//     private SolicitacaoAstecaService solicitacaoAstecaService;

//     @Autowired
//     private ItemAstecaRepository itemAstecaRepository;

//     @Autowired
//     private PecasEstoqueRepository pecasEstoqueRepository;

//     @Autowired
//     private DocumentoFiscalRepository documentoFiscalRepository;

//     @Autowired
//     private AstecaMotivoRepository astecaMotivoRepository;

//     @GetMapping("/")
//     public ResponseEntity<SolicitacaoAstecaModel> teste() {
//         Random random = new Random();
//         Double valor1 = 100.0 + (400.0 - 100.0) * random.nextDouble();
//         Integer qtd1 = random.nextInt(8) + 1; // random number between 1 and 10

//         Double valor2 = 10.0 + (50.0 - 10.0) * random.nextDouble();
//         Integer qtd2 = random.nextInt(8) + 1; // random number between 1 and 10

//         Integer id1a10Aleatorio = (random.nextInt(8 + 1)); // random number between 1 and 10


//         ItemSolicitacaoAstecaModel item = new ItemSolicitacaoAstecaModel();
//         ItemSolicitacaoAstecaModel item2 = new ItemSolicitacaoAstecaModel();
//         SolicitacaoAstecaModel asteca = new SolicitacaoAstecaModel();
//         List<DocumentoFiscalModel> documento = documentoFiscalRepository.findAll();
//         List<PecasEstoqueModel> pecasEstoque = pecasEstoqueRepository.findAll();
//         List<AstecaMotivoModel> motivo = astecaMotivoRepository.findAll();
//         SituacaoAstecaEnum situacao = null;
//         TipoAstecaEnum tipo = null;

//         item2.setPecaEstoque(pecasEstoque.get((random.nextInt(8 + 1))));
//         item2.setQuantidade((random.nextInt(8 + 1)));

//         List<ItemSolicitacaoAstecaModel> listaItens = new ArrayList<>();

//         listaItens.add(item2);

//         itemAstecaRepository.saveAll(listaItens);

//         Integer indiceDocumento = random.nextInt(2 + 1);
//         Integer indiceProduto = random.nextInt(8 + 1);
//         Integer indiceMotivo = random.nextInt(8 + 1);

//         asteca.setDataCriacao(LocalDateTime.now());
//         asteca.setDocumentoFiscal(documento.get(indiceDocumento));
//         asteca.setDescricaoProduto(documento.get(indiceDocumento).getDescricao());
//         asteca.setIdProduto(indiceProduto);
//         asteca.setItensAsteca(listaItens);
//         asteca.setMotivoCriacaoAsteca(motivo.get(indiceMotivo));
//         asteca.setObservacao("Asteca " + random.nextInt(2 + 1) + " " + asteca.getDescricaoProduto());
//         asteca.setSituacaoAsteca(situacao.EMABERTO);
//         asteca.setTipoAsteca(tipo.VISTORIA);

//         solicitacaoAstecaService.salvarAsteca(asteca);

//         String message = "Asteca foi criada.";
//         return ResponseEntity.ok(asteca);
//     }

// }
