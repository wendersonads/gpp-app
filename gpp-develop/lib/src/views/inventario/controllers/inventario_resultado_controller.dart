import 'package:flutter/material.dart';
import 'package:gpp/src/models/inventario/inventario_model.dart';
import 'package:gpp/src/repositories/inventario/inventario_repository.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:get/get.dart';

class InventarioResultadoController extends GetxController {
  late int id;
  late InventarioModel? inventario;
  late InventarioModel? inventarioBusca = new InventarioModel();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var carregando = false.obs;
  late int codigo;
  late InventarioRepository inventarioRepository;

  InventarioResultadoController(int id) {
    this.id = id;
    inventario = new InventarioModel();
    inventarioRepository = InventarioRepository();
  }

  @override
  void onInit() async {
    await buscarInventario();
    super.onInit();
  }

  buscarInventario() async {
    try {
      carregando(true);

      inventario = await inventarioRepository.buscarInventario(this.id);
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
    }
  }

  void buscarInventarioPeca(String codigo) {
    try {
      carregando(true);

      if (inventario == null) return;

      inventarioBusca!.inventarioPeca =
          inventario!.inventarioPeca!.where((element) => element.id_peca.toString() == codigo).toList();
    } finally {
      carregando(false);
    }
  }

  corrigirEstoque() async {
    await Notificacao.confirmacao(
        'Esse processo realizar a atualização do saldo no estoque de acordo com o inventário realizado, para confirmar pressione sim ou não para cancelar.');
  }
}
