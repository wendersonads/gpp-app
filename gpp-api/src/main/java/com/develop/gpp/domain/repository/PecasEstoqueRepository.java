package com.develop.gpp.domain.repository;

import com.develop.gpp.domain.entity.PecaModel;
import com.develop.gpp.domain.entity.PecasEstoqueModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PecasEstoqueRepository extends JpaRepository<PecasEstoqueModel, Integer> {
    List<PecasEstoqueModel> findByPeca_IdPeca(Integer idPeca);

    @Query(nativeQuery = true, value = "select * from pecas_estoque pe join peca p on p.id_peca = pe.id_peca join produto p2 on p2.id_produto = p.produto_id where p.produto_id = :prod")
    List<PecasEstoqueModel> listarPorProduto(@Param("prod") Integer prod);
}

