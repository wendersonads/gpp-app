
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/models/pedido_saida_model.dart';
import 'package:gpp/src/models/produto/produto_model.dart';
import 'package:gpp/src/models/produto_peca_model.dart';

import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:gpp/src/views/separacao/controllers/separacao_controller.dart';

import '../../../repositories/pedido_saida_repository.dart';

class SeparacaoDetalheController extends GetxController {
  late int id;
  var count = 0;
  var etapa = 1.obs;
  var carregando = true.obs;
  var carregandoBotaoSeparar = false.obs;
  var separacaoCompleta = true.obs;
  var iniciandoSeparacao = false.obs;
  var finalizando = false.obs;
  late PedidoSaidaRepository pedidoSaidaRepository;
  late List<ProdutoModel> produtos;
  late List<ProdutoPecaModel> produtoPecas;

  late MaskFormatter maskFormatter;
  late GlobalKey<FormState> formKey;
  int marcados = 0;
  late PedidoSaidaModel pedidoSaida;

  SeparacaoDetalheController(int id) {
    pedidoSaidaRepository = PedidoSaidaRepository();
    produtos = <ProdutoModel>[].obs;
    produtoPecas = <ProdutoPecaModel>[].obs;

    formKey = GlobalKey<FormState>();
    maskFormatter = MaskFormatter();
    this.id = id;
    pedidoSaida = PedidoSaidaModel();
  }

  @override
  void onInit() async {
    super.onInit();
    await buscarPedidoSaida();
  }

  @override
  void onClose() {
    super.onClose();
  }

  buscarPedidoSaida() async {
    try {
      carregando(true);
      this.pedidoSaida = await pedidoSaidaRepository.buscarPedidoSaidaSeparacao(this.id);
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      verificarSeparacaoCompleta();
      carregando(false);
    }
  }

  separarItemPedidoSaidaPeca(int idItemPedidoSaida, int idPeca) async {
    carregandoBotaoSeparar(true);
    try {
      await pedidoSaidaRepository.separarItemPedidoSaidaPeca(pedidoSaida.idPedidoSaida!, idItemPedidoSaida, idPeca);
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      buscarPedidoSaida();
      carregandoBotaoSeparar(false);
    }
  }

  separarPeca(int idPeca) async {
    try {
      await pedidoSaidaRepository.separarPeca(pedidoSaida.idPedidoSaida!, idPeca);
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      buscarPedidoSaida();
    }
  }

  cancelarItemPedidoSaidaPeca(int idItemPedidoSaida, int idPeca) async {
    try {
      if (await Notificacao.confirmacao('Deseja cancelar a separação dessa peça ?')) {
        await pedidoSaidaRepository.cancelarItemPedidoSaidaPeca(pedidoSaida.idPedidoSaida!, idItemPedidoSaida, idPeca);
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      buscarPedidoSaida();
    }
  }

  alterarPedidoSaidaEvento(idPedidoSaidaStatus) async {
    iniciandoSeparacao(true);
    try {
      await pedidoSaidaRepository.iniciarSeparacao(pedidoSaida.idPedidoSaida!);
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      iniciandoSeparacao(false);
      buscarPedidoSaida();
    }
  }

  finalizarSeparacao() async {
    try {
      finalizando(true);
      if (await Notificacao.confirmacao(
          'Ao finalizar a separação, todos os itens serão direcionados para o box de saida, pressiona sim para confirmar ou não para cancelar')) {
        await pedidoSaidaRepository.finalizarSeparacao(pedidoSaida.idPedidoSaida!);
        Get.delete<SeparacaoController>();
        Get.toNamed('/separacao');
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      finalizando(false);
      buscarPedidoSaida();
    }
  }

  void verificarSeparacaoCompleta() {
    int contador = 0;

    pedidoSaida.itemsPedidoSaida!.forEach((element) {
      if (element.separado != element.quantidade) {
        return;
      }
      contador++;
    });

    if (contador == pedidoSaida.itemsPedidoSaida!.length) {
      separacaoCompleta(true);
    } else {
      separacaoCompleta(false);
    }
  }
}
