import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/avaria/avaria_model.dart';
import 'package:gpp/src/repositories/avaria_repository/avaria_repository.dart';
import 'package:gpp/src/utils/notificacao.dart';

class ConsultaProdutoAvariaController extends GetxController {
  RxBool formFiltragemVisivel = false.obs;
  late GlobalKey<FormState> formFiltragemAvariaKey;
  late List<AvariaModel> avarias;
  late AvariaRepository avariaRepository;

  int? id_filial;
  int? id_avaria;
  int? id_solicitador;
  int? situacao;

  RxBool isLoading = false.obs;

  ConsultaProdutoAvariaController() {
    avariaRepository = AvariaRepository();
  }

  @override
  void onInit() async {
    super.onInit();

    await buscarAvarias();
  }

  Future<void> buscarAvarias() async {
    try {
      isLoading(true);

      avarias = await avariaRepository.buscarAvarias(
          id_avaria: id_avaria,
          id_filial: id_filial,
          id_solicitador: id_solicitador,
          situacao: situacao);
    } catch (e) {
      Notificacao.snackBar(
        e.toString(),
        tipoNotificacao: TipoNotificacaoEnum.error,
      );
    } finally {
      isLoading(false);
    }
  }

  void alternarVisibilidadeFormFiltragem() {
    formFiltragemVisivel.value = !formFiltragemVisivel.value;
  }
}
