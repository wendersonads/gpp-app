package com.develop.gpp.domain.entity;

import javax.persistence.*;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "pecas_estoque")
public class PecasEstoqueModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idPecaEstoque;

    @ManyToOne
    @JoinColumn(name = "idPeca")
    private PecaModel peca;

    private Integer saldoDisponivel;

    private Integer saldoReservado;

    private Integer quantidadeMinima;

    private Integer quantidadeMaxima;

    private Integer quantidadeIdeal;

}
