package com.develop.gpp.domain.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "fornecedor")
public class FornecedorModel {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Integer idFornecedor;

  private String nomeFornecedor;

  private String email;

  private String cnpj;

}
