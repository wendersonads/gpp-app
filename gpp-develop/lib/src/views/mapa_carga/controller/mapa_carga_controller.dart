import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:gpp/src/models/caminhao_model.dart';
import 'package:gpp/src/models/item_mapa_carga_model.dart';
import 'package:gpp/src/models/mapa_carga_model.dart';
import 'package:gpp/src/models/motorista_model.dart';
import 'package:gpp/src/models/pedido_saida_model.dart';
import 'package:gpp/src/models/transportadora_model.dart';
import 'package:gpp/src/repositories/mapa_carga_repository.dart';
import 'package:gpp/src/repositories/transportadora_repository.dart';
import 'package:gpp/src/shared/services/auth.dart';

import 'package:gpp/src/utils/notificacao.dart';

import 'package:gpp/src/views/pecas/unidade.dart';

class MapaCargaController extends GetxController {
  var carregandoPedidos = false.obs;
  var carregandoTransportadora = false.obs;
  var carregandoCaminhao = false.obs;
  var carregandoMotorista = false.obs;
  var carregandoPedidosParaMapa = false.obs;
  var carregandoListaMapa = false.obs;
  var carregandoFinalizacao = false.obs;
  var carregandoSubDados = false.obs;
  var groupRadio = true.obs;
  late TextEditingController controllerIdTransportadora;
  late TextEditingController controllerNomeTransportadora;
  late MapaCargaRepository mapaCargaRepository;
  late TransportadoraRepository transpRepository;

  late GlobalKey<FormState> filtroFormKey;
  late GlobalKey<FormState> FormKeyMapaCarga;

  int marcados = 0;
  var isList = false.obs;

  late int? unidadeEspecie;

  late List<PedidoSaidaModel> listaPedidosSaidaBusca;
  late List<ItemPedidoMapa> listaPopUpPedidosSaidaBusca;
  late List<PedidoSaidaModel> listaPedidosParaEntrada;
  late List<TransportadoraModel> listaTransportadoras;
  late List<MotoristaModel> listaMotoristas;
  late List<CaminhaoModel> listaCaminhao;

  late TextEditingController controllerFiltroIdPedido;
  late TextEditingController controllerFiltroIdAsteca;
  late TextEditingController controllerFiltroNomeCliente;

  late TransportadoraModel transportadoraSelecionada;
  late CaminhaoModel caminhaoSelecionado;
  late MotoristaModel motoristaSelecionado;

  late TextEditingController controllerFilialDestino;
  late TextEditingController controllerVolume;
  late TextEditingController controllerEspecie;
  late TextEditingController controllerFilialOrigem;
  late UnidadeTipo especieDropDown;
  late MapaCargaModel mapaCargaFinalizado;
  var isEdicao = false.obs;
  var isMotoCaminhao = true.obs;

  late MapaCargaModel? mapaCargaEdicao;

  MapaCargaController({MapaCargaModel? mp}) {
    controllerIdTransportadora = TextEditingController();
    controllerNomeTransportadora = TextEditingController();
    listaPedidosSaidaBusca = <PedidoSaidaModel>[].obs;
    listaPopUpPedidosSaidaBusca = <ItemPedidoMapa>[].obs;
    listaPedidosParaEntrada = <PedidoSaidaModel>[].obs;
    listaTransportadoras = <TransportadoraModel>[].obs;
    listaMotoristas = <MotoristaModel>[].obs;
    listaCaminhao = <CaminhaoModel>[].obs;
    mapaCargaRepository = MapaCargaRepository();
    filtroFormKey = GlobalKey<FormState>();
    FormKeyMapaCarga = GlobalKey<FormState>();
    controllerFiltroIdPedido = TextEditingController();
    controllerFiltroIdAsteca = TextEditingController();
    controllerFiltroNomeCliente = TextEditingController();
    transpRepository = TransportadoraRepository();
    transportadoraSelecionada = TransportadoraModel();
    caminhaoSelecionado = CaminhaoModel();
    motoristaSelecionado = MotoristaModel();

    controllerFilialDestino = TextEditingController();
    controllerVolume = TextEditingController();
    controllerFilialOrigem = TextEditingController();

    especieDropDown = UnidadeTipo.Caixa;

    mapaCargaFinalizado = MapaCargaModel();
    mapaCargaEdicao = MapaCargaModel();
  }

