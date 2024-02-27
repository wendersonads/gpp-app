package com.develop.gpp.domain.entity;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@Entity
@ToString
@Table(name = "item_solicitacao_asteca")
public class ItemSolicitacaoAstecaModel {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idItemAsteca;
    
    private int quantidade;
      
    @OneToOne
    @JoinColumn(name = "id_peca_estoque")
    private PecasEstoqueModel pecaEstoque;
                            
    
}
