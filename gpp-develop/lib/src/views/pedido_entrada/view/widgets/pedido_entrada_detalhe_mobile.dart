import 'package:flutter/material.dart';
import 'package:gpp/src/controllers/pedido_entrada_controller.dart';
import 'package:gpp/src/models/item_pedido_entrada_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/shared/utils/GerarPedidoEntradaPDF.dart';
import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:get/get.dart';
import 'package:gpp/src/views/pedido_entrada/controller/pedidoEntradaDetalheController.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class PedidoEntradaDetalheMobile extends StatefulWidget {
  final int id;

  PedidoEntradaDetalheMobile({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _PedidoEntradaDetalheViewState createState() => _PedidoEntradaDetalheViewState();
}

class _PedidoEntradaDetalheViewState extends State<PedidoEntradaDetalheMobile> {
  late PedidoEntradaController controller;
  late MaskFormatter maskFormatter;
  final controllerPedidoEntrada = Get.put(PedidoEntradaDetalheController());

  buscar() async {
    setState(() {
      controller.carregado = false;
    });
    controller.pedidoEntrada = await controller.repository.buscarPedidoEntrada(widget.id);

    setState(() {
      controller.carregado = true;
    });
  }

  @override
  void initState() {
    super.initState();
    //Inicializa pedido controller
    controller = PedidoEntradaController();
    //Inicializa mask formatter
    maskFormatter = MaskFormatter();
    //buscar o pedido
    buscar();
  }

  Widget _buildListItem(List<ItemPedidoEntradaModel> itensPedido, int index, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: CardWidget(
            widget: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            TextComponent(
                              'Código do item',
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              itensPedido[index].idItemPedidoEntrada.toString(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            TextComponent(
                              'Código da peça',
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              itensPedido[index].peca?.id_peca.toString() ?? '',
                            ),
                          ],
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
                        'Descrição',
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Flexible(
                        child: Text(
                          itensPedido[index].peca?.descricao.toString().capitalize ?? '',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            TextComponent(
                              'Quantidade',
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              itensPedido[index].quantidade.toString(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            TextComponent(
                              'Endereço',
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Flexible(
                              child: Text(
                                itensPedido[index].peca?.estoque?.first.endereco.toString() ?? '-',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            TextComponent(
                              'Valor R\$',
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              itensPedido[index].custo != null ? controller.formatter.format(itensPedido[index].custo) : '-',
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            TextComponent(
                              'Subtotal R\$',
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              itensPedido[index].custo != null
                                  ? controller.formatter.format((itensPedido[index].custo! * itensPedido[index].quantidade!))
                                  : '-',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _buildSituacaoPedido(value) {
    if (value == 1) {
      return Container(
        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
          child: TextComponent(
            'Em aberto',
            color: Colors.white,
          ),
        ),
      );
    } else if (value == 2) {
      return Container(
        decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
          child: TextComponent(
            'Pendente',
            color: Colors.white,
          ),
        ),
      );
    } else if (value == 3) {
      return Container(
        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
          child: TextComponent(
            'Concluído',
            color: Colors.white,
          ),
        ),
      );
    } else if (value == 4) {
      return Container(
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
          child: TextComponent(
            'Cancelado',
            color: Colors.white,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarWidget(),
      backgroundColor: Colors.white,
      drawer: Sidebar(),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: controller.carregado
              ? SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextComponent(
                          'Ordem de Entrada',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSituacaoPedido(controller.pedidoEntrada.situacao),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InputComponent(
                            readOnly: true,
                            label: 'ID',
                            initialValue: controller.pedidoEntrada.idPedidoEntrada.toString(),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          flex: 2,
                          child: InputComponent(
                            readOnly: true,
                            label: 'CPF/CNPJ',
                            initialValue: controller
                                        .pedidoEntrada.asteca?.compEstProd?.first.produto?.fornecedores?.first.cliente?.cpfCnpj !=
                                    null
                                ? maskFormatter
                                    .cpfCnpjFormatter(
                                        value: controller.pedidoEntrada.asteca!.compEstProd!.first.produto!.fornecedores!.first
                                            .cliente!.cpfCnpj
                                            .toString())!
                                    .getMaskedText()
                                : controller.pedidoEntrada.itensPedidoEntrada?.first.peca?.produtoPeca?.first.produto
                                            ?.fornecedores?.first.cliente?.cpfCnpj
                                            .toString() !=
                                        null
                                    ? maskFormatter
                                        .cpfCnpjFormatter(
                                            value: controller.pedidoEntrada.itensPedidoEntrada?.first.peca?.produtoPeca?.first
                                                .produto?.fornecedores?.first.cliente?.cpfCnpj
                                                .toString())!
                                        .getMaskedText()
                                    : '',
                          ),
                        ), //maskFormatter.cpfCnpjFormatter( value: )!.getMaskedText())),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    InputComponent(
                      readOnly: true,
                      label: 'Fornecedor',
                      initialValue: controller.pedidoEntrada.asteca?.compEstProd?.first.produto?.fornecedores?.first.cliente?.nome
                              .toString() ??
                          controller.pedidoEntrada.itensPedidoEntrada?.first.peca?.produtoPeca?.first.produto?.fornecedores?.first
                              .cliente?.nome
                              .toString() ??
                          '',
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InputComponent(
                              readOnly: true,
                              label: 'Funcionário',
                              initialValue:
                                  controller.pedidoEntrada.funcionario!.clienteFunc!.cliente!.nome.toString().capitalize ?? ''),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: InputComponent(
                            readOnly: true,
                            label: 'Data de emissão',
                            initialValue: maskFormatter
                                .dataFormatterAmericano(value: controller.pedidoEntrada.dataEmissao.toString())
                                .getMaskedText(),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InputComponent(
                              readOnly: true,
                              label: 'Valor total R\$',
                              initialValue: controller.formatter.format(controller.pedidoEntrada.valorTotal)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    controller.pedidoEntrada.asteca?.idAsteca != null
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  TitleComponent('Asteca'),
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: InputComponent(
                                        readOnly: true,
                                        label: 'ID',
                                        initialValue: controller.pedidoEntrada.asteca?.idAsteca == null
                                            ? ''
                                            : controller.pedidoEntrada.asteca!.idAsteca.toString()),
                                  ),
                                ],
                              )
                            ],
                          )
                        : SizedBox.shrink(),
                    Row(
                      children: [
                        Obx(
                          () => !controllerPedidoEntrada.carregandoEmail.value
                              ? Expanded(
                                  child: ButtonComponent(
                                      color: secundaryColor,
                                      colorHover: secundaryColorHover,
                                      icon: Icon(
                                        Icons.email,
                                        color: Colors.white,
                                      ),
                                      onPressed: () async {
                                        await controllerPedidoEntrada.enviarEmailPedidoEntrada(controller.pedidoEntrada);
                                      },
                                      text: 'Enviar e-mail'),
                                )
                              : LoadingComponent(),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: ButtonComponent(
                            icon: Icon(
                              Icons.wysiwyg_outlined,
                              color: Colors.white,
                            ),
                            color: secundaryColor,
                            onPressed: () {
                              Get.toNamed("/astecas/${controller.pedidoEntrada.asteca!.idAsteca}");
                            },
                            text: 'Ver mais',
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [TitleComponent('Itens do pedido')],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.pedidoEntrada.itensPedidoEntrada!.length,
                      itemBuilder: (context, index) {
                        return _buildListItem(controller.pedidoEntrada.itensPedidoEntrada!, index, context);
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ButtonComponent(
                            color: primaryColor,
                            onPressed: () {
                              Get.offAllNamed('/ordens-entrada');
                            },
                            text: 'Voltar',
                          ),
                          ButtonComponent(
                            color: secundaryColor,
                            colorHover: secundaryColorHover,
                            onPressed: () {
                              GerarPedidoEntradaPDF(pedidoEntrada: controller.pedidoEntrada).imprimirPDF();
                            },
                            text: 'Imprimir',
                          )
                        ],
                      ),
                    )
                  ]),
                )
              : LoadingComponent(),
        ),
      ),
    );
  }
}
