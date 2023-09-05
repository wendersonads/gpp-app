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
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class PedidoEntradaDetalheDesktop extends StatefulWidget {
  final int id;

  PedidoEntradaDetalheDesktop({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _PedidoEntradaDetalheViewState createState() => _PedidoEntradaDetalheViewState();
}

class _PedidoEntradaDetalheViewState extends State<PedidoEntradaDetalheDesktop> {
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
        return GestureDetector(
            onTap: () {
              // Navigator.pushNamed(
              //     context, '/ordens-entrada/' + pedido[index].idPedidoSaida.toString());
            },
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                    color: (index % 2) == 0 ? Colors.white : Colors.grey.shade50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextComponent(
                                itensPedido[index].idItemPedidoEntrada.toString(),
                              ),
                            ),
                            Expanded(
                                child: TextComponent(
                              itensPedido[index].peca?.id_peca.toString() ?? '',
                            )),
                            Expanded(
                                flex: 2,
                                child: TextComponent(
                                  itensPedido[index].peca?.descricao.toString().capitalize ?? '',
                                )),
                            Expanded(
                                child: TextComponent(
                              itensPedido[index].quantidade.toString(),
                            )),
                            Expanded(
                              child: TextComponent(
                                  itensPedido[index].custo != null ? controller.formatter.format(itensPedido[index].custo) : ''),
                            ),
                            Expanded(
                                child: TextComponent(
                              itensPedido[index].custo != null
                                  ? controller.formatter.format((itensPedido[index].custo! * itensPedido[index].quantidade!))
                                  : '',
                            )),
                            Expanded(
                                child: TextComponent(
                              itensPedido[index].peca?.estoque?.first.endereco.toString() ?? '',
                            )),
                          ],
                        ),

                        // border: Border(
                        //   left: BorderSide(
                        //     color:
                        //         situacao(pedidoController.pedidos[index].dataEmissao!),
                        //     width: 7.0,
                        //   ),
                        // ),
                      ]),
                    ))));
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
      body: Row(
        children: [
          Sidebar(),
          Expanded(
            child: Container(
              color: Colors.white,
              child: controller.carregado
                  ? Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: SingleChildScrollView(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TitleComponent('Ordem de Entrada'),
                              _buildSituacaoPedido(controller.pedidoEntrada.situacao)
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
                                  initialValue: controller.pedidoEntrada.idPedidoEntrada.toString(),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  child: InputComponent(
                                readOnly: true,
                                label: 'CPF/CNPJ',
                                initialValue: controller.pedidoEntrada.asteca?.compEstProd?.first.produto?.fornecedores?.first
                                            .cliente?.cpfCnpj !=
                                        null
                                    ? maskFormatter
                                        .cpfCnpjFormatter(
                                            value: controller.pedidoEntrada.asteca!.compEstProd!.first.produto!.fornecedores!
                                                .first.cliente!.cpfCnpj
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
                              )), //maskFormatter.cpfCnpjFormatter( value: )!.getMaskedText())),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: InputComponent(
                                  readOnly: true,
                                  label: 'Fornecedor',
                                  initialValue: controller
                                          .pedidoEntrada.asteca?.compEstProd?.first.produto?.fornecedores?.first.cliente?.nome
                                          .toString() ??
                                      controller.pedidoEntrada.itensPedidoEntrada?.first.peca?.produtoPeca?.first.produto
                                          ?.fornecedores?.first.cliente?.nome
                                          .toString() ??
                                      '',
                                ),
                              ),
                            ],
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
                                        controller.pedidoEntrada.funcionario!.clienteFunc!.cliente!.nome.toString().capitalize ??
                                            ''),
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
                          SizedBox(
                            height: 8,
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
                                      children: [TitleComponent('Asteca')],
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Obx(
                                () => !controllerPedidoEntrada.carregandoEmail.value
                                    ? ButtonComponent(
                                        color: secundaryColor,
                                        colorHover: secundaryColorHover,
                                        icon: Icon(
                                          Icons.email,
                                          color: Colors.white,
                                        ),
                                        onPressed: () async {
                                          await controllerPedidoEntrada.enviarEmailPedidoEntrada(controller.pedidoEntrada);
                                        },
                                        text: 'Enviar e-mail')
                                    : LoadingComponent(),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              ButtonComponent(
                                icon: Icon(
                                  Icons.wysiwyg_outlined,
                                  color: Colors.white,
                                ),
                                color: secundaryColor,
                                onPressed: () {
                                  Get.toNamed("/astecas/${controller.pedidoEntrada.asteca!.idAsteca}");
                                },
                                text: 'Ver mais',
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
                          Row(
                            children: [
                              Expanded(
                                child: TextComponent(
                                  'Código do item',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [TitleComponent('Itens do pedido')],
                              ),
                              Expanded(
                                  flex: 2,
                                  child: TextComponent(
                                    'Descrição',
                                    fontWeight: FontWeight.bold,
                                  )),
                              Expanded(
                                  child: TextComponent(
                                'Quantidade',
                                fontWeight: FontWeight.bold,
                              )),
                              Expanded(
                                  child: TextComponent(
                                'Valor R\$',
                                fontWeight: FontWeight.bold,
                              )),
                              Expanded(
                                  child: TextComponent(
                                'Subtotal R\$',
                                fontWeight: FontWeight.bold,
                              )),
                              Expanded(
                                  child: TextComponent(
                                'Endereço',
                                fontWeight: FontWeight.bold,
                              )),
                            ],
                          ),
                          Divider(),
                          Container(
                            height: 400,
                            child: ListView.builder(
                              itemCount: controller.pedidoEntrada.itensPedidoEntrada!.length,
                              itemBuilder: (context, index) {
                                return _buildListItem(controller.pedidoEntrada.itensPedidoEntrada!, index, context);
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ButtonComponent(
                                  color: primaryColor,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  text: 'Voltar'),
                              ButtonComponent(
                                  color: secundaryColor,
                                  colorHover: secundaryColorHover,
                                  onPressed: () {
                                    GerarPedidoEntradaPDF(pedidoEntrada: controller.pedidoEntrada).imprimirPDF();
                                  },
                                  text: 'Imprimir')
                            ],
                          )
                        ]),
                      ))
                  : LoadingComponent(),
            ),
          ),
        ],
      ),
    );
  }
}
