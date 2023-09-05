import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/motivo_model.dart';
import 'package:gpp/src/models/movimento_estoque/ajuste_estoque_model.dart';
import 'package:gpp/src/models/pecas_model/pecas_estoque_model.dart';
import 'package:gpp/src/repositories/motivo_estoque_repository.dart';
import 'package:gpp/src/repositories/movimento_estoque/ajuste_estoque_repository.dart';
import 'package:gpp/src/repositories/pecas_repository/peca_estoque_repository.dart';
import 'package:gpp/src/utils/notificacao.dart';

class EstoqueAjusteController extends GetxController {
  int id;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late PecaEstoqueRepository pecaEstoqueRepository;
  late MotivoEstoqueRepository motivoEstoqueRepository;
  late AjusteEstoqueRepository ajusteRepository;
  var carregando = true.obs;
  var finalizando = false.obs;
  var carregandoMotivosAjusteEstoque = true.obs;
  late PecasEstoqueModel pecaEstoque;
  late AjusteEstoqueModel ajusteUpdate;
  late MotivoModel motivoSelecionado;
  var errorText = Rxn<String>();
  late List<MotivoModel> motivosAjusteEstoque;

  EstoqueAjusteController(this.id) {
    pecaEstoqueRepository = PecaEstoqueRepository();
    motivoEstoqueRepository = MotivoEstoqueRepository();
    pecaEstoque = PecasEstoqueModel();
    ajusteUpdate = AjusteEstoqueModel();
    motivosAjusteEstoque = <MotivoModel>[].obs;
    motivoSelecionado = MotivoModel();
    ajusteRepository = AjusteEstoqueRepository();
  }

  @override
  void onInit() async {
    super.onInit();
    await buscarPecaEstoque();
    await buscarMotivosAjusteEstoque();
  }

  buscarPecaEstoque() async {
    try {
      carregando(true);
      this.pecaEstoque = await pecaEstoqueRepository.buscarPecaEstoque(id);
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregando(false);
    }
  }

  buscarMotivosAjusteEstoque() async {
    try {
      carregandoMotivosAjusteEstoque(true);
      this.motivosAjusteEstoque = await motivoEstoqueRepository.buscarMotivosAjusteEstoque();
    } finally {
      carregandoMotivosAjusteEstoque(false);
    }
  }

  adicionarEstoque() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      //Verifica se a quantidade informada é maior que a quantidade disponível
      if (await Notificacao.confirmacao(
          'Esse estoque será alterado, gostaria de continuar pressione sim ou não para cancelar!')) {
        try {
          finalizando(true);
          if (await ajusteRepository.AdicionarSaldoPecaEstoque(pecaEstoque.id_peca_estoque!, ajusteUpdate)) {
            Notificacao.snackBar('Operacão relizada com sucesso!');
            Get.offAllNamed('/estoques');
          }
        } catch (e) {
          Notificacao.snackBar(e.toString());
        } finally {
          finalizando(false);
          update();
        }
      }
    }
  }

  removerEstoque() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      //Verifica se a quantidade informada é maior que a quantidade disponível
      if (ajusteUpdate.qtd_ajuste! > pecaEstoque.saldo_disponivel!) {
        errorText('Quantidade superior ao saldo disponível !');
      } else {
        if (await Notificacao.confirmacao(
            'Esse estoque será alterado, gostaria de continuar pressione sim ou não para cancelar!')) {
          try {
            finalizando(true);
            if (await ajusteRepository.SubtrairSaldoPecaEstoque(pecaEstoque.id_peca_estoque!, ajusteUpdate)) {
              Notificacao.snackBar('Operacão relizada com sucesso!');
              Get.offAllNamed('/estoques');
            }
          } catch (e) {
            Notificacao.snackBar(e.toString());
          } finally {
            finalizando(false);
            update();
          }
        }
      }
    }
  }

  removerEnderecamento() async {
    if (await Notificacao.confirmacao(
        'O endereçamento será removido, gostaria de continuar pressione sim ou não para cancelar!')) {
      try {
        finalizando(true);
        if (await ajusteRepository.removerEnderecamento(pecaEstoque)) {
          Notificacao.snackBar('Operacão relizada com sucesso!');
          Get.offAllNamed('/estoques');
        }
      } catch (e) {
        Notificacao.snackBar(e.toString());
      } finally {
        finalizando(false);
        update();
      }
    }
  }
}
