package com.develop.gpp.domain.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "filial")
public class FilialModel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer idFilial;

    private String sigla;

    private Integer numeroFilial;

}
