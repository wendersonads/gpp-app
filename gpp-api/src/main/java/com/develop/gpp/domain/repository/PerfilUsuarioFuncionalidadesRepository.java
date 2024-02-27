package com.develop.gpp.domain.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.develop.gpp.domain.entity.PerfilUsuarioFuncionalidades;

@Repository
public interface PerfilUsuarioFuncionalidadesRepository extends JpaRepository<PerfilUsuarioFuncionalidades,Integer>{

    List<PerfilUsuarioFuncionalidades> findByPerfilUsuario(Integer id);
    
}
