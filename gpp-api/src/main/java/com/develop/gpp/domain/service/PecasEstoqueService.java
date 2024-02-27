package com.develop.gpp.domain.service;

import com.develop.gpp.domain.entity.PecasEstoqueModel;
import com.develop.gpp.domain.repository.PecasEstoqueRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Optional;

@Service
public class PecasEstoqueService {

    @Autowired
    private PecasEstoqueRepository pecasEstoqueRepository;

    public List<PecasEstoqueModel> listarTodos() {
        return pecasEstoqueRepository.findAll();
    }

    public PecasEstoqueModel getPecasEstoqueByIdPeca(Integer idPeca) {
        List<PecasEstoqueModel> pecasEstoqueList = pecasEstoqueRepository.findByPeca_IdPeca(idPeca);
        if (!pecasEstoqueList.isEmpty()) {
            return pecasEstoqueList.get(0);
        }
        return null;
    }

    public PecasEstoqueModel editarPeca(PecasEstoqueModel peca, Integer qtd) {

        PecasEstoqueModel saldoBanco = pecasEstoqueRepository.findById(peca.getIdPecaEstoque().intValue()).get();

        Optional<PecasEstoqueModel> validacao = pecasEstoqueRepository.findById(peca.getIdPecaEstoque().intValue());

        if (validacao.isPresent()) {

            if (qtd > saldoBanco.getSaldoDisponivel().intValue()) {

                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Quantidade Requerida " + qtd
                        + " quantidade Disponível " + saldoBanco.getSaldoDisponivel().intValue() + "!");
            } else {

                Integer valorSubtracao;

                valorSubtracao = saldoBanco.getSaldoDisponivel().intValue() - qtd;

                peca.setSaldoDisponivel(valorSubtracao);

            }

        } else {

            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Não existe Estoque pra essa Peça!");

        }

        return pecasEstoqueRepository.save(peca);

    }

    public List<PecasEstoqueModel> listarPorProduto(Integer prod) {
        List<PecasEstoqueModel> pecas = pecasEstoqueRepository.listarPorProduto(prod);
            return pecas;
    }

    public PecasEstoqueModel salvarPecaEstoque(PecasEstoqueModel pecaEstoque) {

        return pecasEstoqueRepository.save(pecaEstoque);
    }

}