  @override
  void onInit() async {
    await buscarTransportadoras();
    if (mapaCargaEdicao?.idMapaCarga != null) {
      isEdicao(true);
      await buscarMapaCargaEdicao();
    }
    super.onInit();
  }

  buscarPedidoSaida() async {
    try {
      listaPopUpPedidosSaidaBusca.clear();
      carregandoPedidos(true);
      var resposta = await mapaCargaRepository.buscarMapaCargaPedidosSaida(
        idPedido: controllerFiltroIdPedido.text != ''
            ? int.parse(controllerFiltroIdPedido.text)
            : null,
        idAsteca: controllerFiltroIdAsteca.text != ''
            ? int.parse(controllerFiltroIdAsteca.text)
            : null,
        nomeCliente: controllerFiltroNomeCliente.text != ''
            ? controllerFiltroNomeCliente.text
            : null,
      );

      listaPedidosSaidaBusca = resposta;

      gerarPedidosEntrada();
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoPedidos(false);
      marcados = 0;
      update();
    }
  }

  buscarMapaCargaEdicao() async {
    carregandoPedidos(true);
    carregandoMotorista(true);
    carregandoTransportadora(true);
    carregandoCaminhao(true);
    carregandoSubDados(true);
    try {
      mapaCargaEdicao = await mapaCargaRepository
          .buscarMapaCarga(mapaCargaEdicao!.idMapaCarga!);
      await preencheDadosParaEdicao();
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoPedidos(false);
      carregandoMotorista(false);
      carregandoTransportadora(false);
      carregandoCaminhao(false);
      carregandoSubDados(false);
      update();
    }
  }

  preencheDadosParaEdicao() {
    isList(true);
    for (var item in mapaCargaEdicao!.itemMapaCarga!) {
      listaPedidosParaEntrada.add(item.pedidoSaida!);
    }
    transportadoraSelecionada = mapaCargaEdicao!.transportadora!;
    caminhaoSelecionado = mapaCargaEdicao!.caminhao!;
    motoristaSelecionado = mapaCargaEdicao!.motorista!;
    controllerVolume.text = mapaCargaEdicao!.volume.toString();
    controllerFilialDestino.text =
        mapaCargaEdicao?.filialDestino?.id_filial.toString() ?? '-';

    mapaCargaEdicao!.tipoEntrega == 2 ? groupRadio(true) : groupRadio(false);

    controllerIdTransportadora.text =
        transportadoraSelecionada.idTransportadora?.toString() ?? '-';
    controllerNomeTransportadora.text =
        transportadoraSelecionada.contato?.toString() ?? '-';

    controllerFilialOrigem.text =
        mapaCargaEdicao?.filialOrigem?.id_filial.toString() ?? '-';

    especieDropDown = UnidadeTipo.values.firstWhere(
        (element) => element.name == mapaCargaEdicao!.especieVolume!);
  }

  validaFiltros() {
    if (controllerFiltroIdPedido.text != '' &&
        controllerFiltroIdAsteca.text != '') {
      Notificacao.snackBar("Somente um filtro por vez");
      return false;
    } else if (controllerFiltroIdPedido.text != '' &&
        controllerFiltroNomeCliente.text != '') {
      Notificacao.snackBar("Somente um filtro por vez");
      return false;
    } else if (controllerFiltroIdAsteca.text != '' &&
        controllerFiltroIdPedido.text != '') {
      Notificacao.snackBar("Somente um filtro por vez");
      return false;
    } else if (controllerFiltroIdAsteca.text != '' &&
        controllerFiltroNomeCliente.text != '') {
      Notificacao.snackBar("Somente um filtro por vez");
      return false;
    } else {
      return true;
    }
  }

  marcarTodosCheckbox(bool value) {
    if (value) {
      marcados = listaPedidosSaidaBusca.length;
    } else {
      marcados = 0;
    }
    for (var itemPedido in listaPopUpPedidosSaidaBusca) {
      itemPedido.marcado = value;
    }
  }

