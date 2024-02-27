package com.develop.gpp.domain.entity;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Table;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;

import java.math.BigDecimal;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Entity
@ToString
@Table(name = "item_documento_fiscal")
public class ItemDocumentoFiscalModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idItemDocFiscal;

    // @ManyToOne
    // private DocumentoFiscalModel documentoFiscal;

    @OneToOne
    @JoinColumn(name = "id_produto")
    private ProdutoModel produto;

    private Integer qtde;

    private Double valorVenda;

    public Double valorTotal(Integer qtd, Double valorVenda) {

        return (valorVenda * qtde);
    }

}
