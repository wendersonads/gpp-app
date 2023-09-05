import 'package:gpp/src/models/item_pedido_entrada_model.dart';
import 'package:gpp/src/models/entrada/item_movimento_entrada_model.dart';
import 'package:gpp/src/models/entrada/movimento_entrada_model.dart';
import 'package:gpp/src/models/pecas_model/peca_model.dart';
import 'package:gpp/src/repositories/entrada/movimento_entrada_repository.dart';
import 'package:gpp/src/shared/services/auth.dart';
import 'package:gpp/src/utils/notificacao.dart';

class MovimentoEntradaController {
  MovimentoEntradaModel? movimentoEntradaModel = MovimentoEntradaModel();

  List<ItemPedidoEntradaModel> listaItensSomados = [];

  List<ItemMovimentoEntradaModel> listaItens = [];

  List<PecasModel> listPecasSomadas = [];

  int? id_fornecedor;

  late final MovimentoEntradaRepository movimentoEntradaRepository =
      MovimentoEntradaRepository();

  Future<List<MovimentoEntradaModel>> buscarTodos(String? id_filial,
      {String? id_funcionario}) async {
    try {
      return await movimentoEntradaRepository.buscarTodos(id_filial,
          id_funcionario: id_funcionario);
    } catch (e) {
      Notificacao.snackBar(e.toString());
      return [];
    }
  }

  Future<MovimentoEntradaModel> buscar(int idMovimento) async {
    return await movimentoEntradaRepository.buscar(idMovimento);
  }

  Future<bool> create() async {
    try {
      movimentoEntradaModel?.id_funcionario = getUsuario().uid;
      movimentoEntradaModel?.itemMovimentoEntradaModel = listaItens;
      return await movimentoEntradaRepository.create(movimentoEntradaModel);
    } catch (e) {
      var error = e.toString();
      throw error;
    }
  }

  Future<bool> createManual() async {
    try {
      movimentoEntradaModel?.id_funcionario = getUsuario().uid;
      movimentoEntradaModel?.itemMovimentoEntradaModel = listaItens;
      return await movimentoEntradaRepository
          .createManual(movimentoEntradaModel);
    } catch (e) {
      var error = e.toString();
      throw error;
    }
  }

  somarLista(List<ItemPedidoEntradaModel>? listaItensPedido) {
    listaItensPedido?.forEach((itemPedido) {
      //ip = listaItensSomados.firstWhere((itemSomado) => itemPedido.idItemPedidoEntrada == itemSomado.idItemPedidoEntrada, orElse: ()=>ItemPedidoEntradaModel());
      // int index = listaItensSomados.indexWhere((element) => itemPedido.peca?.id_peca == element.peca?.id_peca);
      // if (index == -1) {
      listaItensSomados.add(itemPedido);
      // } else {
      //   listaItensSomados[index].quantidade = listaItensSomados[index].quantidade! + itemPedido.quantidade!;
      // }
    });
  }

  subtrairLista(List<ItemPedidoEntradaModel>? listaItensPedido) {
    listaItensPedido?.forEach((itemPedido) {
      //ip = listaItensSomados.firstWhere((itemSomado) => itemPedido.idItemPedidoEntrada == itemSomado.idItemPedidoEntrada, orElse: ()=>ItemPedidoEntradaModel());
      int index = listaItensSomados.indexWhere(
          (element) => itemPedido.peca?.id_peca == element.peca?.id_peca);
      if (index != -1) {
        listaItensSomados[index].quantidade =
            listaItensSomados[index].quantidade! - itemPedido.quantidade!;
        if (listaItensSomados[index].quantidade == 0) {
          listaItensSomados.removeAt(index);
        }
      }
    });
  }

  bool manualItensEntradaToItensEntrada(List<ItemMovimentoEntradaModel> list) {
    listaItens = list;
    bool sucess = true;

    movimentoEntradaModel!.custo_total = 0;
    movimentoEntradaModel!.data_entrada = DateTime.now();

    listaItens.forEach((element) {
      if (element.quantidade == null || element.quantidade_pedido == null) {
        sucess = false;
      } else {
        element.id_peca = element.pecaModel!.id_peca;
        movimentoEntradaModel!.custo_total = (movimentoEntradaModel!
                .custo_total! +
            ((element.valor_unitario == null ? 0.0 : element.valor_unitario)! *
                element.quantidade!));
      }
    });

    return sucess;
  }

  bool ItensPedidoToItensEntrada() {
    bool sucess = true;
    movimentoEntradaModel!.custo_total = 0;
    movimentoEntradaModel!.data_entrada = DateTime.now();
    listaItensSomados.forEach((element) {
      if (element.quantidade_recebida == null) {
        sucess = false;
      } else {
        ItemMovimentoEntradaModel itemEntrada = ItemMovimentoEntradaModel(
          quantidade: element.quantidade_recebida,
          quantidade_pedido: element.quantidade,
          id_peca: element.peca!.id_peca,
          pecaModel: element.peca,
          valor_unitario: element.custo,
          id_pedido_entrada: element.id_pedido_entrada,
        );
        listaItens.add(itemEntrada);

        movimentoEntradaModel!.custo_total =
            (movimentoEntradaModel!.custo_total! +
                (element.custo! * element.quantidade_recebida!));
      }
    });
    return sucess;
  }
}
