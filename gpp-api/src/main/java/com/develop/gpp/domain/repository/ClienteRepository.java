package com.develop.gpp.domain.repository;

import com.develop.gpp.domain.entity.ClienteModel;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ClienteRepository extends JpaRepository<ClienteModel, Integer>{

}