  marcarCheckbox(index, value) {
    if (value) {
      marcados++;
    } else {
      marcados--;
    }
    listaPopUpPedidosSaidaBusca[index].marcado = value;
  }

  gerarPedidosEntrada() {
    listaPedidosSaidaBusca.forEach((element) {
      listaPopUpPedidosSaidaBusca
          .add(ItemPedidoMapa(marcado: false, pedidoSaida: element));
    });
  }

  adicionarPedidosParaMapa() async {
    carregandoPedidosParaMapa(true);
    bool notifica = true;

    for (var item in listaPopUpPedidosSaidaBusca) {
      if (item.marcado!) {
        if (listaPedidosParaEntrada.any((element) =>
            element.idPedidoSaida == item.pedidoSaida!.idPedidoSaida)) {
          notifica = false;
        } else {
          listaPedidosParaEntrada.add(item.pedidoSaida!);
        }
      }
    }

    Get.back();
    notifica
        ? Notificacao.snackBar(
            "Todas as Ordens de Saída adicionadas com sucesso!")
        : Notificacao.snackBar("Já existe na lista");
    carregandoPedidosParaMapa(false);
    update();
  }

  removerPedidosMapa(PedidoSaidaModel item) {
    carregandoListaMapa(true);
    listaPedidosParaEntrada.remove(item);
    Notificacao.snackBar("Ordem de Saída Removida com sucesso!");
    carregandoListaMapa(false);
    update();
  }

  buscarTransportadoras() async {
    try {
      carregandoTransportadora(true);
      var resposta = await transpRepository.buscarTransportadoras();

      listaTransportadoras = resposta;
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoTransportadora(false);
      update();
    }
  }

  buscarTransportadora() async {
    try {
      carregandoTransportadora(true);
      var resposta = await transpRepository
          .buscarTransportadora(int.parse(controllerIdTransportadora.text));

      transportadoraSelecionada = resposta;

      controllerIdTransportadora.text =
          transportadoraSelecionada.idTransportadora.toString();
      controllerNomeTransportadora.text =
          transportadoraSelecionada.contato?.toString() ?? '-';
    } catch (e) {
      transportadoraSelecionada = TransportadoraModel();
      caminhaoSelecionado = CaminhaoModel();
      motoristaSelecionado = MotoristaModel();
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoTransportadora(false);
      update();
    }
  }

  buscarMotorista() async {
    try {
      carregandoMotorista(true);
      var resposta = await transpRepository
          .buscarMotoristas(int.parse(controllerIdTransportadora.text));
      await buscarCaminhao();
      listaMotoristas = resposta;
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoMotorista(false);
      update();
    }
  }

  buscarCaminhao() async {
    try {
      var resposta = await transpRepository
          .buscarCaminhoes(int.parse(controllerIdTransportadora.text));

      listaCaminhao = resposta;
    } catch (e) {
      limpaMotoCaminhao();
      Notificacao.snackBar(e.toString());
    } finally {
      update();
    }
  }

  limparBuscas() async {
    carregandoTransportadora(true);
    carregandoMotorista(true);
    transportadoraSelecionada = TransportadoraModel();
    caminhaoSelecionado = CaminhaoModel();
    motoristaSelecionado = MotoristaModel();
    FormKeyMapaCarga.currentState!.reset();
    await buscarTransportadoras();
    controllerIdTransportadora.clear();
    controllerNomeTransportadora.clear();
    listaMotoristas.clear();
    listaCaminhao.clear();
    controllerVolume.clear();
    controllerFilialDestino.clear();
    carregandoMotorista(false);
    carregandoTransportadora(false);
    update();
  }

  limpaMotoCaminhao() {
    carregandoCaminhao(true);
    caminhaoSelecionado = CaminhaoModel();
    listaMotoristas = [];
    listaCaminhao = [];
    motoristaSelecionado = MotoristaModel();
    carregandoCaminhao(false);
    update();
  }

