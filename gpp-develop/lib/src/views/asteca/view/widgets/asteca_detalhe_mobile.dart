import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gpp/src/controllers/MotivoTrocaPecaController.dart';
import 'package:gpp/src/controllers/asteca_controller.dart';
import 'package:gpp/src/controllers/pecas_controller/produto_controller.dart';
import 'package:gpp/src/controllers/pedido_entrada_controller.dart';
import 'package:gpp/src/models/item_pedido_entrada_model.dart';
import 'package:gpp/src/models/cancelamentoModel.dart';
import 'package:gpp/src/models/item_pedido_saida_model.dart';
import 'package:gpp/src/models/PecaEstoqueModel.dart';
import 'package:gpp/src/models/asteca/asteca_model.dart';
import 'package:gpp/src/models/asteca/asteca_tipo_pendencia_model.dart';
import 'package:gpp/src/models/pecas_model/peca_model.dart';
import 'package:gpp/src/models/pecas_model/pecas_estoque_model.dart';
import 'package:gpp/src/models/pedido_entrada_model.dart';
import 'package:gpp/src/models/pedido_saida_model.dart';

import 'package:gpp/src/models/motivo_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/CheckboxComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TextComponentMenu.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/shared/utils/GerarPedidoEntradaPDF.dart';
import 'package:gpp/src/shared/utils/GerarPedidoSaidaPDF.dart';
import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:gpp/src/utils/notificacao.dart';

import 'package:gpp/src/views/asteca/controller/asteca_detalhe_controller.dart';

import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/evento_status_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:intl/intl.dart';

class AstecaDetalheMobile extends StatefulWidget {
  final int id;
  const AstecaDetalheMobile({Key? key, required this.id}) : super(key: key);

  @override
  State<AstecaDetalheMobile> createState() => _AstecaDetalheMobile();
}

class _AstecaDetalheMobile extends State<AstecaDetalheMobile> {
  late AstecaController astecaController;
  late ProdutoController produtoController;
  late PedidoEntradaController pedidoEntracaController;

  List<ItemProdutoPeca> itemsProdutoPeca = [];
  List<ItemProdutoPeca> itemsProdutoPecaBusca = [];
  int marcados = 0;
  bool abrirFiltro = false;
  late MotivoTrocaPecaController motivoTrocaPecaController;

  late MaskFormatter maskFormatter;
  late PecaEstoqueModel pecaEstoque;

  final List<TextEditingController> controllerQtd = [];
  final buscaPecaController = TextEditingController();

  AstecaDetalheController? astecaDetalheController;

  bool error = false;

  @override
  void initState() {
    super.initState();

    //Inicializa asteca controller
    astecaController = AstecaController();

    //Inicializa produto controller
    produtoController = new ProdutoController();

    //Pedido de entrada controller
    pedidoEntracaController = PedidoEntradaController();

    //Instância máscaras
    maskFormatter = MaskFormatter();

    //Instância motivo de troca de peca controller
    motivoTrocaPecaController = MotivoTrocaPecaController();

    //Busca a asteca, utilizando o id como parâmetro
    buscar();

    //Busca lista de pendências
    // buscarAstecaTipoPendencias();

    //Buscar motivos de troca de peças
    buscarMotivosTrocaPeca();

    astecaDetalheController = AstecaDetalheController();
  }

  buscar() async {
    setState(() {
      astecaController.carregadoAsteca = false;
    });
    astecaController.asteca =
        await astecaController.repository.buscarAsteca(widget.id);
    setState(() {
      astecaController.carregadoAsteca = true;
    });
  }

  // buscarAstecaTipoPendencias() async {
  //   setState(() {
  //     astecaController.carregadoTipoPendencia = false;
  //   });

  //   astecaController.astecaTipoPendencias = await astecaController.astecaTipoPendenciaRepository.buscarAstecaTipoPendencias();

  //   setState(() {
  //     astecaController.carregadoTipoPendencia = false;
  //   });
  // }

  buscarMotivosTrocaPeca() async {
    setState(() {
      astecaController.carregadoMotivoTrocaPeca = false;
    });

    motivoTrocaPecaController.motivos =
        await motivoTrocaPecaController.repository.buscarTodos();

    setState(() {
      astecaController.carregadoMotivoTrocaPeca = false;
    });
  }

  handlePendencia(
      AstecaModel asteca, AstecaTipoPendenciaModel pendencia) async {
    await astecaController.astecaTipoPendenciaRepository
        .inserirAstecaPendencia(asteca.idAsteca!, pendencia);
    //Atualiza asteca
    await buscar();
  }

  gerarProdutoPeca() {
    astecaDetalheController!.pecaEstoquesAsteca.forEach((element) {
      itemsProdutoPeca
          .add(ItemProdutoPeca(marcado: false, produtoPeca: element));
    });
    // Asteca anterior
    // produtoController.produto.produtoPecas!.forEach((element) {
    //   itemsProdutoPeca.add(ItemProdutoPeca(marcado: false, produtoPeca: element));
    // });
  }

  /**
   * Função utilizada para marcar todas as checkbox das pecas
   */
  marcarTodosCheckbox(bool value) {
    if (value) {
      marcados = itemsProdutoPeca.length;
    } else {
      marcados = 0;
    }
    for (var itemPeca in itemsProdutoPeca) {
      itemPeca.marcado = value;
    }
  }

  //Nova lógica
  marcarCheckbox(index, value) {
    if (value) {
      marcados++;
    } else {
      marcados--;
    }
    itemsProdutoPeca[index].marcado = value;
  }

  marcarCheckboxBusca(index, value) {
    if (value) {
      marcados++;
    } else {
      marcados--;
    }
    itemsProdutoPecaBusca[index].marcado = value;
  }

  /**
   * Adicionar pecas ao carrinho
   */

