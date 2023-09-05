import 'package:flutter/material.dart';
import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/pedido_saida_model.dart';
import 'package:gpp/src/repositories/pedido_saida_repository.dart';
import 'package:intl/intl.dart';

class Situacao {
  int? id;
  String? descricao;
  Situacao({
    this.id,
    this.descricao,
  });
}

class PedidoSaidaController {
  int? idPedido;

  Situacao? selecionado;
  PedidoSaidaRepository pedidoRepository = PedidoSaidaRepository();
  bool carregado = false;

  List<PedidoSaidaModel> pedidosAguarando = [];
  PedidoSaidaModel pedido = PedidoSaidaModel();

  GlobalKey<FormState> filtroExpandidoFormKey = GlobalKey<FormState>();
  bool abrirFiltro = false; // false
  PaginaModel pagina = PaginaModel(total: 0, atual: 1);
  PaginaModel paginaAguarando = PaginaModel(total: 0, atual: 1);

  camelCaseAll(String? value) {
    String? nome = '';
    value!.split(" ").forEach((element) {
      if (element.length > 3) {
        nome = nome! +
            " ${toBeginningOfSentenceCase(element.toString().toLowerCase())}";
      } else {
        nome = nome! + " ${element.toString().toLowerCase()}";
      }
    });
    return nome;
  }

  camelCaseFirst(String? value) {
    return toBeginningOfSentenceCase(value.toString().toLowerCase());
  }
}
