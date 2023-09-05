import 'package:flutter/material.dart';
import 'package:gpp/src/models/produto/produto_model.dart';
import 'package:gpp/src/repositories/pecas_repository/produto_repositoy.dart';

class ProdutoController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final ProdutoRepository produtoRepository = ProdutoRepository();
  ProdutoModel produto = ProdutoModel();

  List<ProdutoModel> listaProdutos = [];

  Future<void> buscar(String id) async {
    produto = await produtoRepository.buscar(id);
  }

  Future<ProdutoModel> buscar2(String id) async {
    return await produtoRepository.buscar(id);
  }
}
