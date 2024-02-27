package com.develop.gpp.domain.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.apache.catalina.connector.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.server.ResponseStatusException;

import com.develop.gpp.domain.entity.ItemSolicitacaoAstecaModel;
import com.develop.gpp.domain.entity.PecasEstoqueModel;
import com.develop.gpp.domain.entity.SolicitacaoAstecaModel;
import com.develop.gpp.domain.enumeradores.SituacaoAstecaEnum;
import com.develop.gpp.domain.enumeradores.TipoAstecaEnum;
import com.develop.gpp.domain.repository.PecasEstoqueRepository;
import com.develop.gpp.domain.repository.SolicitacaoAstecaRepository;

@Service
public class SolicitacaoAstecaService {

    @Autowired
    private SolicitacaoAstecaRepository solicitacaoAstecaRepository;

    @Autowired
    private PecasEstoqueRepository pecasEstoqueRepository;

    @Autowired
    private PecasEstoqueService pecasEstoqueService;

    // public SolicitacaoAstecaService(SolicitacaoAstecaRepository
    // solicitacaoAstecaRepository) {
    // this.solicitacaoAstecaRepository = solicitacaoAstecaRepository;
    // }

    public ResponseEntity<SolicitacaoAstecaModel> salvarAsteca(@RequestBody SolicitacaoAstecaModel asteca) {
        // "1- Em aberto, 2- Em Execução, 3- Cancelada, 4- Finalizada")
        asteca.setSituacaoAsteca(1);
        asteca.setDataCriacao(LocalDateTime.now());

        for (ItemSolicitacaoAstecaModel item : asteca.getItensAsteca()) {
            PecasEstoqueModel estoque = item.getPecaEstoque();
            pecasEstoqueService.editarPeca(estoque, item.getQuantidade());
        }

        SolicitacaoAstecaModel solicitacaoSalva = solicitacaoAstecaRepository.save(asteca);

        return new ResponseEntity<>(solicitacaoSalva, HttpStatus.CREATED);
    }

    public ResponseEntity<SolicitacaoAstecaModel> atualizarSolicitacao(@RequestBody SolicitacaoAstecaModel asteca,
            Integer situacao) {

        SolicitacaoAstecaModel valida = solicitacaoAstecaRepository.findById(asteca.getIdAsteca()).get();

        if (valida == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Solicitação não encontrada!");
        } else {
            if (situacao == 2) {
                valida.setDataInicioAsteca(LocalDateTime.now());
            } else if (situacao == 3) {
                valida.setDataCancela(LocalDateTime.now());
            } else {
                valida.setDataFinaliza(LocalDateTime.now());
            }
            // "1- Em aberto, 2- Em Execução, 3- Cancelada, 4- Finalizada")
            valida.setSituacaoAsteca(situacao);
        }

        SolicitacaoAstecaModel solicitacaoSalva = solicitacaoAstecaRepository.save(valida);
        return new ResponseEntity<>(solicitacaoSalva, HttpStatus.OK);

    }

    public SolicitacaoAstecaModel solicitacaoId(Integer id) {

        Optional<SolicitacaoAstecaModel> solicitacao = solicitacaoAstecaRepository.findById(id);

        if (solicitacao.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Solicitação não econtrada!");
        }
        return solicitacao.get();
    }

    public List<SolicitacaoAstecaModel> listarTodas() {
        return solicitacaoAstecaRepository.findAll();
    }

}
