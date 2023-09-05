
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/evento_status_model.dart';
import 'package:gpp/src/models/pedido_saida_model.dart';
import 'package:gpp/src/repositories/evento_status_repository.dart';
import 'package:gpp/src/repositories/pedido_saida_repository.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:intl/intl.dart';

class PedidoSaidaController extends GetxController {
  var selected = 1.obs;

  var carregando = false.obs;

  var carregandoEventosPedidoSaida = false.obs;
  late PaginaModel pagina;
  var abrirFiltro = false.obs;
  List<PedidoSaidaModel> pedidos = [];
  late EventoStatusRepository eventoStatusRepository;
  late List<EventoStatusModel> eventosPedidoSaida;
  late EventoStatusModel? eventoSelecionado;
  late PedidoSaidaRepository pedidoSaidaRepository;
  String? pesquisar = '';
  DateTime? dataInicio;
  DateTime? dataFim;
  GlobalKey<FormState> filtroExpandidoFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> filtroFormKey = GlobalKey<FormState>();

  NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
  PedidoSaidaController() {
    pagina = PaginaModel(atual: 1, total: 0);
    eventoStatusRepository = EventoStatusRepository();
    eventosPedidoSaida = <EventoStatusModel>[].obs;
    eventoSelecionado = EventoStatusModel();
    pedidoSaidaRepository = PedidoSaidaRepository();
  }

  @override
  void onInit() async {
    await buscarTodosPedidoSaida();
    await buscarEventosPedidoSaida();
    super.onInit();
  }

  buscarPedidosSaidaMenu() async {
    switch (selected.value) {
      case 1:
        await buscarTodosPedidoSaida();

        break;
      case 2:
        await buscarPedidoSaidaEmAberto();
        break;
      case 3:
        await buscarPedidoSaidaEmAtendimento();

        break;
      case 4:
        await buscarPedidoSaidaCriadoPorMim();
        break;
    }
    limparFiltro();
  }

  limparFiltro() {
    filtroExpandidoFormKey.currentState!.reset();
    filtroFormKey.currentState!.reset();
    pesquisar = null;
    dataFim = null;
    dataInicio = null;
    eventoSelecionado = null;
    update();
  }

  buscarTodosPedidoSaida() async {
    try {
      pedidos = [];
      carregando(true);

      //parei aqui
      var retorno = await pedidoSaidaRepository.buscarTodosPedidosSaida(
          pagina.atual,
          pesquisar: pesquisar,
          dataInicio: dataInicio,
          dataFim: dataFim,
          eventoStatus: eventoSelecionado);

      pedidos = retorno[0];
      pagina = retorno[1];
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregando(false);
      update();
    }
  }

  buscarPedidoSaidaEmAberto() async {
    try {
      pedidos = [];
      carregando(true);

      //parei aqui
      var retorno = await pedidoSaidaRepository.buscarPedidosSaidaEmAberto(
          pagina.atual,
          pesquisar: pesquisar,
          dataInicio: dataInicio,
          dataFim: dataFim,
          eventoStatus: eventoSelecionado);

      pedidos = retorno[0];
      pagina = retorno[1];
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregando(false);
      update();
    }
  }

  buscarPedidoSaidaEmAtendimento() async {
    try {
      carregando(true);

      //parei aqui
      var retorno = await pedidoSaidaRepository.buscarPedidosSaidaEmAtendimento(
          pagina.atual,
          pesquisar: pesquisar,
          dataInicio: dataInicio,
          dataFim: dataFim,
          eventoStatus: eventoSelecionado);

      pedidos = retorno[0];
      pagina = retorno[1];
    } catch (e) {
      pedidos = [];
      Notificacao.snackBar(e.toString());
    } finally {
      carregando(false);
      update();
    }
  }

  buscarPedidoSaidaCriadoPorMim() async {
    try {
      carregando(true);

      //parei aqui
      var retorno = await pedidoSaidaRepository.buscarPedidosSaidaCriadoPorMim(
          pagina.atual,
          pesquisar: pesquisar,
          dataInicio: dataInicio,
          dataFim: dataFim,
          eventoStatus: eventoSelecionado);

      pedidos = retorno[0];
      pagina = retorno[1];
    } catch (e) {
      pedidos = [];
      Notificacao.snackBar(e.toString());
    } finally {
      carregando(false);
      update();
    }
  }

  // buscarPedidosSaidaEmAtendimento() async {
  //   try {
  //     carregandoAguardando(true);

  //     //parei aqui
  //     var retorno = await pedidoController.pedidoSaidaRepository
  //         .buscarPedidosSaidaAguardandoFornecedor(
  //             pedidoController.paginaAguarando.atual,
  //             idPedido: pedidoController.idPedido,
  //             dataInicio: dataInicio,
  //             dataFim: dataFim,
  //             situacao: pedidoController.selecionado?.id ?? null);

  //     pedidoController.pedidosAguarando = retorno[0];
  //     pedidoController.paginaAguarando = retorno[1];
  //   } catch (e) {
  //     Notificacao.snackBar(e.toString());

  //     pedidoController.pedidosAguarando = [];
  //   } finally {
  //     carregandoAguardando(false);
  //     update();
  //   }
  // }

  buscarEventosPedidoSaida() async {
    try {
      carregandoEventosPedidoSaida(true);

      //parei aqui
      eventosPedidoSaida =
          await eventoStatusRepository.buscarEventosPedidoSaida();
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      carregandoEventosPedidoSaida(false);
      update();
    }
  }
}
