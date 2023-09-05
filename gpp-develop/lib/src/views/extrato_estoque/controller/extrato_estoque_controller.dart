import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/movimento_estoque/movimento_estoque_model.dart';
import 'package:gpp/src/models/movimento_estoque/tipo_movimento_estoque_model.dart';

import 'package:gpp/src/repositories/movimento_estoque/movimento_estoque_repository.dart';
import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:gpp/src/utils/notificacao.dart';

class ExtratoEstoqueController extends GetxController {
  var carregandoExtrato = false.obs;
  var carregandoTipoMovimento = false.obs;
  var filtro = false.obs;
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController dataInicioController;
  late TextEditingController dataFimController;

  late TextEditingController idPedidoController;
  late TextEditingController idPecaController;
  late TextEditingController reFuncionarioController;

  late MaskFormatter maskFormatter;

  late MovimentoEstoqueRepository repository;

  late List<TipoMovimentoEstoqueModel> tiposMovimento;
  late TipoMovimentoEstoqueModel tipoMovimentoController;
  late List<MovimentoEstoqueModel> movimentos;

  ExtratoEstoqueController() {
    maskFormatter = MaskFormatter();
    dataInicioController = TextEditingController();
    dataFimController = TextEditingController();
    idPedidoController = TextEditingController();
    idPecaController = TextEditingController();
    reFuncionarioController = TextEditingController();
    repository = MovimentoEstoqueRepository();
    tiposMovimento = <TipoMovimentoEstoqueModel>[].obs;
    tipoMovimentoController = TipoMovimentoEstoqueModel();
    movimentos = <MovimentoEstoqueModel>[].obs;
  }

  @override
  void onInit() async {
    await buscarMovimentos();
    await buscarTipoMovimento();

    super.onInit();
  }

  buscarTipoMovimento() async {
    try {
      carregandoTipoMovimento(true);

      tiposMovimento = await repository.buscarTiposMovimentoEstoque();
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoTipoMovimento(false);
      update();
    }
  }

  buscarMovimentos() async {
    try {
      carregandoExtrato(true);
      movimentos = await repository.buscarMovimentoEstoque(
        idPeca: idPecaController.text.isNotEmpty ? int.parse(idPecaController.text) : null,
        idTipoMovimento: tipoMovimentoController.id_tipo_movimento_estoque,
        reCliente: reFuncionarioController.text,
        idPedido: idPedidoController.text.isNotEmpty ? int.parse(idPedidoController.text) : null,
        dataInicio: dataInicioController.text,
        dataFim: dataFimController.text,
      );
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoExtrato(false);
      update();
    }
  }

  limparFiltros() {
    formKey.currentState!.reset();
    tipoMovimentoController = TipoMovimentoEstoqueModel();
  }
}
