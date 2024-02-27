package com.develop.gpp.domain.enumeradores;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public enum TipoAstecaEnum {

    VISTORIA("Vistoria", 1),
    REPARO("Reparo", 2);
  
    private int valor;
    private String descricao;

    private TipoAstecaEnum(String descricao, int valor) {
        this.descricao = descricao;
        this.valor = valor;
    }

}
