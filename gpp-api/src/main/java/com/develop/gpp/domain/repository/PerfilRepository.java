package com.develop.gpp.domain.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.develop.gpp.domain.entity.PerfilUsuarioModel;

@Repository
public interface PerfilRepository extends JpaRepository<PerfilUsuarioModel,Long>{
    
}
