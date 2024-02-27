package com.develop.gpp.domain.entity;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.CollectionTable;
import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.develop.gpp.domain.enumeradores.SituacaoAstecaEnum;
import com.develop.gpp.domain.enumeradores.TipoAstecaEnum;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "solicitacao_asteca")
public class SolicitacaoAstecaModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_asteca")
    private Integer idAsteca;

    private Integer idProduto;

    private String descricaoProduto;

    private LocalDateTime dataCriacao;

    private LocalDateTime dataInicioAsteca;

    private LocalDateTime dataCancela;
    
    private LocalDateTime dataFinaliza;
    //"1- Em aberto, 2- Em Execução, 3- Cancelada, 4- Finalizada")
    private Integer situacaoAsteca;

    // "1- Vistoria, 2- Reparo")
    private Integer tipoAsteca;

    @ManyToOne
    @JoinColumn(name = "id_doc_fiscal")
    private DocumentoFiscalModel documentoFiscal;

//    @OneToMany(cascade = CascadeType.PERSIST)
    @OneToMany(cascade = CascadeType.ALL)
    @JoinColumn(name = "item_asteca")
    private List<ItemSolicitacaoAstecaModel> itensAsteca = new ArrayList<>();

    @OneToOne
    @JoinColumn(name = "id_motivo")
    private AstecaMotivoModel motivoCriacaoAsteca = new AstecaMotivoModel();

}
