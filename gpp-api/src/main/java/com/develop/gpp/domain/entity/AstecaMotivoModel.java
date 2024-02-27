package com.develop.gpp.domain.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "asteca_motivo")
public class AstecaMotivoModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idAstecaMotivo;

    @Column(nullable = true)
    private String denominacao;

   
    private LocalDateTime dataCriacao;

    @Column(nullable = true)
    private LocalDateTime dataAlteracao;

}