  finalizarMapaCarga() async {
    carregandoFinalizacao(true);
    try {
      if (listaPedidosParaEntrada.isNotEmpty) {
        if (transportadoraSelecionada.idTransportadora == null ||
            caminhaoSelecionado.idCaminhao == null ||
            motoristaSelecionado.idMotorista == null) {
          Notificacao.snackBar(
              "Selecione Transportadora, Caminhão e Motorista para prosseguir");
        } else if (groupRadio.value
            ? controllerFilialDestino.text == ''
            : false || controllerVolume.text == '') {
          Notificacao.snackBar("Informe Filial de Destino e Volume prosseguir");
        } else {
          List<ItemMapaCargaModel> items = [];

          for (var item in listaPedidosParaEntrada) {
            items.add(ItemMapaCargaModel(pedidoSaida: item));
          }

          MapaCargaModel mp = MapaCargaModel(
              caminhao: caminhaoSelecionado,
              especieVolume: especieDropDown.name,
              idFilialDestino: groupRadio.value
                  ? int.parse(controllerFilialDestino.text)
                  : null,
              idFilialOrigem: getFilial().id_filial,
              idCaminhao: caminhaoSelecionado.idCaminhao,
              idFuncionario: getUsuario().uid,
              idMotorista: motoristaSelecionado.idMotorista,
              idTransportadora: transportadoraSelecionada.idTransportadora,
              volume: int.parse(controllerVolume.text),
              tipoEntrega: groupRadio.value ? 2 : 1,
              itemMapaCarga: items);

          if (await mapaCargaRepository.criarMapaCarga(mp)) {
            Notificacao.snackBar("Mapa de carga finalizado com sucesso!");
            Get.delete<MapaCargaController>();
            Get.offAllNamed('/mapa-carga');
          }
        }
      } else {
        Notificacao.snackBar(
            "Adicone Ordens de Saída para o Mapa antes de Finalizar!");
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoFinalizacao(false);
      update();
    }
  }

  finalizarMapaCargaEdicao() async {
    carregandoFinalizacao(true);
    try {
      if (listaPedidosParaEntrada.isNotEmpty) {
        if (transportadoraSelecionada.idTransportadora == null ||
            caminhaoSelecionado.idCaminhao == null ||
            motoristaSelecionado.idMotorista == null) {
          Notificacao.snackBar(
              "Selecione Transportadora, Caminhão e Motorista para prosseguir");
        } else if (controllerFilialDestino.text == '' ||
            controllerVolume.text == '') {
          Notificacao.snackBar("Informe Filial de Destino e Volume prosseguir");
        } else {
          List<ItemMapaCargaModel> items = [];

          for (var item in listaPedidosParaEntrada) {
            items.add(ItemMapaCargaModel(
              pedidoSaida: item,
              idPedidoSaida: item.idPedidoSaida ?? null,
              idMapaCarga: mapaCargaEdicao?.idMapaCarga ?? null,
            ));
          }

          MapaCargaModel mp = MapaCargaModel(
              idMapaCarga: mapaCargaEdicao!.idMapaCarga!,
              caminhao: caminhaoSelecionado,
              especieVolume: especieDropDown.name,
              idFilialDestino: groupRadio.value
                  ? int.parse(controllerFilialDestino.text)
                  : null,
              idFilialOrigem: int.parse(controllerFilialOrigem.text),
              idCaminhao: caminhaoSelecionado.idCaminhao,
              idFuncionario: getUsuario().uid,
              idMotorista: motoristaSelecionado.idMotorista,
              idTransportadora: transportadoraSelecionada.idTransportadora,
              volume: int.parse(controllerVolume.text),
              tipoEntrega: groupRadio.value ? 2 : 1,
              itemMapaCarga: items);

          if (await mapaCargaRepository.atualizarMapaCarga(mp)) {
            Notificacao.snackBar("Mapa de carga Atualizado com sucesso!");
          }
        }
      } else {
        Notificacao.snackBar(
            "Adicone Ordens de Saída para o Mapa antes de Finalizar!");
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoFinalizacao(false);
      update();
    }
  }
}

class ItemPedidoMapa {
  bool? marcado = false;
  late PedidoSaidaModel? pedidoSaida;
  ItemPedidoMapa({
    this.marcado,
    this.pedidoSaida,
  });
}
