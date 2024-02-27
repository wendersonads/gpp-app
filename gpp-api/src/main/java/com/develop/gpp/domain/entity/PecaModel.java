package com.develop.gpp.domain.entity;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import lombok.Getter;
import lombok.Setter;
@Setter
@Getter
@Entity
@Table(name = "peca")
public class PecaModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idPeca;

    @Column(nullable = false)
    private String numero;

    @Column(nullable = false)
    private String codigoFabrica;

    @Column(nullable = false)
    private Integer unidade;

    @Column(nullable = false)
    private String descricao;

    @Column(nullable = false)
    private Integer altura;

    @Column(nullable = false)
    private Integer largura;

    @Column(nullable = false)
    private Integer profundidade;

    @Column(nullable = false)
    private Integer unidadeMedida;

    @Column(nullable = false)
    private String volumes;

    @Column(nullable = false)
    private Boolean active;

    @Column(nullable = false)
    private Double custo;

    @Column(nullable = false)
    private String cor;

    @Column(nullable = false)
    private String material;

    @Column(nullable = false)
    private Long idFornecedor;

    @Column(nullable = false)
    private String materialFabricacao;

    @ManyToOne
    @JoinColumn(name="produto_id")
    private ProdutoModel produto;

}