  adicionarPeca() {
    setState(() {
      for (var itemPeca in itemsProdutoPeca) {
        //Verifica se o item está marcado
        if (itemPeca.marcado) {
          //Verifica se já existe item com o mesmo id adicionado na lista
          int index = astecaController.pedidoSaida.itemsPedidoSaida!.indexWhere(
              (element) =>
                  element.pecaEstoque!.id_peca_estoque ==
                  itemPeca.produtoPeca.id_peca_estoque);
          //Se não existe item adiciona na lista
          if (index < 0) {
            astecaController.pedidoSaida.itemsPedidoSaida!.add(
              ItemPedidoSaidaModel(
                peca: itemPeca.produtoPeca.peca,
                valor: itemPeca.produtoPeca.peca!.custo!,
                quantidade: 1,
                saldo_disponivel: itemPeca.produtoPeca.saldo_disponivel,
                endereco: itemPeca.produtoPeca.endereco,
                pecaEstoque: itemPeca.produtoPeca,
              ),
            );
          } else {
            //Caso exista item na lista incrementa a quantidade;
            astecaController.pedidoSaida.itemsPedidoSaida![index].quantidade++;
            astecaController.pedidoSaida.itemsPedidoSaida![index].valor +=
                itemPeca.produtoPeca.peca!.custo!;
            controllerQtd[index].text = astecaController
                .pedidoSaida.itemsPedidoSaida![index].quantidade
                .toString();
            //  astecaController.pedidoSaida.itemsPedidoSaida![index].valor += 0;
          }
          //Soma o total
          calcularValorTotal();
        }
        itemPeca.marcado = false;
      }
      marcados = 0;
    });
  }

/**
   * Remover peça
   */
  removerPeca(index) {
    setState(() {
      astecaController.pedidoSaida.itemsPedidoSaida!.removeAt(index);
    });
    calcularValorTotal();
  }

  calcularValorTotal() {
    astecaController.pedidoSaida.valorTotal = 0.0;
    for (var item in astecaController.pedidoSaida.itemsPedidoSaida!) {
      astecaController.pedidoSaida.valorTotal =
          astecaController.pedidoSaida.valorTotal! +
              item.quantidade * item.valor;
    }
  }

  selecionarMotivoTrocaPeca(index, value) {
    setState(() {
      astecaController.pedidoSaida.itemsPedidoSaida![index].motivoTrocaPeca =
          value;
    });
  }

  void adicionarQuantidade(index) {
    setState(() {
      astecaController.pedidoSaida.itemsPedidoSaida![index].quantidade++;
    });
    controllerQtd[index].text = astecaController
        .pedidoSaida.itemsPedidoSaida![index].quantidade
        .toString();
    calcularValorTotal();
  }

  void removerQuantidade(index) async {
    if (astecaController.pedidoSaida.itemsPedidoSaida![index].quantidade > 1) {
      setState(() {
        astecaController.pedidoSaida.itemsPedidoSaida![index].quantidade--;
      });
      controllerQtd[index].text = astecaController
          .pedidoSaida.itemsPedidoSaida![index].quantidade
          .toString();
      calcularValorTotal();
    } else {
      if (await Notificacao.confirmacao(
          "Deseja realmente remover essa peça ?")) {
        removerPeca(index);
      }
    }
  }

  bool verificaEstoque() {
    bool verificaEstoque = true;
    if (!pedidoEntracaController.pedidoEntradaCriado) {
      for (var item in astecaController.pedidoSaida.itemsPedidoSaida!) {
        if (item.saldo_disponivel == null) {
          verificaEstoque = false;
          break;
        } else {
          if (item.quantidade > item.saldo_disponivel!) {
            verificaEstoque = false;
            break;
          }
        }
      }
    } else {
      for (var item in astecaController.pedidoSaida.itemsPedidoSaida!) {
        item.pendenciaItem = true;
      }
    }
    return verificaEstoque;
  }

  verificarSelecaoMotivoTrocaPeca() {
    bool verificaSelecaoMotivoTrocaPeca = true;
    for (var item in astecaController.pedidoSaida.itemsPedidoSaida!) {
      if (item.motivoTrocaPeca == null) {
        verificaSelecaoMotivoTrocaPeca = false;
        break;
      }
    }
    return verificaSelecaoMotivoTrocaPeca;
  }

