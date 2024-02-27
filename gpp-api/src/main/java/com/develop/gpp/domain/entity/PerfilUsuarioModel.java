package com.develop.gpp.domain.entity;

import java.util.List;

import javax.persistence.*;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonManagedReference;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "perfil_usuario")
public class PerfilUsuarioModel {
    
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long  idPerfilUsuario;

    private String descricao;

    @OneToMany(mappedBy = "perfilUsuario", cascade = CascadeType.PERSIST)
    @JsonManagedReference
    List<PerfilUsuarioFuncionalidades> perfilUsuarioFuncionalidades;
    
}
