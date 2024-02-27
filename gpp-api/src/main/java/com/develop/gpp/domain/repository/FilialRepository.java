package com.develop.gpp.domain.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.develop.gpp.domain.entity.FilialModel;

@Repository
public interface  FilialRepository extends JpaRepository<FilialModel,Integer> {

    Optional<FilialModel> findByNumeroFilial (Integer numeroFilial);
   
}
