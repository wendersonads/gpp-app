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
import 'package:intl/intl.dart';

class AstecaDetalheDesktop extends StatefulWidget {
  final int id;
  const AstecaDetalheDesktop({Key? key, required this.id}) : super(key: key);

  @override
  State<AstecaDetalheDesktop> createState() => _AstecaDetalheDesktop();
}

class _AstecaDetalheDesktop extends State<AstecaDetalheDesktop> {
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
    astecaController.asteca = await astecaController.repository.buscarAsteca(widget.id);
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

    motivoTrocaPecaController.motivos = await motivoTrocaPecaController.repository.buscarTodos();

    setState(() {
      astecaController.carregadoMotivoTrocaPeca = false;
    });
  }

  handlePendencia(AstecaModel asteca, AstecaTipoPendenciaModel pendencia) async {
    await astecaController.astecaTipoPendenciaRepository.inserirAstecaPendencia(asteca.idAsteca!, pendencia);
    //Atualiza asteca
    await buscar();
  }

  gerarProdutoPeca() {
    astecaDetalheController!.pecaEstoquesAsteca.forEach((element) {
      itemsProdutoPeca.add(ItemProdutoPeca(marcado: false, produtoPeca: element));
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
          int index = astecaController.pedidoSaida.itemsPedidoSaida!
              .indexWhere((element) => element.pecaEstoque!.id_peca_estoque == itemPeca.produtoPeca.id_peca_estoque);
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
            astecaController.pedidoSaida.itemsPedidoSaida![index].valor += itemPeca.produtoPeca.peca!.custo!;
            controllerQtd[index].text = astecaController.pedidoSaida.itemsPedidoSaida![index].quantidade.toString();
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
      astecaController.pedidoSaida.valorTotal = astecaController.pedidoSaida.valorTotal! + item.quantidade * item.valor;
    }
  }

  selecionarMotivoTrocaPeca(index, value) {
    setState(() {
      astecaController.pedidoSaida.itemsPedidoSaida![index].motivoTrocaPeca = value;
    });
  }

  void adicionarQuantidade(index) {
    setState(() {
      astecaController.pedidoSaida.itemsPedidoSaida![index].quantidade++;
    });
    controllerQtd[index].text = astecaController.pedidoSaida.itemsPedidoSaida![index].quantidade.toString();
    calcularValorTotal();
  }

  void removerQuantidade(index) async {
    if (astecaController.pedidoSaida.itemsPedidoSaida![index].quantidade > 1) {
      setState(() {
        astecaController.pedidoSaida.itemsPedidoSaida![index].quantidade--;
      });
      controllerQtd[index].text = astecaController.pedidoSaida.itemsPedidoSaida![index].quantidade.toString();
      calcularValorTotal();
    } else {
      if (await Notificacao.confirmacao("Deseja realmente remover essa peça ?")) {
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
                    Row(
                      children: [
                        TextComponent(
                          text,
                          fontSize: 20.0,
                        )
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
        astecaController.pedidoSaida.cpfCnpj = astecaController.asteca.documentoFiscal!.cpfCnpj.toString();
        astecaController.pedidoSaida.filial_registro = astecaController.asteca.documentoFiscal!.idFilialVenda;
        astecaController.pedidoSaida.numDocFiscal = astecaController.asteca.documentoFiscal!.numDocFiscal;
        astecaController.pedidoSaida.serieDocFiscal = astecaController.asteca.documentoFiscal!.serieDocFiscal;

        astecaController.pedidoSaida.situacao = 1;
        astecaController.pedidoSaida.asteca = astecaController.asteca;
        astecaController.pedidoSaida.funcionario = astecaController.asteca.funcionario;
        astecaController.pedidoSaida.cliente = astecaController.asteca.documentoFiscal!.cliente;
        //Solicita o endpoint a criação do pedido

        PedidoSaidaModel pedidoComprovante = await astecaDetalheController!.finalizarPedidoSaida(
            astecaController.pedidoSaida); // astecaController.pedidoSaidaRepository.criar(astecaController.pedidoSaida);
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
            Row(
              children: [
                Padding(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextComponent(
                            'Nº Ordem de Saída: #${pedidoConfirmacao.idPedidoSaida}',
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: TextComponent('Nome do cliente: ${pedidoConfirmacao.cliente!.nome}'),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 4.0),
                        //   child: TextComponent('Filial venda: ${pedidoConfirmacao.filialVenda}'),
                        // )
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0))
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              children: [
                ButtonComponent(
                    color: primaryColor,
                    colorHover: primaryColorHover,
                    onPressed: () {
                      Get.toNamed('/ordens-saida');
                      Get.deleteAll();
                    },
                    text: 'Ok'),
                SizedBox(
                  width: 8,
                ),
                ButtonComponent(
                    color: secundaryColor,
                    colorHover: secundaryColorHover,
                    icon: Icon(
                      Icons.print,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      GerarPedidoSaidaPDF(pedido: pedidoConfirmacao).imprimirPDF();
                    },
                    text: 'Imprimir'),
                SizedBox(
                  width: 8,
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
              title: const Center(child: TitleComponent('Cancelamento realizado com sucesso!')),
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
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
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
                                    Get.offAllNamed('/astecas/${astecaController.asteca.idAsteca!}');
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
            Row(
              children: [
                Padding(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextComponent(
                            'Nº Ordem de Entrada: #${pedidoConfirmacao.idPedidoEntrada}',
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: TextComponent(
                              'Nome do fornecedor: ${pedidoConfirmacao.asteca!.compEstProd!.first.produto!.fornecedores!.first.cliente!.nome}'),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0))
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              children: [
                ButtonComponent(
                    color: primaryColor,
                    colorHover: primaryColorHover,
                    onPressed: () async {
                      Navigator.pop(context);
                      error ? error = false : await finalizarPedido();
                    },
                    text: 'Ok'),
                SizedBox(
                  width: 8,
                ),
                ButtonComponent(
                    color: secundaryColor,
                    colorHover: secundaryColorHover,
                    icon: Icon(
                      Icons.print,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      GerarPedidoEntradaPDF(pedidoEntrada: pedidoConfirmacao).imprimirPDF();
                    },
                    text: 'Imprimir'),
                SizedBox(
                  width: 8,
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
                            await enviarEmailPedidoEntrada(pedidoConfirmacao);
                          },
                          text: 'Enviar e-mail')
                      : LoadingComponent(),
                )
              ],
            )
          ]);
        });
  }

  enviarEmailPedidoSaida(PedidoSaidaModel pedidoConfirmacao) async {
    astecaDetalheController!.carregandoEmail(true);
    try {
      if (await astecaController.pedidoSaidaRepository
          .enviarEmailFornecedor(pedidoConfirmacao.idPedidoSaida!, pedidoConfirmacao)) {
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
      if (await astecaController.pedidoEntradaRepository
          .enviarEmailFornecedor(pedidoConfirmacao.idPedidoEntrada!, pedidoConfirmacao)) {
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
      content: Text("Existem peças adicionadas que não possuem estoque disponível. Gostaria de criar um pedido de entrada?"),
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
      itensPedidoEntrada.add(ItemPedidoEntradaModel(quantidade: e.quantidade, custo: e.valor, peca: e.peca));
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
            .finalizarPedidoEntrada(pedidoEntrada); //pedidoEntracaController.repository.criar(pedidoEntrada);
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
            element.produtoPeca.peca!.descricao!.toLowerCase().contains(value.toString().toLowerCase()) ||
            element.produtoPeca.peca!.id_peca.toString().contains(value))
        .toList();
  }

  pesquisarPendencia(value) {
    setState(() {
      astecaController.astecaTipoPendenciasBuscar = astecaController.astecaTipoPendencias
          .where((element) =>
              element.descricao!.toLowerCase().contains(value.toString().toLowerCase()) ||
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
      if (await Notificacao.confirmacao("Deseja realmente remover essa peça ?")) {
        removerPeca(index);
      }
    } else if (quantidade > 0) {
      astecaController.pedidoSaida.itemsPedidoSaida![index].quantidade = quantidade;

      calcularValorTotal();
    }
  }

  _buildSituacaoEstoque(index) {
    if (astecaController.pedidoSaida.itemsPedidoSaida![index].saldo_disponivel == null) {
      return Colors.red.shade100;
    } else {
      if (astecaController.pedidoSaida.itemsPedidoSaida![index].saldo_disponivel! <
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
      body: Row(
        children: [
          Expanded(child: Sidebar()),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: const TitleComponent(
                          'Asteca',
                        ),
                      ),
                      astecaController.carregadoAsteca
                          ? Expanded(
                              child: Container(
                                decoration: BoxDecoration(color: secundaryColor, borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                                    child: astecaController.asteca.astecaPendencias != null
                                        ? TextComponent(
                                            (astecaController.asteca.astecaPendencias?.last.astecaTipoPendencia?.idTipoPendencia
                                                        .toString() ??
                                                    '') +
                                                ' - ' +
                                                (astecaController.asteca.astecaPendencias?.last.astecaTipoPendencia?.descricao
                                                        .toString() ??
                                                    ''),
                                            color: Colors.white,
                                          )
                                        : const TextComponent('Aguardando Pendência', color: Colors.white)),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  _astecaMenu(),
                  Padding(padding: EdgeInsets.only(bottom: 20)),
                  _astecaNavegacao(),
                  _astecaBotoes(astecaController.step),
                ],
              ),
            ),
          ),
        ],
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
                padding: EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: astecaController.step == 1 ? secundaryColor : Colors.grey.shade200,
                        width: astecaController.step == 1 ? 4 : 1),
                  ),
                ),
                child: TextComponentMenu(
                  'Informações',
                ),
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
                padding: EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: astecaController.step == 2 ? secundaryColor : Colors.grey.shade200,
                        width: astecaController.step == 2 ? 4 : 1),
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
                padding: EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: astecaController.step == 3 ? secundaryColor : Colors.grey.shade200,
                        width: astecaController.step == 3 ? 4 : 1),
                  ),
                ),
                child: TextComponentMenu('Histórico de pendências'),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonComponent(
                      color: vermelhoColor,
                      colorHover: vermelhoColorHover,
                      onPressed: () {
                        Get.offAllNamed('/astecas');
                      },
                      text: 'Fechar',
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            astecaController.asteca.pedidoSaida != null
                                ? Obx(
                                    () => !astecaDetalheController!.cancelando.value
                                        ? ButtonComponent(
                                            color: vermelhoColor,
                                            colorHover: vermelhoColorHover,
                                            onPressed: () async {
                                              CancelamentoModel retorno = await astecaDetalheController!
                                                  .cancelarPedidosAsteca(astecaController.asteca.idAsteca!);

                                              exibirComprovanteCancelamentoPedidos(retorno.info!);
                                            },
                                            text: 'Cancelar pedido')
                                        : LoadingComponent(),
                                  )
                                : Container(),
                            SizedBox(
                              width: 8,
                            ),
                            astecaController.asteca.pedidoSaida == null
                                ? Obx(
                                    () => !astecaDetalheController!.carregandoFinalizacao.value
                                        ? ButtonComponent(
                                            color: primaryColor,
                                            colorHover: primaryColorHover,
                                            onPressed: () async {
                                              if (astecaController.pedidoSaida.itemsPedidoSaida!.length <= 0) {
                                                Notificacao.snackBar("Adicione peças antes de finalizar o pedido");
                                              } else {
                                                await finalizarPedido();
                                              }
                                            },
                                            text: 'Finalizar pedido',
                                          )
                                        : LoadingComponent(),
                                  )
                                : Container(),
                            const SizedBox(
                              width: 8,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            astecaController.asteca.pedidoSaida != null
                                ? ButtonComponent(
                                    color: primaryColor,
                                    colorHover: primaryColorHover,
                                    onPressed: () {
                                      Get.toNamed("/ordens-saida/${astecaController.asteca.pedidoSaida!.idPedidoSaida}");
                                    },
                                    text: 'Visualizar ordem de saída',
                                  )
                                : Container(),
                            const SizedBox(
                              width: 8,
                            ),
                            astecaController.asteca.pedidoEntrada != null
                                ? ButtonComponent(
                                    color: primaryColor,
                                    colorHover: primaryColorHover,
                                    onPressed: () {
                                      Get.toNamed("/ordens-entrada/${astecaController.asteca.pedidoEntrada!.idPedidoEntrada}");
                                    },
                                    text: 'Visualizar ordem de entrada',
                                  )
                                : Container(),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        astecaController.asteca.pedidoSaida != null
                            ? Container()
                            : ButtonComponent(
                                color: primaryColor,
                                colorHover: primaryColorHover,
                                onPressed: () {
                                  exibirPecas(context);
                                },
                                text: 'Adicionar peças'),
                        const SizedBox(
                          width: 8,
                        ),
                        ButtonComponent(
                          color: vermelhoColor,
                          colorHover: vermelhoColorHover,
                          onPressed: () {
                            Get.offAllNamed('/astecas');
                          },
                          text: 'Fechar',
                        ),
                      ],
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
              padding: const EdgeInsets.symmetric(vertical: 16.0),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
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
                    flex: 2,
                    child: InputComponent(
                      readOnly: true,
                      key: UniqueKey(),
                      initialValue: astecaController.asteca.documentoFiscal?.cpfCnpj == null
                          ? ''
                          : maskFormatter
                              .cpfCnpjFormatter(value: astecaController.asteca.documentoFiscal!.cpfCnpj.toString())!
                              .getMaskedText(),
                      label: 'CPF/CNPJ',
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
                      initialValue: astecaController.camelCaseAll(astecaController.asteca.documentoFiscal?.nome ?? ''),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: InputComponent(
                      readOnly: true,
                      key: UniqueKey(),
                      label: 'Nº Fiscal',
                      initialValue: astecaController.asteca.documentoFiscal?.numDocFiscal.toString() ?? '',
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
                      initialValue: astecaController.asteca.documentoFiscal?.serieDocFiscal.toString() ?? '',
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InputComponent(
                      readOnly: true,
                      key: UniqueKey(),
                      label: 'Filial de saída',
                      initialValue: astecaController.asteca.documentoFiscal?.idFilialSaida.toString() ?? '',
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
                      initialValue: astecaController.asteca.documentoFiscal?.idFilialVenda.toString() ?? '',
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
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
                      label: 'Data de abertura',
                      initialValue: astecaController.asteca.dataEmissao == null
                          ? ''
                          : DateFormat('dd/MM/yyyy').format(astecaController.asteca.dataEmissao!),
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
                      initialValue: astecaController.asteca.documentoFiscal?.dataEmissao == null
                          ? ''
                          : DateFormat('dd/MM/yyyy').format(astecaController.asteca.documentoFiscal!.dataEmissao!),
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
                      initialValue: astecaController.asteca.idFilialRegistro?.toString() ?? '',
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.badge,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  TitleComponent('Funcionário (a)'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: InputComponent(
                        readOnly: true,
                        key: UniqueKey(),
                        label: 'RE',
                        initialValue: astecaController.asteca.funcionario?.idFuncionario.toString() ?? ''),
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
                      initialValue:
                          astecaController.camelCaseAll(astecaController.asteca.funcionario?.clienteFunc?.cliente?.nome ?? ''),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.build,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  TitleComponent('Defeito ou motivo'),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                      child: InputComponent(
                        readOnly: true,
                        key: UniqueKey(),
                        maxLines: 5,
                        label: 'Defeito',
                        initialValue: astecaController.camelCaseFirst(astecaController.asteca.defeitoEstadoProd ?? ''),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                      child: InputComponent(
                        readOnly: true,
                        key: UniqueKey(),
                        maxLines: 5,
                        label: 'Observação',
                        initialValue: astecaController.camelCaseFirst(astecaController.asteca.observacao ?? ''),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Asteca Endereco
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: InputComponent(
                          readOnly: true,
                          key: UniqueKey(),
                          label: 'Logradouro',
                          initialValue:
                              astecaController.camelCaseFirst(astecaController.asteca.astecaEndCliente?.logradouro ?? ''),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        flex: 3,
                        child: InputComponent(
                          readOnly: true,
                          key: UniqueKey(),
                          label: 'Complemento',
                          initialValue:
                              astecaController.camelCaseFirst(astecaController.asteca.astecaEndCliente?.complemento ?? ''),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: InputComponent(
                          readOnly: true,
                          key: UniqueKey(),
                          label: 'Número',
                          initialValue: astecaController.asteca.astecaEndCliente?.numero.toString() ?? '',
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InputComponent(
                          readOnly: true,
                          key: UniqueKey(),
                          label: 'Bairro',
                          initialValue: astecaController.camelCaseAll(astecaController.asteca.astecaEndCliente?.bairro ?? ''),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: InputComponent(
                          readOnly: true,
                          key: UniqueKey(),
                          label: 'CEP',
                          initialValue: astecaController.asteca.astecaEndCliente?.cep == null
                              ? ''
                              : maskFormatter
                                  .cepInputFormmater(astecaController.asteca.astecaEndCliente?.cep.toString())
                                  .getMaskedText(),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: InputComponent(
                          readOnly: true,
                          key: UniqueKey(),
                          label: 'Cidade',
                          initialValue: astecaController.camelCaseAll(astecaController.asteca.astecaEndCliente?.localidade == null
                              ? ''
                              : astecaController.asteca.astecaEndCliente?.localidade.toString()),
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
                          initialValue: astecaController.asteca.astecaEndCliente?.uf == null
                              ? ''
                              : astecaController.asteca.astecaEndCliente?.uf.toString(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InputComponent(
                          readOnly: true,
                          key: UniqueKey(),
                          label: 'Referência',
                          initialValue:
                              astecaController.camelCaseFirst(astecaController.asteca.astecaEndCliente?.pontoReferencia1 ?? ''),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.call,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      TitleComponent('Telefone para contato'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InputComponent(
                          readOnly: true,
                          key: UniqueKey(),
                          label: 'Telefone',
                          initialValue: astecaController.asteca.astecaEndCliente?.ddd == null ||
                                  astecaController.asteca.astecaEndCliente?.telefone == null
                              ? ''
                              : maskFormatter
                                  .telefoneInputFormmater(
                                      '${astecaController.asteca.astecaEndCliente?.ddd.toString()} ${astecaController.asteca.astecaEndCliente?.telefone.toString()}')
                                  .getMaskedText(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Asteca Produto
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InputComponent(
                          readOnly: true,
                          key: UniqueKey(),
                          label: 'ID',
                          initialValue: astecaController.asteca.compEstProd?.first.produto?.idProduto.toString() ?? '',
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
                          initialValue:
                              astecaController.camelCaseFirst(astecaController.asteca.compEstProd?.first.produto?.resumida ?? ''),
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
                            initialValue: astecaController.asteca.documentoFiscal?.itemDocFiscal?.idLd.toString() ?? ''),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_shipping,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      const TitleComponent('Fornecedor'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InputComponent(
                          readOnly: true,
                          key: UniqueKey(),
                          label: 'ID',
                          initialValue:
                              astecaController.asteca.compEstProd?.first.produto?.fornecedores?.first.idFornecedor.toString() ??
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
                          initialValue: astecaController.camelCaseAll(
                              astecaController.asteca.compEstProd?.first.produto?.fornecedores?.first.cliente?.nome ?? ''),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _astecaPecas() {
    return Expanded(
      child: SingleChildScrollView(
        controller: new ScrollController(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            astecaController.carregadoAsteca
                ? Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: InputComponent(
                            label: 'ID do produto',
                            readOnly: true,
                            initialValue: astecaController.asteca.compEstProd?.first.produto?.idProduto.toString() ?? '',
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: InputComponent(
                            label: 'Produto',
                            readOnly: true,
                            initialValue: astecaController.asteca.compEstProd?.first.produto?.resumida.toString() ?? '',
                          ),
                        ),
                      ],
                    ),
                  )
                : LoadingComponent(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.handyman_rounded,
                        size: 32,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      const TitleComponent('Escolha as peças para atendimento'),
                    ],
                  ),
                  astecaController.asteca.pedidoSaida != null
                      ? EventoStatusWidget(color: Colors.pink, texto: 'Atendimento finalizado')
                      : astecaController.carregadoAsteca
                          ? Obx(
                              () => !astecaDetalheController!.carregando.value
                                  ? ButtonComponent(
                                      color: primaryColor,
                                      colorHover: primaryColorHover,
                                      onPressed: () {
                                        exibirPecas(context);
                                      },
                                      text: 'Adicionar peças',
                                    )
                                  : LoadingComponent(),
                            )
                          : LoadingComponent()
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              color: Colors.grey.shade200,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12.0),
              child: Row(
                children: [
                  const Expanded(
                    child: const TextComponent(
                      'ID',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Expanded(
                    child: const TextComponent(
                      'Nome',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Expanded(
                    child: const TextComponent(
                      'N° Peças',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Expanded(
                    flex: 2,
                    child: const Center(
                      child: const TextComponent(
                        'Quantidade',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: const TextComponent(
                      'Valor R\$',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Expanded(
                    child: const Center(
                      child: const TextComponent(
                        'Subtotal R\$',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 3,
                    child: const Center(
                      child: const TextComponent(
                        'Motivo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: const TextComponent(
                      'Ações',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: const TextComponent(
                      'Endereço',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: const TextComponent(
                      'Saldo',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: Get.height * 0.40,
              child: astecaController.asteca.pedidoSaida == null
                  ? ListView.builder(
                      itemCount: astecaController.pedidoSaida.itemsPedidoSaida?.length ?? 1,
                      itemBuilder: (context, index) {
                        controllerQtd.add(new TextEditingController(text: 1.toString()));

                        return Container(
                          decoration: BoxDecoration(
                              color: _buildSituacaoEstoque(index),
                              border: Border(
                                  top: BorderSide(color: Colors.grey.shade100),
                                  left: BorderSide(color: Colors.grey.shade100),
                                  bottom: BorderSide(color: Colors.grey.shade100),
                                  right: BorderSide(color: Colors.grey.shade100))),
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: SelectableText(
                                    astecaController.pedidoSaida.itemsPedidoSaida?[index].peca?.id_peca.toString() ?? ''),
                              ),
                              Expanded(
                                child: SelectableText(astecaController
                                    .camelCaseFirst(astecaController.pedidoSaida.itemsPedidoSaida?[index].peca?.descricao ?? '')),
                              ),
                              Expanded(
                                child: SelectableText(astecaController
                                    .camelCaseFirst(astecaController.pedidoSaida.itemsPedidoSaida?[index].peca?.numero ?? '')),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
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
                                        controller: controllerQtd[index],
                                        inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                                        onChanged: (value) {
                                          inserirQuantidade(index, value);
                                        },
                                        onFieldSubmitted: (value) {
                                          setState(() {
                                            inserirQuantidade(index, value);
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
                              ),
                              Expanded(
                                child: SelectableText(astecaController.formatter
                                    .format(astecaController.pedidoSaida.itemsPedidoSaida?[index].valor ?? '')),
                              ),
                              Expanded(
                                child: SelectableText(
                                  'R\$: ' +
                                      astecaController.formatter.format(
                                        ((astecaController.pedidoSaida.itemsPedidoSaida?[index].quantidade ?? 0) *
                                            (astecaController.pedidoSaida.itemsPedidoSaida?[index].valor ?? 0)),
                                      ),
                                ),
                              ),
                              Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration:
                                          BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5)),
                                      child: Container(
                                        height: 40,
                                        decoration:
                                            BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5)),
                                        child: DropdownSearch<MotivoModel>(
                                          mode: Mode.MENU,
                                          showSearchBox: true,
                                          items: motivoTrocaPecaController.motivos
                                              .where((motivo) => motivo.situacao == true)
                                              .toList(),
                                          itemAsString: (value) => value!.nome.toString(),
                                          onChanged: (value) async {
                                            selecionarMotivoTrocaPeca(index, value);
                                          },
                                          searchFieldProps: TextFieldProps(
                                            decoration: InputDecoration(
                                              fillColor: Colors.grey.shade100,
                                              filled: true,
                                              contentPadding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                                              border: InputBorder.none,
                                              labelText: 'Pesquisar por nome',
                                              labelStyle: const TextStyle(color: Colors.black),
                                            ),
                                            style: const TextStyle(color: Colors.black),
                                          ),
                                          selectedItem: astecaController.pedidoSaida.itemsPedidoSaida![index].motivoTrocaPeca,
                                          dropdownSearchDecoration: InputDecoration(
                                            hintText: 'Selecione o Motivo',
                                            hintStyle: TextStyle(color: Colors.black),
                                            fillColor: Colors.pinkAccent, // Cor fundo caixa dropdown
                                            isDense: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.circular(25.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.circular(25.0),
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
                                          popupBackgroundColor: Colors.white, // Cor de fundo para caixa de seleção
                                          showAsSuffixIcons: true,
                                        ),
                                      ),
                                      // DropDownComponent(
                                      //   onChanged: (value) {
                                      //     selecionarMotivoTrocaPeca(index, value);
                                      //   },
                                      //   items: motivoTrocaPecaController.motivoTrocaPecas
                                      //       .where((motivo) => motivo.situacao == true)
                                      //       .map((value) {
                                      //     return DropdownMenuItem<MotivoTrocaPecaModel>(
                                      //       value: value,
                                      //       child: Text(astecaController.camelCaseFirst(value.nome.toString())),
                                      //     );
                                      //   }).toList(),
                                      //   hintText: 'Selecione o motivo',
                                      // ),
                                    ),
                                  )),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.grey.shade400,
                                        ),
                                        onPressed: () {
                                          removerPeca(index);
                                        }),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: SelectableText(
                                    astecaController.pedidoSaida.itemsPedidoSaida?[index].endereco ?? 'Sem endereçamento'),
                              ),
                              Expanded(
                                flex: 1,
                                child: SelectableText(
                                    astecaController.pedidoSaida.itemsPedidoSaida?[index].saldo_disponivel.toString() ?? '-'),
                              ),
                            ],
                          ),
                        );
                      })
                  : Container(),
            ),
            const Divider(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextComponent(
                    'Total: ${astecaController.pedidoSaida.itemsPedidoSaida != null ? astecaController.pedidoSaida.itemsPedidoSaida!.length : 0} peças selecionadas',
                  ),
                  TextComponent(
                    'Valor total R\$: ' + astecaController.formatter.format(astecaController.pedidoSaida.valorTotal),
                  ),
                ],
              ),
            )
          ],
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
                      height: 700,
                      child: ListView.builder(
                        itemCount: astecaController.asteca.astecaPendencias?.length ?? 1,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: (index % 2) == 0 ? MainAxisAlignment.start : MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 340,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey.shade100),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
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
      astecaDetalheController!.idProduto = astecaController.asteca.compEstProd!.first.produto!.idProduto!.toString();
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
                content: Container(
                  width: media.size.width * 0.80,
                  height: media.size.height * 0.80,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const TextComponent(
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
                        child: Row(
                          children: [
                            Expanded(
                              child: InputComponent(
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
                            ),
                            const SizedBox(
                              width: 8,
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
                            // const SizedBox(
                            //   width: 8,
                            // ),
                            // ButtonComponent(
                            //   color: secundaryColor,
                            //   colorHover: secundaryColorHover,
                            //   icon: Icon(Icons.tune_rounded, color: Colors.white),
                            //   onPressed: () {
                            //     setState(() {
                            //       abrirFiltro = !abrirFiltro;
                            //     });
                            //   },
                            //   text: 'Adicionar filtro',
                            // )
                          ],
                        ),
                      ),
                      // Container(
                      //   height: abrirFiltro ? null : 0,
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(vertical: 12.0),
                      //     child: Row(
                      //       children: [
                      //         Container(
                      //           width: 220,
                      //           child: DropDownComponent(
                      //             icon: const Icon(
                      //               Icons.swap_vert,
                      //             ),
                      //             items: <String>['Ordem crescente', 'Ordem decrescente'].map((String value) {
                      //               return DropdownMenuItem<String>(
                      //                 value: value,
                      //                 child: Text(value),
                      //               );
                      //             }).toList(),
                      //             hintText: 'Nome',
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           width: 8,
                      //         ),
                      //         Container(
                      //           width: 220,
                      //           child: DropDownComponent(
                      //             icon: const Icon(
                      //               Icons.swap_vert,
                      //             ),
                      //             items: <String>['Ordem crescente', 'Ordem decrescente'].map((String value) {
                      //               return DropdownMenuItem<String>(
                      //                 value: value,
                      //                 child: Text(value),
                      //               );
                      //             }).toList(),
                      //             hintText: 'Estoque disponível',
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           width: 8,
                      //         ),
                      //         Container(
                      //           width: 220,
                      //           child: DropDownComponent(
                      //             icon: const Icon(
                      //               Icons.swap_vert,
                      //             ),
                      //             items: <String>[
                      //               'Último dia',
                      //               'Último 15 dias',
                      //               'Último 30 dias',
                      //               'Último semestre',
                      //               'Último ano'
                      //             ].map((String value) {
                      //               return DropdownMenuItem<String>(
                      //                 value: value,
                      //                 child: Text(value),
                      //               );
                      //             }).toList(),
                      //             hintText: 'Período',
                      //           ),
                      //         ),
                      //         const SizedBox(
                      //           width: 8,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   color: Colors.grey.shade50,
                      //   height: astecaController.abrirFiltro ? null : 0,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(16.0),
                      //     child: Row(
                      //       children: [
                      //         Expanded(
                      //           flex: 5,
                      //           child: InputComponent(
                      //             label: 'Data de criação:',
                      //             hintText: 'Digite a data de criação da peça',
                      //           ),
                      //         ),
                      //         const SizedBox(width: 8),
                      //         Expanded(
                      //           flex: 5,
                      //           child: InputComponent(
                      //             label: 'Data de criação:',
                      //             hintText: 'Digite a data de criação da peça',
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      Container(
                        color: Colors.grey.shade200,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        child: Row(
                          children: [
                            CheckboxComponent(
                              value: marcados == astecaDetalheController!.pecaEstoquesAsteca.length,
                              onChanged: (bool value) {
                                setState(() {
                                  marcarTodosCheckbox(value);
                                });
                              },
                            ),
                            Expanded(
                              child: const TextComponent(
                                'ID',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                                child: const TextComponent(
                              'Cod. Fábrica',
                              fontWeight: FontWeight.bold,
                            )),
                            Expanded(
                                child: const TextComponent(
                              'Nº peças',
                              fontWeight: FontWeight.bold,
                            )),
                            Expanded(
                              child: const TextComponent(
                                'Nome',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: const TextComponent(
                                'Valor R\$',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: const TextComponent(
                                'Endereço',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: const TextComponent(
                                'Saldo',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: itemsProdutoPecaBusca.length == 0
                            ? ListView.builder(
                                itemCount: astecaDetalheController?.pecaEstoquesAsteca.length ?? 1,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(color: Colors.grey.shade100),
                                            left: BorderSide(color: Colors.grey.shade100),
                                            bottom: BorderSide(color: Colors.grey.shade100),
                                            right: BorderSide(color: Colors.grey.shade100))),
                                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                    child: Row(
                                      children: [
                                        CheckboxComponent(
                                            value: itemsProdutoPeca[index].marcado,
                                            onChanged: (bool value) => {
                                                  setState(() {
                                                    marcarCheckbox(index, value);
                                                  })
                                                }),
                                        Expanded(
                                          child: SelectableText(
                                              astecaDetalheController?.pecaEstoquesAsteca[index].peca?.id_peca.toString() ?? ''),
                                        ),
                                        Expanded(
                                          child: SelectableText(
                                            '${astecaDetalheController?.pecaEstoquesAsteca[index].peca?.codigo_fabrica ?? ''}',
                                          ),
                                        ),
                                        Expanded(
                                            child: SelectableText(
                                          '${astecaDetalheController?.pecaEstoquesAsteca[index].peca?.numero ?? ''}',
                                        )),
                                        Expanded(
                                          child: SelectableText(astecaDetalheController?.pecaEstoquesAsteca[index].peca?.descricao
                                                  .toString()
                                                  .capitalize ??
                                              ''),
                                        ),
                                        Expanded(
                                          child: SelectableText(
                                              astecaDetalheController?.pecaEstoquesAsteca[index].peca?.custo.toString() ?? ''),
                                        ),
                                        Expanded(
                                          child: SelectableText(
                                            astecaDetalheController?.pecaEstoquesAsteca[index].endereco.toString() ?? '',
                                          ),
                                        ),
                                        Expanded(
                                          child: SelectableText(
                                            astecaDetalheController?.pecaEstoquesAsteca[index].saldo_disponivel.toString() ?? '',
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                            : ListView.builder(
                                itemCount: itemsProdutoPecaBusca.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(color: Colors.grey.shade100),
                                            left: BorderSide(color: Colors.grey.shade100),
                                            bottom: BorderSide(color: Colors.grey.shade100),
                                            right: BorderSide(color: Colors.grey.shade100))),
                                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                    child: Row(
                                      children: [
                                        CheckboxComponent(
                                            value: itemsProdutoPecaBusca[index].marcado,
                                            onChanged: (bool value) => {
                                                  setState(() {
                                                    marcarCheckboxBusca(index, value);
                                                  })
                                                }),
                                        Expanded(
                                          child: TextComponent(
                                              itemsProdutoPecaBusca[index].produtoPeca.peca?.id_peca.toString() ?? ''),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                              itemsProdutoPecaBusca[index].produtoPeca.peca?.descricao.toString().capitalize ??
                                                  ''),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                              itemsProdutoPecaBusca[index].produtoPeca.peca?.custo.toString() ?? ''),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                            itemsProdutoPecaBusca[index].produtoPeca.endereco ?? '',
                                          ),
                                        ),
                                        Expanded(
                                          child: TextComponent(
                                            itemsProdutoPecaBusca[index].produtoPeca.saldo_disponivel?.toString() ?? '',
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextComponent('Total de peças selecionadas: ${marcados}'),
                            Row(
                              children: [
                                ButtonComponent(
                                    color: vermelhoColor,
                                    colorHover: vermelhoColorHover,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    text: 'Cancelar'),
                                const SizedBox(
                                  width: 12,
                                ),
                                ButtonComponent(
                                    color: secundaryColor,
                                    colorHover: secundaryColorHover,
                                    onPressed: () {
                                      adicionarPeca();
                                      itemsProdutoPecaBusca.clear();
                                      Navigator.pop(context);
                                    },
                                    text: 'Adicionar')
                              ],
                            )
                          ],
                        ),
                      )
                    ],
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
