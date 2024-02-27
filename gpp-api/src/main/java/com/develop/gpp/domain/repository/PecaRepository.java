package com.develop.gpp.domain.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactory;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.PathVariable;

import com.develop.gpp.domain.entity.PecaModel;

@Repository
public interface PecaRepository extends JpaRepository<PecaModel, Integer> {

    @Query(nativeQuery = true, value = "SELECT * FROM peca pc INNER JOIN produto p ON pc.produto_id = p.id_produto WHERE p.id_produto = :prod")
    List<PecaModel> buscarPorProduto(@Param("prod") Integer prod);

}
