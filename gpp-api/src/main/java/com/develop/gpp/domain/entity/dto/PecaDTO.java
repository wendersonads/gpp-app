package com.develop.gpp.domain.entity.dto;

import com.develop.gpp.domain.entity.ProdutoModel;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PecaDTO {

    private Integer idPeca;

    private String descricao;

    private String cor;

    private String material;

    private ProdutoModel produto;
}
