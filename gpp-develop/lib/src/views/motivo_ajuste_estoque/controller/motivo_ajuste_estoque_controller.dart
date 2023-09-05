import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/motivo_model.dart';
import 'package:gpp/src/repositories/motivo_estoque_repository.dart';

import '../../../utils/notificacao.dart';

class MotivoAjusteEstoqueController extends GetxController {
  var carregando = false.obs;
  var radioGroup = true.obs;
  late List<MotivoModel> motivosAjusteEstoque;
  late MotivoModel motivoAjusteEstoque;
  late MotivoEstoqueRepository motivoAjusteEstoqueRepository;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  MotivoAjusteEstoqueController() {
    motivosAjusteEstoque = <MotivoModel>[].obs;
    motivoAjusteEstoqueRepository = MotivoEstoqueRepository();
    motivoAjusteEstoque = MotivoModel();
  }
  @override
  void onInit() async {
    super.onInit();

    await buscarMotivosAjusteEstoque();
  }

  buscarMotivosAjusteEstoque() async {
    try {
      carregando(true);
      this.motivosAjusteEstoque = await motivoAjusteEstoqueRepository.buscarMotivosAjusteEstoque();
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
    }
  }

  criarMotivoAjusteEstoque(MotivoModel motivo) async {
    try {
      if (formKey.currentState!.validate()) {
        // carregando(true);
        if (await motivoAjusteEstoqueRepository.create(motivo)) {
          Notificacao.snackBar('Motivo de ajuste de estoque cadastrado com sucesso',
              tipoNotificacao: TipoNotificacaoEnum.sucesso);
          Get.offAllNamed('/estoque/motivo');
        }
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      //carregando(false);
    }
  }

  atualizarMotivoAjusteEstoque(MotivoModel motivo) async {
    try {
      // carregando(true);
      if (await motivoAjusteEstoqueRepository.update(motivo)) {
        Notificacao.snackBar('Motivo de ajuste de estoque atualizado com sucesso', tipoNotificacao: TipoNotificacaoEnum.sucesso);
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      Get.offAllNamed('/estoque/motivo');
    }
  }

  excluirMotivoAjusteEstoque(MotivoModel motivo) async {
    try {
      // carregando(true);
      if (await motivoAjusteEstoqueRepository.excluir(motivo)) {
        Notificacao.snackBar('Motivo de ajuste de estoque excluído com sucesso', tipoNotificacao: TipoNotificacaoEnum.sucesso);
        Get.offAllNamed('/estoque/motivo');
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      //carregando(false);
    }
  }
}