  myShowDialog(String text) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(actions: <Widget>[
            Padding(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber, color: Colors.amber, size: 45.0),
                    SizedBox(
                      height: 15,
                    ),
                    Wrap(
                      children: [
                        TextComponent(
                          text,
                          fontSize: 20.0,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonComponent(
                            color: primaryColor,
                            colorHover: primaryColor,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            text: 'Ok'),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    )
                  ],
                ),
                padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0))
          ]);
        });
  }

  /**
   * Função destinada a finalizar o pedido
   */

  finalizarPedido() async {
    try {
      if (verificaEstoque()) {
        if (!verificarSelecaoMotivoTrocaPeca()) {
          myShowDialog('Selecione o motivo de troca da peça');
        }

        //Criar o pedido
        astecaController.pedidoSaida.cpfCnpj =
            astecaController.asteca.documentoFiscal!.cpfCnpj.toString();
        astecaController.pedidoSaida.filial_registro =
            astecaController.asteca.documentoFiscal!.idFilialVenda;
        astecaController.pedidoSaida.numDocFiscal =
            astecaController.asteca.documentoFiscal!.numDocFiscal;
        astecaController.pedidoSaida.serieDocFiscal =
            astecaController.asteca.documentoFiscal!.serieDocFiscal;

        astecaController.pedidoSaida.situacao = 1;
        astecaController.pedidoSaida.asteca = astecaController.asteca;
        astecaController.pedidoSaida.funcionario =
            astecaController.asteca.funcionario;
        astecaController.pedidoSaida.cliente =
            astecaController.asteca.documentoFiscal!.cliente;
        //Solicita o endpoint a criação do pedido

        PedidoSaidaModel pedidoComprovante = await astecaDetalheController!
            .finalizarPedidoSaida(astecaController
                .pedidoSaida); // astecaController.pedidoSaidaRepository.criar(astecaController.pedidoSaida);
        exibirComprovantePedidoSaida(pedidoComprovante);
      } else {
        exibirDialogPedidoEntrada();
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    }
  }

  exibirComprovantePedidoSaida(pedidoConfirmacao) {
    //Notificação

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(actions: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextComponent(
                        'Nº Ordem de Saída',
                        fontSize: 24,
                      ),
                    ),
                    TextComponent(
                      '#${pedidoConfirmacao.idPedidoSaida}',
                      fontWeight: FontWeight.normal,
                      fontSize: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: TextComponent(
                        'Nome do Cliente:',
                      ),
                    ),
                    Wrap(
                      children: [
                        TextComponent(
                          '${pedidoConfirmacao.cliente!.nome}',
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.normal,
                        )
                      ],
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 4.0),
                    //   child: TextComponent('Filial venda: ${pedidoConfirmacao.filialVenda}'),
                    // )
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ButtonComponent(
                          color: primaryColor,
                          colorHover: primaryColorHover,
                          onPressed: () {
                            Get.toNamed('/ordens-saida');
                            Get.deleteAll();
                          },
                          text: 'Ok'),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: ButtonComponent(
                          color: secundaryColor,
                          colorHover: secundaryColorHover,
                          icon: Icon(
                            Icons.print,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            GerarPedidoSaidaPDF(pedido: pedidoConfirmacao)
                                .imprimirPDF();
                          },
                          text: 'Imprimir'),
                    ),
                    // Obx(
                    //   () => !astecaDetalheController!.carregandoEmail.value
                    //       ? ButtonComponent(
                    //           color: secundaryColor,
                    //           colorHover: secundaryColorHover,
                    //           icon: Icon(
                    //             Icons.email,
                    //             color: Colors.white,
                    //           ),
                    //           onPressed: () async {
                    //             await enviarEmailPedidoSaida(pedidoConfirmacao);
                    //           },
                    //           text: 'Enviar e-mail')
                    //       : LoadingComponent(),
                    // )
                  ],
                ),
              ],
            )
          ]);
        });
  }

  exibirComprovanteCancelamentoPedidos(int tipoDialog) {
    //Notificação
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Center(
                  child: TitleComponent('Cancelamento realizado com sucesso!')),
              insetPadding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              actions: <Widget>[
                Container(
                  width: Get.width / 3,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            tipoDialog == 1
                                ? TextComponent(
                                    'O pedido de saída vinculado a Asteca ${astecaController.asteca.idAsteca!} foi cancelado!',
                                    fontSize: 18,
                                  )
                                : TextComponent(
                                    'O pedido de saída e entrada vinculado a Asteca ${astecaController.asteca.idAsteca!} foram cancelados!',
                                    fontSize: 18,
                                  ),
                            SizedBox(
                              height: 8,
                            ),
                            tipoDialog != 1
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: TextComponent(
                                      'Aviso: O pedido de entrada foi cancelado, certifique-se se será necessário enviar e-mail informando o fornecedor!',
                                      color: vermelhoColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 100,
                              child: ButtonComponent(
                                  color: primaryColor,
                                  colorHover: primaryColorHover,
                                  onPressed: () {
                                    Get.offAllNamed(
                                        '/astecas/${astecaController.asteca.idAsteca!}');
                                  },
                                  text: 'Ok'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  exibirComprovantePedidoEntrada(PedidoEntradaModel pedidoConfirmacao) {
    //Notificação
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(actions: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextComponent(
                        'Nº Ordem de Entrada',
                        fontSize: 24,
                      ),
                    ),
                    TextComponent(
                      '#${pedidoConfirmacao.idPedidoEntrada}',
                      fontWeight: FontWeight.normal,
                      fontSize: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: TextComponent('Nome do fornecedor'),
                    ),
                    Wrap(
                      children: [
                        TextComponent(
                          '${pedidoConfirmacao.asteca!.compEstProd!.first.produto!.fornecedores!.first.cliente!.nome}',
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.normal,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ButtonComponent(
                              color: primaryColor,
                              colorHover: primaryColorHover,
                              onPressed: () async {
                                Navigator.pop(context);
                                error ? error = false : await finalizarPedido();
                              },
                              text: 'Ok'),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: ButtonComponent(
                              color: secundaryColor,
                              colorHover: secundaryColorHover,
                              icon: Icon(
                                Icons.print,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                GerarPedidoEntradaPDF(
                                        pedidoEntrada: pedidoConfirmacao)
                                    .imprimirPDF();
                              },
                              text: 'Imprimir'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Obx(
                      () => !astecaDetalheController!.carregandoEmail.value
                          ? ButtonComponent(
                              color: secundaryColor,
                              colorHover: secundaryColorHover,
                              icon: Icon(
                                Icons.email,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                await enviarEmailPedidoEntrada(
                                    pedidoConfirmacao);
                              },
                              text: 'Enviar e-mail')
                          : LoadingComponent(),
                    )
                  ],
                ),
              ],
            )
          ]);
        });
  }

  enviarEmailPedidoSaida(PedidoSaidaModel pedidoConfirmacao) async {
    astecaDetalheController!.carregandoEmail(true);
    try {
      if (await astecaController.pedidoSaidaRepository.enviarEmailFornecedor(
          pedidoConfirmacao.idPedidoSaida!, pedidoConfirmacao)) {
        myShowDialog('E-mail enviado com sucesso');
        await Future.delayed(Duration(seconds: 3));
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      astecaDetalheController!.carregandoEmail(false);
    }
  }

  enviarEmailPedidoEntrada(PedidoEntradaModel pedidoConfirmacao) async {
    astecaDetalheController!.carregandoEmail(true);
    try {
      if (await astecaController.pedidoEntradaRepository.enviarEmailFornecedor(
          pedidoConfirmacao.idPedidoEntrada!, pedidoConfirmacao)) {
        myShowDialog('E-mail enviado com sucesso');
        //await Future.delayed(Duration(seconds: 3));
      }
    } catch (e) {
      Notificacao.snackBar(e.toString());
    } finally {
      astecaDetalheController!.carregandoEmail(false);
    }
  }

  exibirDialogPedidoEntrada() {
    // set up the buttons
    Widget cancelarButton = TextButton(
      child: Text("Não"),
      onPressed: () {
        Get.back();
      },
    );
    Widget confirmarButton = TextButton(
      child: Text("Sim"),
      onPressed: () {
        Get.back();
        criarPedidoEntrada();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Aviso"),
      content: Text(
          "Existem peças adicionadas que não possuem estoque disponível. Gostaria de criar um pedido de entrada?"),
      actions: [
        cancelarButton,
        confirmarButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  List<ItemPedidoEntradaModel> criarItensPedidoEntrada() {
    List<ItemPedidoEntradaModel> itensPedidoEntrada = [];

    astecaController.pedidoSaida.itemsPedidoSaida!.forEach((e) {
      itensPedidoEntrada.add(ItemPedidoEntradaModel(
          quantidade: e.quantidade, custo: e.valor, peca: e.peca));
    });

    return itensPedidoEntrada;
  }

  criarPedidoEntrada() async {
    if (!verificarSelecaoMotivoTrocaPeca()) {
      myShowDialog('Selecione o motivo de troca da peça');
    } else {
      //Criar o pedido de entrada
      PedidoEntradaModel pedidoEntrada = new PedidoEntradaModel(
          situacao: 1, //Em aberto,
          valorTotal: astecaController.pedidoSaida.valorTotal,
          //dataEmissao: DateTime.now(),
          funcionario: astecaController.pedidoSaida.funcionario,
          asteca: astecaController.asteca,
          itensPedidoEntrada: criarItensPedidoEntrada());
      //Solicita a criação do pedido de entrada
      try {
        PedidoEntradaModel pedidoConfirmacao = await astecaDetalheController!
            .finalizarPedidoEntrada(
                pedidoEntrada); //pedidoEntracaController.repository.criar(pedidoEntrada);
        pedidoEntracaController.pedidoEntradaCriado = true;

        if (pedidoConfirmacao.idPedidoEntrada == null) {
          await finalizarPedido();
        } else {
          await exibirComprovantePedidoEntrada(pedidoConfirmacao);
        }
      } catch (e) {
        pedidoEntracaController.pedidoEntradaCriado = false;
        error = true;
      }
    }
  }

  pesquisarPecas(value) {
    itemsProdutoPecaBusca = itemsProdutoPeca
        .where((element) =>
            element.produtoPeca.peca!.descricao!
                .toLowerCase()
                .contains(value.toString().toLowerCase()) ||
            element.produtoPeca.peca!.id_peca.toString().contains(value))
        .toList();
  }

  pesquisarPendencia(value) {
    setState(() {
      astecaController.astecaTipoPendenciasBuscar = astecaController
          .astecaTipoPendencias
          .where((element) =>
              element.descricao!
                  .toLowerCase()
                  .contains(value.toString().toLowerCase()) ||
              element.idTipoPendencia.toString().contains(value))
          .toList();
    });
  }

  // buscarProdutoPecas() async {
  //   setState(() {
  //     astecaController.carregaProdutoPeca = false;
  //   });
  //   produtoController.produto.produtoPecas = await produtoController.produtoRepository
  //       .buscarProdutoPecas(astecaController.asteca.compEstProd!.first.produto!.idProduto!);

  //   setState(() {
  //     astecaController.carregaProdutoPeca = true;
  //   });
  //   //gerarItemPeca
  //   gerarProdutoPeca();
  // }

  estoqueTotal(PecasModel peca) {
    int qtdTotal = 0;
    peca.estoque!.forEach((element) {
      qtdTotal += element.saldoDisponivel;
    });
    return qtdTotal.toString();
  }

  inserirQuantidade(index, value) async {
    int quantidade = int.parse(value);

    if (quantidade == 0) {
      if (await Notificacao.confirmacao(
          "Deseja realmente remover essa peça ?")) {
        removerPeca(index);
      }
    } else if (quantidade > 0) {
      astecaController.pedidoSaida.itemsPedidoSaida![index].quantidade =
          quantidade;

      calcularValorTotal();
    }
  }

  Color _buildSituacaoEstoque(index) {
    if (astecaController
            .pedidoSaida.itemsPedidoSaida![index].saldo_disponivel ==
        null) {
      return Colors.red.shade100;
    } else {
      if (astecaController
              .pedidoSaida.itemsPedidoSaida![index].saldo_disponivel! <
          astecaController.pedidoSaida.itemsPedidoSaida![index].quantidade) {
        return Colors.red.shade100;
      } else {
        return Colors.white;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
        ),
        color: Colors.white,
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  TextComponent(
                    'Asteca',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: secundaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: !astecaController.carregadoAsteca
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : astecaController.asteca.astecaPendencias != null
                              ? TextComponent(
                                  (astecaController
                                              .asteca
                                              .astecaPendencias
                                              ?.last
                                              .astecaTipoPendencia
                                              ?.idTipoPendencia
                                              .toString() ??
                                          '') +
                                      ' - ' +
                                      (astecaController
                                              .asteca
                                              .astecaPendencias
                                              ?.last
                                              .astecaTipoPendencia
                                              ?.descricao
                                              .toString() ??
                                          ''),
                                  color: Colors.white,
                                )
                              : TextComponent(
                                  'Aguardando Pendência',
                                  color: Colors.white,
                                ),
                    ),
                  ),
                ],
              ),
            ),
            _astecaMenu(),
            Padding(padding: EdgeInsets.only(bottom: 8)),
            _astecaNavegacao(),
            _astecaBotoes(astecaController.step),
          ],
        ),
      ),
    );
  }

  _astecaMenu() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  astecaController.step = 1;
                  astecaController.abrirDropDownButton = false;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: astecaController.step == 1 ? 4 : 1,
                      color: astecaController.step == 1
                          ? secundaryColor
                          : Colors.grey.shade200,
                    ),
                  ),
                ),
                child: TextComponentMenu('Informações'),
              ),
            ),
          ],
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  astecaController.step = 2;
                  astecaController.abrirDropDownButton = false;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: astecaController.step == 2 ? 4 : 1,
                      color: astecaController.step == 2
                          ? secundaryColor
                          : Colors.grey.shade200,
                    ),
                  ),
                ),
                child: TextComponentMenu('Peças'),
              ),
            ),
          ],
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  astecaController.step = 3;
                  astecaController.abrirDropDownButton = false;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: astecaController.step == 3 ? 4 : 1,
                      color: astecaController.step == 3
                          ? secundaryColor
                          : Colors.grey.shade200,
                    ),
                  ),
                ),
                child: TextComponentMenu('Pendências'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _astecaNavegacao() {
    switch (astecaController.step) {
      case 1:
        return _astecaInformacoes();
      case 2:
        return _astecaPecas();
      case 3:
        return astecaHistoricoPendencia();
    }
  }

  _astecaBotoes(int step) {
    return Column(
      children: [
        step == 2
            ? Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ButtonComponent(
                            color: vermelhoColor,
                            colorHover: vermelhoColorHover,
                            onPressed: () {
                              Get.offAllNamed(Get.previousRoute);
                            },
                            text: 'Fechar',
                          ),
                        ),
                        astecaController.asteca.pedidoSaida == null
                            ? SizedBox(
                                width: 6,
                              )
                            : Container(),
                        astecaController.asteca.pedidoSaida == null
                            ? Obx(
                                () => !astecaDetalheController!
                                        .carregandoFinalizacao.value
                                    ? Expanded(
                                        child: ButtonComponent(
                                          color: primaryColor,
                                          colorHover: primaryColorHover,
                                          onPressed: () async {
                                            if (astecaController.pedidoSaida
                                                    .itemsPedidoSaida!.length <=
                                                0) {
                                              Notificacao.snackBar(
                                                  "Adicione peças antes de finalizar o pedido");
                                            } else {
                                              await finalizarPedido();
                                            }
                                          },
                                          text: 'Finalizar pedido',
                                        ),
                                      )
                                    : LoadingComponent(),
                              )
                            : Container(),
                      ],
                    ),
                    astecaController.asteca.pedidoSaida != null
                        ? Obx(
                            () => !astecaDetalheController!.cancelando.value
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 6,
                                      ),
                                      ButtonComponent(
                                          color: vermelhoColor,
                                          colorHover: vermelhoColorHover,
                                          onPressed: () async {
                                            CancelamentoModel retorno =
                                                await astecaDetalheController!
                                                    .cancelarPedidosAsteca(
                                                        astecaController
                                                            .asteca.idAsteca!);

                                            exibirComprovanteCancelamentoPedidos(
                                                retorno.info!);
                                          },
                                          text: 'Cancelar pedido'),
                                    ],
                                  )
                                : LoadingComponent(),
                          )
                        : Container(),
                    astecaController.asteca.pedidoSaida != null
                        ? Column(
                            children: [
                              SizedBox(
                                height: 6,
                              ),
                              ButtonComponent(
                                color: primaryColor,
                                colorHover: primaryColorHover,
                                onPressed: () {
                                  Get.toNamed(
                                      "/ordens-saida/${astecaController.asteca.pedidoSaida!.idPedidoSaida}");
                                },
                                text: 'Visualizar ordem de saída',
                              ),
                            ],
                          )
                        : Container(),
                    astecaController.asteca.pedidoEntrada != null
                        ? Column(
                            children: [
                              SizedBox(
                                height: 6,
                              ),
                              ButtonComponent(
                                color: primaryColor,
                                colorHover: primaryColorHover,
                                onPressed: () {
                                  Get.toNamed(
                                      "/ordens-entrada/${astecaController.asteca.pedidoEntrada!.idPedidoEntrada}");
                                },
                                text: 'Visualizar ordem de entrada',
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    astecaController.asteca.pedidoSaida != null
                        ? Container()
                        : Expanded(
                            child: ButtonComponent(
                              color: vermelhoColor,
                              colorHover: vermelhoColorHover,
                              onPressed: () {
                                Get.offAllNamed(Get.previousRoute);
                              },
                              text: 'Fechar',
                            ),
                          ),
                    SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child:
                          Obx(() => !astecaDetalheController!.carregando.value
                              ? ButtonComponent(
                                  color: primaryColor,
                                  colorHover: primaryColorHover,
                                  onPressed: () {
                                    exibirPecas(context);
                                  },
                                  text: 'Adicionar peças',
                                )
                              : LoadingComponent()),
                    ),
                  ],
                ),
              )
      ],
    );
  }

  _astecaInformacoes() {
    return Expanded(
      child: SingleChildScrollView(
        controller: new ScrollController(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 32),
              child: Row(
                children: [
                  Icon(
                    Icons.description,
                    size: 32,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  TitleComponent('Informações'),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InputComponent(
                    readOnly: true,
                    key: UniqueKey(),
                    label: 'Nº Asteca',
                    initialValue: astecaController.asteca.idAsteca.toString(),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: InputComponent(
                    readOnly: true,
                    key: UniqueKey(),
                    label: 'CPF/CNPJ',
                    initialValue:
                        astecaController.asteca.documentoFiscal?.cpfCnpj == null
                            ? ''
                            : maskFormatter
                                .cpfCnpjFormatter(
                                    value: astecaController
                                        .asteca.documentoFiscal!.cpfCnpj
                                        .toString())!
                                .getMaskedText(),
                  ),
                ),
              ],
            ),
            InputComponent(
              readOnly: true,
              key: UniqueKey(),
              label: 'Nome',
              initialValue: astecaController.camelCaseAll(
                  astecaController.asteca.documentoFiscal?.nome ?? ''),
            ),
            Row(
              children: [
                Expanded(
                  child: InputComponent(
                    readOnly: true,
                    key: UniqueKey(),
                    label: 'Nº Fiscal',
                    initialValue: astecaController
                            .asteca.documentoFiscal?.numDocFiscal
                            .toString() ??
                        '',
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: InputComponent(
                    readOnly: true,
                    key: UniqueKey(),
                    label: 'Série',
                    initialValue: astecaController
                            .asteca.documentoFiscal?.serieDocFiscal
                            .toString() ??
                        '',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InputComponent(
                    readOnly: true,
                    key: UniqueKey(),
                    label: 'Filial de saída',
                    initialValue: astecaController
                            .asteca.documentoFiscal?.idFilialSaida
                            .toString() ??
                        '',
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: InputComponent(
                    readOnly: true,
                    key: UniqueKey(),
                    label: 'Filial venda',
                    initialValue: astecaController
                            .asteca.documentoFiscal?.idFilialVenda
                            .toString() ??
                        '',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InputComponent(
                    readOnly: true,
                    key: UniqueKey(),
                    label: 'Data de abertura',
                    initialValue: astecaController.asteca.dataEmissao == null
                        ? ''
                        : DateFormat('dd/MM/yyyy')
                            .format(astecaController.asteca.dataEmissao!),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: InputComponent(
                    readOnly: true,
                    key: UniqueKey(),
                    label: 'Data de compra',
                    initialValue:
                        astecaController.asteca.documentoFiscal?.dataEmissao ==
                                null
                            ? ''
                            : DateFormat('dd/MM/yyyy').format(astecaController
                                .asteca.documentoFiscal!.dataEmissao!),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InputComponent(
                    readOnly: true,
                    key: UniqueKey(),
                    label: 'Tipo',
                    initialValue: 'Cliente',
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: InputComponent(
                    readOnly: true,
                    key: UniqueKey(),
                    label: 'Filial Asteca',
                    initialValue:
                        astecaController.asteca.idFilialRegistro?.toString() ??
                            '',
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 32),
              child: Row(
                children: [
                  Icon(
                    Icons.badge,
                    size: 32,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  TitleComponent('Funcionário (a)'),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InputComponent(
                    readOnly: true,
                    key: UniqueKey(),
                    label: 'RE',
                    initialValue: astecaController
                            .asteca.funcionario?.idFuncionario
                            .toString() ??
                        '',
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  flex: 2,
                  child: InputComponent(
                    readOnly: true,
                    key: UniqueKey(),
                    label: 'Nome',
                    initialValue: astecaController.camelCaseAll(astecaController
                            .asteca.funcionario?.clienteFunc?.cliente?.nome ??
                        ''),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 32),
              child: Row(
                children: [
                  Icon(
                    Icons.build,
                    size: 32,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  TitleComponent('Defeito ou motivo'),
                ],
              ),
            ),
            ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: InputComponent(
                readOnly: true,
                key: UniqueKey(),
                maxLines: 5,
                label: 'Defeito',
                initialValue: astecaController.camelCaseFirst(
                    astecaController.asteca.defeitoEstadoProd ?? ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 32,
                bottom: 16,
              ),
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: InputComponent(
                  readOnly: true,
                  key: UniqueKey(),
                  maxLines: 5,
                  label: 'Observação',
                  initialValue: astecaController
                      .camelCaseFirst(astecaController.asteca.observacao ?? ''),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 32),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 32,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  TitleComponent('Endereço'),
                ],
              ),
            ),
            InputComponent(
              readOnly: true,
              key: UniqueKey(),
              label: 'Logradouro',
              initialValue: astecaController.camelCaseFirst(
                  astecaController.asteca.astecaEndCliente?.logradouro ?? ''),
            ),
            InputComponent(
              readOnly: true,
              key: UniqueKey(),
              label: 'Complemento',
              initialValue: astecaController.camelCaseFirst(
                  astecaController.asteca.astecaEndCliente?.complemento ?? ''),
            ),
            Row(
              children: [
                Expanded(
                  child: InputComponent(
                    readOnly: true,
                    key: UniqueKey(),
                    label: 'Número',
                    initialValue: astecaController
                            .asteca.astecaEndCliente?.numero
                            .toString() ??
                        '',
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  flex: 2,
                  child: InputComponent(
                    readOnly: true,
                    key: UniqueKey(),
                    label: 'Bairro',
                    initialValue: astecaController.camelCaseAll(
                        astecaController.asteca.astecaEndCliente?.bairro ?? ''),
                  ),
                ),
              ],
            ),
            InputComponent(
              readOnly: true,
              key: UniqueKey(),
              label: 'CEP',
              initialValue:
                  astecaController.asteca.astecaEndCliente?.cep == null
                      ? ''
                      : maskFormatter
                          .cepInputFormmater(astecaController
                              .asteca.astecaEndCliente?.cep
                              .toString())
                          .getMaskedText(),
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: InputComponent(
                    readOnly: true,
                    key: UniqueKey(),
                    label: 'Cidade',
                    initialValue: astecaController.camelCaseAll(astecaController
                                .asteca.astecaEndCliente?.localidade ==
                            null
                        ? ''
                        : astecaController.asteca.astecaEndCliente?.localidade
                            .toString()),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: InputComponent(
                    readOnly: true,
                    key: UniqueKey(),
                    label: 'Estado',
                    initialValue:
                        astecaController.asteca.astecaEndCliente?.uf == null
                            ? ''
                            : astecaController.asteca.astecaEndCliente?.uf
                                .toString(),
                  ),
                ),
              ],
            ),
            InputComponent(
              readOnly: true,
              key: UniqueKey(),
              label: 'Referência',
              initialValue: astecaController.camelCaseFirst(
                  astecaController.asteca.astecaEndCliente?.pontoReferencia1 ??
                      ''),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 32),
              child: Row(
                children: [
                  Icon(
                    Icons.call,
                    size: 32,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  TitleComponent('Telefone para contato'),
                ],
              ),
            ),
            InputComponent(
              readOnly: true,
              key: UniqueKey(),
              label: 'Telefone',
              initialValue: astecaController.asteca.astecaEndCliente?.ddd ==
                          null ||
                      astecaController.asteca.astecaEndCliente?.telefone == null
                  ? ''
                  : maskFormatter
                      .telefoneInputFormmater(
                          '${astecaController.asteca.astecaEndCliente?.ddd.toString()} ${astecaController.asteca.astecaEndCliente?.telefone.toString()}')
                      .getMaskedText(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 32),
              child: Row(
                children: [
                  Icon(
                    Icons.shopping_bag,
                    size: 32,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  TitleComponent('Produto'),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InputComponent(
                    readOnly: true,
                    key: UniqueKey(),
                    label: 'ID',
                    initialValue: astecaController
                            .asteca.compEstProd?.first.produto?.idProduto
                            .toString() ??
                        '',
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: InputComponent(
                    readOnly: true,
                    key: UniqueKey(),
                    label: 'LD',
                    initialValue: astecaController
                            .asteca.documentoFiscal?.itemDocFiscal?.idLd
                            .toString() ??
                        '',
                  ),
                ),
              ],
            ),
            InputComponent(
              readOnly: true,
              key: UniqueKey(),
              label: 'Nome',
              initialValue: astecaController.camelCaseFirst(astecaController
                      .asteca.compEstProd?.first.produto?.resumida ??
                  ''),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 32),
              child: Row(
                children: [
                  Icon(
                    Icons.local_shipping,
                    size: 32,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  TitleComponent('Fornecedor'),
                ],
              ),
            ),
            InputComponent(
              readOnly: true,
              key: UniqueKey(),
              label: 'ID',
              initialValue: astecaController.asteca.compEstProd?.first.produto
                      ?.fornecedores?.first.idFornecedor
                      .toString() ??
                  '',
            ),
            InputComponent(
              readOnly: true,
              key: UniqueKey(),
              label: 'Nome',
              initialValue: astecaController.camelCaseAll(astecaController
                      .asteca
                      .compEstProd
                      ?.first
                      .produto
                      ?.fornecedores
                      ?.first
                      .cliente
                      ?.nome ??
                  ''),
            ),
          ],
        ),
      ),
    );
  }

  _astecaPecas() {
    return Expanded(
      child: SingleChildScrollView(
        controller: new ScrollController(),
        child: Container(
          padding: const EdgeInsets.only(top: 16),
          child: !astecaController.carregadoAsteca
              ? LoadingComponent()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          InputComponent(
                            label: 'ID do produto',
                            readOnly: true,
                            initialValue: astecaController.asteca.compEstProd
                                    ?.first.produto?.idProduto
                                    .toString() ??
                                '',
                          ),
                          InputComponent(
                            label: 'Produto',
                            readOnly: true,
                            initialValue: astecaController
                                    .asteca.compEstProd?.first.produto?.resumida
                                    .toString() ??
                                '',
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.handyman_rounded,
                                size: 32,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              const TitleComponent('Peças para atendimento'),
                            ],
                          ),
                          astecaController.asteca.pedidoSaida != null
                              ? Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  child: EventoStatusWidget(
                                      color: Colors.pink,
                                      texto: 'Atendimento finalizado'),
                                )
                              : astecaController.carregadoAsteca
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 16),
                                      child: Obx(
                                        () => !astecaDetalheController!
                                                .carregando.value
                                            ? ButtonComponent(
                                                color: primaryColor,
                                                colorHover: primaryColorHover,
                                                onPressed: () {
                                                  exibirPecas(context);
                                                },
                                                text: 'Adicionar peças',
                                              )
                                            : LoadingComponent(),
                                      ),
                                    )
                                  : LoadingComponent()
                        ],
                      ),
                    ),
                    astecaController.asteca.pedidoSaida != null
                        ? Container()
                        : Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: astecaController
                                      .pedidoSaida.itemsPedidoSaida?.length ??
                                  1,
                              itemBuilder: (context, index) {
                                controllerQtd.add(new TextEditingController(
                                    text: 1.toString()));

                                return Card(
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _buildSituacaoEstoque(index),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextComponent(
                                                'ID',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              child: SelectableText(
                                                  astecaController
                                                          .pedidoSaida
                                                          .itemsPedidoSaida?[
                                                              index]
                                                          .peca
                                                          ?.id_peca
                                                          .toString() ??
                                                      ''),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextComponent(
                                                'Nome',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              child: SelectableText(
                                                astecaController.camelCaseFirst(
                                                    astecaController
                                                            .pedidoSaida
                                                            .itemsPedidoSaida?[
                                                                index]
                                                            .peca
                                                            ?.descricao ??
                                                        ''),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextComponent(
                                                'Nº Peças',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              child: SelectableText(
                                                astecaController.camelCaseFirst(
                                                    astecaController
                                                            .pedidoSaida
                                                            .itemsPedidoSaida?[
                                                                index]
                                                            .peca
                                                            ?.numero ??
                                                        ''),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextComponent(
                                                'Valor R\$',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              child: SelectableText(
                                                astecaController.formatter
                                                    .format(astecaController
                                                            .pedidoSaida
                                                            .itemsPedidoSaida?[
                                                                index]
                                                            .valor ??
                                                        ''),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextComponent(
                                                'Subtotal R\$',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              child: SelectableText(
                                                'R\$: ' +
                                                    astecaController.formatter
                                                        .format(
                                                      ((astecaController
                                                                  .pedidoSaida
                                                                  .itemsPedidoSaida?[
                                                                      index]
                                                                  .quantidade ??
                                                              0) *
                                                          (astecaController
                                                                  .pedidoSaida
                                                                  .itemsPedidoSaida?[
                                                                      index]
                                                                  .valor ??
                                                              0)),
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextComponent(
                                                'Endereço',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              child: SelectableText(
                                                  astecaController
                                                          .pedidoSaida
                                                          .itemsPedidoSaida?[
                                                              index]
                                                          .endereco ??
                                                      'Sem endereçamento'),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextComponent(
                                                'Saldo',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              child: SelectableText(
                                                  astecaController
                                                          .pedidoSaida
                                                          .itemsPedidoSaida?[
                                                              index]
                                                          .saldo_disponivel
                                                          .toString() ??
                                                      '-'),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        TextComponent(
                                          'Quantidade',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              color: Colors.red,
                                              onPressed: () {
                                                removerQuantidade(index);
                                              },
                                              icon: const Icon(
                                                Icons.remove_circle_outlined,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: InputComponent(
                                                key: UniqueKey(),
                                                maxLines: 1,
                                                controller:
                                                    controllerQtd[index],
                                                inputFormatter: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                onChanged: (value) {
                                                  inserirQuantidade(
                                                      index, value);
                                                },
                                                onFieldSubmitted: (value) {
                                                  setState(() {
                                                    inserirQuantidade(
                                                        index, value);
                                                  });
                                                },
                                              ),
                                            ),
                                            IconButton(
                                              color: Colors.green,
                                              onPressed: () {
                                                adicionarQuantidade(index);
                                              },
                                              icon: const Icon(
                                                Icons.add_circle_outlined,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        TextComponent(
                                          'Motivo',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child:
                                                  DropdownSearch<MotivoModel>(
                                                mode: Mode.MENU,
                                                showSearchBox: true,
                                                items: motivoTrocaPecaController
                                                    .motivos
                                                    .where((motivo) =>
                                                        motivo.situacao == true)
                                                    .toList(),
                                                itemAsString: (value) =>
                                                    value!.nome.toString(),
                                                onChanged: (value) async {
                                                  selecionarMotivoTrocaPeca(
                                                      index, value);
                                                },
                                                searchFieldProps:
                                                    TextFieldProps(
                                                  decoration: InputDecoration(
                                                    fillColor:
                                                        Colors.grey.shade100,
                                                    filled: true,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            top: 5,
                                                            bottom: 5,
                                                            left: 10),
                                                    border: InputBorder.none,
                                                    labelText:
                                                        'Pesquisar por nome',
                                                    labelStyle: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                                selectedItem: astecaController
                                                    .pedidoSaida
                                                    .itemsPedidoSaida![index]
                                                    .motivoTrocaPeca,
                                                dropdownSearchDecoration:
                                                    InputDecoration(
                                                  hintText:
                                                      'Selecione o Motivo',
                                                  hintStyle: TextStyle(
                                                      color: Colors.black),
                                                  fillColor: Colors
                                                      .pinkAccent, // Cor fundo caixa dropdown
                                                  isDense: true,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0),
                                                  ),
                                                ),
                                                emptyBuilder: (context, value) {
                                                  return Center(
                                                      child: TextComponent(
                                                    'Nenhum motivo encontrado',
                                                    textAlign: TextAlign.center,
                                                    color: Colors.grey.shade400,
                                                  ));
                                                },
                                                dropDownButton: const Icon(
                                                  Icons.expand_more_rounded,
                                                  color: Colors.grey,
                                                ),
                                                popupBackgroundColor: Colors
                                                    .white, // Cor de fundo para caixa de seleção
                                                showAsSuffixIcons: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    removerPeca(index);
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.redAccent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10),
                                                      child: Icon(
                                                        Icons.delete_rounded,
                                                        color: Colors.white,
                                                        size: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                            ),
                          ),
                    astecaController.asteca.pedidoSaida != null
                        ? SizedBox(
                            height: 12,
                          )
                        : Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextComponent(
                                  'Total: ${astecaController.pedidoSaida.itemsPedidoSaida != null ? astecaController.pedidoSaida.itemsPedidoSaida!.length : 0} peças selecionadas',
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                TextComponent(
                                  'Valor total R\$: ' +
                                      astecaController.formatter.format(
                                          astecaController
                                              .pedidoSaida.valorTotal),
                                ),
                              ],
                            ),
                          )
                  ],
                ),
        ),
      ),
    );
  }

  astecaHistoricoPendencia() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              astecaController.carregadoAsteca
                  ? Container(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            astecaController.asteca.astecaPendencias?.length ??
                                1,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: (index % 2) == 0
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey.shade100),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        TextComponent(
                                          '${index + 1}º Pendência:  ${astecaController.asteca.astecaPendencias?[index].astecaTipoPendencia?.idTipoPendencia ?? ''} - ${astecaController.asteca.astecaPendencias?[index].astecaTipoPendencia?.descricao ?? ''}',
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : LoadingComponent()
            ],
          ),
        ),
      ),
    );
  }

  exibirPecas(context) async {
    try {
      // Asteca anterior
      // await buscarProdutoPecas();

      //Carrega peças
      setState(() {
        astecaController.carregaProdutoPeca = false;
      });
      astecaDetalheController!.idProduto = astecaController
          .asteca.compEstProd!.first.produto!.idProduto!
          .toString();
      await astecaDetalheController!.buscarPecaEstoquesAsteca();
      gerarProdutoPeca();
      setState(() {
        astecaController.carregaProdutoPeca = true;
      });

      MediaQueryData media = MediaQuery.of(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                insetPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                titlePadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                title: Row(
                  children: [
                    const Icon(
                      Icons.settings,
                      size: 32,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const TitleComponent('Peças'),
                  ],
                ),
                content: SingleChildScrollView(
                  controller: new ScrollController(),
                  child: Container(
                    width: media.size.width * 0.90,
                    height: media.size.height * 0.90,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Wrap(
                            children: [
                              TextComponent(
                                'Selecione uma ou mais peças para realizar a manutenção do produto',
                                letterSpacing: 0.15,
                                fontSize: 16,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                          ),
                          child: Column(
                            children: [
                              InputComponent(
                                controller: buscaPecaController,
                                onChanged: (value) {
                                  setState(() {
                                    pesquisarPecas(value);
                                  });
                                },
                                maxLines: 1,
                                prefixIcon: const Icon(
                                  Icons.search,
                                ),
                                hintText: 'Buscar',
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              ButtonComponent(
                                color: secundaryColor,
                                colorHover: secundaryColorHover,
                                icon: Icon(Icons.search, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    pesquisarPecas(buscaPecaController.text);
                                  });
                                },
                                text: 'Pesquisar',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        CheckboxListTile(
                          title: TextComponent(
                            'Selecionar todas',
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: primaryColor,
                          checkColor: Colors.white,
                          value: marcados ==
                              astecaDetalheController!
                                  .pecaEstoquesAsteca.length,
                          onChanged: (bool? value) {
                            if (value != null) {
                              setState(() {
                                marcarTodosCheckbox(value);
                              });
                            }
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          height: Get.height * 0.35,
                          child: astecaController.asteca.pedidoSaida == null
                              ? ListView.builder(
                                  itemCount: astecaDetalheController
                                          ?.pecaEstoquesAsteca.length ??
                                      1,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          bool valorAntigo =
                                              itemsProdutoPeca[index].marcado;

                                          if (valorAntigo) {
                                            setState(() {
                                              itemsProdutoPeca[index].marcado =
                                                  false;
                                              marcados--;
                                            });
                                          } else {
                                            setState(() {
                                              itemsProdutoPeca[index].marcado =
                                                  true;
                                              marcados++;
                                            });
                                          }
                                        },
                                        child: CardWidget(
                                          widget: Row(
                                            children: [
                                              Expanded(
                                                child: CheckboxComponent(
                                                    value:
                                                        itemsProdutoPeca[index]
                                                            .marcado,
                                                    onChanged: (bool value) => {
                                                          setState(() {
                                                            marcarCheckbox(
                                                                index, value);
                                                          }),
                                                        }),
                                              ),
                                              VerticalDivider(
                                                color: Colors.grey.shade200,
                                              ),
                                              Expanded(
                                                flex: 8,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        TextComponent(
                                                          'ID',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        SizedBox(
                                                          width: 6,
                                                        ),
                                                        Text(
                                                          astecaDetalheController
                                                                  ?.pecaEstoquesAsteca[
                                                                      index]
                                                                  .peca
                                                                  ?.id_peca
                                                                  .toString() ??
                                                              '',
                                                        ),
                                                        SizedBox(
                                                          width: 24,
                                                        ),
                                                        TextComponent(
                                                          'Cód. Fábrica',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        SizedBox(
                                                          width: 6,
                                                        ),
                                                        Text(
                                                          astecaDetalheController
                                                                  ?.pecaEstoquesAsteca[
                                                                      index]
                                                                  .peca
                                                                  ?.codigo_fabrica ??
                                                              '',
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 6,
                                                    ),
                                                    Row(
                                                      children: [
                                                        TextComponent(
                                                          'Nome',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        SizedBox(
                                                          width: 6,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            astecaDetalheController
                                                                    ?.pecaEstoquesAsteca[
                                                                        index]
                                                                    .peca
                                                                    ?.descricao
                                                                    .toString()
                                                                    .capitalize ??
                                                                '',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 6,
                                                    ),
                                                    Row(
                                                      children: [
                                                        TextComponent(
                                                          'Nº Peças',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        SizedBox(
                                                          width: 6,
                                                        ),
                                                        Text(
                                                          astecaDetalheController
                                                                  ?.pecaEstoquesAsteca[
                                                                      index]
                                                                  .peca
                                                                  ?.numero ??
                                                              '',
                                                        ),
                                                        SizedBox(
                                                          width: 24,
                                                        ),
                                                        TextComponent(
                                                          'Saldo',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        SizedBox(
                                                          width: 6,
                                                        ),
                                                        Text(
                                                          astecaDetalheController
                                                                  ?.pecaEstoquesAsteca[
                                                                      index]
                                                                  .saldo_disponivel
                                                                  .toString() ??
                                                              '',
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 6,
                                                    ),
                                                    Row(
                                                      children: [
                                                        TextComponent(
                                                          'Valor R\$',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        SizedBox(
                                                          width: 6,
                                                        ),
                                                        Text(
                                                          astecaDetalheController
                                                                  ?.pecaEstoquesAsteca[
                                                                      index]
                                                                  .peca
                                                                  ?.custo
                                                                  .toString() ??
                                                              '',
                                                        ),
                                                        SizedBox(
                                                          width: 24,
                                                        ),
                                                        TextComponent(
                                                          'Endereço',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        SizedBox(
                                                          width: 6,
                                                        ),
                                                        Text(
                                                          astecaDetalheController
                                                                  ?.pecaEstoquesAsteca[
                                                                      index]
                                                                  .endereco
                                                                  .toString() ??
                                                              '',
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 13),
                          child: Column(
                            children: [
                              TextComponent(
                                  'Total de peças selecionadas: ${marcados}'),
                              SizedBox(
                                height: 16,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ButtonComponent(
                                      color: vermelhoColor,
                                      colorHover: vermelhoColorHover,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      text: 'Cancelar',
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: ButtonComponent(
                                        color: secundaryColor,
                                        colorHover: secundaryColorHover,
                                        onPressed: () {
                                          adicionarPeca();
                                          itemsProdutoPecaBusca.clear();
                                          Navigator.pop(context);
                                        },
                                        text: 'Adicionar'),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
          });
    } catch (e) {
      myShowDialog(e.toString());
    }
  }
}

class ItemProdutoPeca {
  bool marcado = false;
  late PecasEstoqueModel produtoPeca;
  ItemProdutoPeca({
    required this.marcado,
    required this.produtoPeca,
  });
}
