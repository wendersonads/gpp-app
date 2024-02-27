package com.develop.gpp.domain.repository;

import com.develop.gpp.domain.entity.AstecaMotivoModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AstecaMotivoRepository extends JpaRepository<AstecaMotivoModel, Integer> {

}
