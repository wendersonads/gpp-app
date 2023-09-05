import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/motivo_model.dart';
import 'package:gpp/src/models/movimento_estoque/ajuste_estoque_model.dart';
import 'package:gpp/src/repositories/motivo_estoque_repository.dart';
import 'package:gpp/src/repositories/movimento_estoque/ajuste_estoque_repository.dart';

import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:gpp/src/utils/notificacao.dart';

class ExtratoAjusteEstoqueController extends GetxController {
  var carregandoExtrato = false.obs;
  var carregandoMotivo = false.obs;

  late MotivoEstoqueRepository motivoRepository;

  var filtro = false.obs;
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController dataInicioController;
  late TextEditingController dataFimController;

  late TextEditingController idPecaController;
  late TextEditingController reFuncionarioController;

  late MaskFormatter maskFormatter;

  late AjusteEstoqueRepository repository;

  late List<MotivoModel> motivos;
  late MotivoModel motivoController;
  late List<AjusteEstoqueModel> ajustes;

  ExtratoAjusteEstoqueController() {
    maskFormatter = MaskFormatter();
    dataInicioController = TextEditingController();
    dataFimController = TextEditingController();
    idPecaController = TextEditingController();
    reFuncionarioController = TextEditingController();
    repository = AjusteEstoqueRepository();
    motivos = <MotivoModel>[].obs;
    motivoController = MotivoModel();
    ajustes = <AjusteEstoqueModel>[].obs;
    motivoRepository = MotivoEstoqueRepository();
  }

  @override
  void onInit() async {
    await buscarAjustes();
    await buscarMotivos();

    super.onInit();
  }

  buscarMotivos() async {
    try {
      carregandoMotivo(true);

      motivos = await motivoRepository.buscarMotivosAjusteEstoque();
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoMotivo(false);
      update();
    }
  }

  buscarAjustes() async {
    try {
      carregandoExtrato(true);

      ajustes = await repository.buscarAjustesEstoques(
        idPeca: idPecaController.text.isNotEmpty
            ? int.parse(idPecaController.text)
            : null,
        idMotivo: motivoController.idMotivo,
        reCliente: reFuncionarioController.text,
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

  situacao(int situacao) {
    return AjusteEnum.values
        .firstWhere((element) => element.index == situacao)
        .name;
  }

  limparFiltros() {
    formKey.currentState!.reset();
    motivoController = MotivoModel();
  }
}

enum AjusteEnum { Reprovado, Aprovado, Pendente }
