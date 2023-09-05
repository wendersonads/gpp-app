import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gpp/src/enums/status_os_enum.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/views/avaria/views/widgets/criacao_produto_avaria_desktop.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/PaginacaoComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/models/avaria/avaria_model.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:gpp/src/views/avaria/controllers/consulta_produto_avaria_controller.dart';

class ConsultaProdutoAvariaDesktop extends StatelessWidget {
  Widget _buildFiltragem(ConsultaProdutoAvariaController controller) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Produtos Avaria',
              style: TextStyle(
                fontSize: 18,
                letterSpacing: 0.20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: InputComponent(
                      hintText: 'Buscar',
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  ButtonComponent(
                    icon: Icon(
                      Icons.tune_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      controller.alternarVisibilidadeFormFiltragem();
                    },
                    text: 'Filtrar',
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      ButtonComponent(
                        color: primaryColor,
                        onPressed: () {
                          Get.offNamed('/avaria/criar/');
                        },
                        text: 'Criar Avaria',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Obx(
          () => Container(
            height: controller.formFiltragemVisivel.value ? null : 0,
            margin: EdgeInsets.symmetric(
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Form(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: InputComponent(
                                label: 'Data inicio',
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 1,
                              child: InputComponent(
                                label: 'Data fim',
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 1,
                              child: InputComponent(
                                label: 'Filial',
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 1,
                              child: InputComponent(
                                label: 'Id produto',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: InputComponent(
                                label: 'Id Avaria',
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 1,
                              child: InputComponent(
                                label: 'Solicitador',
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 1,
                              child: InputComponent(
                                label: 'Situacao',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ButtonComponent(
                              color: vermelhoColor,
                              colorHover: vermelhoColorHover,
                              onPressed: () {},
                              text: 'Limpar',
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            ButtonComponent(
                              onPressed: () {},
                              text: 'Pesquisar',
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListar(ConsultaProdutoAvariaController controller) {
    return Obx(
      () => controller.isLoading.value
          ? LoadingComponent()
          : Expanded(
              child: ListView.builder(
                  itemCount: controller.avarias.length,
                  itemBuilder: (context, index) {
                    AvariaModel avaria = controller.avarias[index];
                    return Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 25, horizontal: 25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              left: BorderSide(
                                color: controller.avarias[index].situacao == 0
                                    ? HexColor('#FF9900')
                                    : controller.avarias[index].situacao == 1
                                        ? HexColor('#00CF80')
                                        : controller.avarias[index].situacao ==
                                                2
                                            ? HexColor('FF0000')
                                            : primaryColor,
                                width: 4,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 0,
                                blurRadius: 2,
                                offset:
                                    Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextComponent(
                                      'Filial',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextComponent(
                                      'Id Produto',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextComponent(
                                      'Cor',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextComponent(
                                      'Solicitador',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextComponent(
                                      'Data Abertura',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextComponent(
                                      'Situacao',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: 28,
                                    width: 10,
                                  ),
                                  // Expanded(
                                  //   child: TextComponent(
                                  //     'Ações',
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Expanded(
                                    child: SelectableText(
                                      avaria.idFilial.toString(),
                                    ),
                                  ),
                                  Expanded(
                                    child: SelectableText(
                                      avaria.idProduto.toString(),
                                    ),
                                  ),
                                  Expanded(
                                    child: SelectableText(
                                      'Cor',
                                    ),
                                  ),
                                  Expanded(
                                    child: SelectableText(
                                      avaria.reSolicitador.toString(),
                                    ),
                                  ),
                                  Expanded(
                                    child: SelectableText(
                                      DateFormat('dd/MM/yyyy')
                                          .format(avaria.dataCria!),
                                    ),
                                  ),
                                  Expanded(
                                    child: SelectableText(
                                      controller.avarias[index].situacao == 0
                                          ? 'Pendente'
                                          : controller.avarias[index]
                                                      .situacao ==
                                                  1
                                              ? 'Aprovada'
                                              : controller.avarias[index]
                                                          .situacao ==
                                                      2
                                                  ? 'Reprovado'
                                                  : '',
                                    ),
                                  ),
                                  // Expanded(
                                  //   flex: 1,
                                  //   child: ButtonComponent(
                                  //     color: HexColor('#4175FC'),
                                  //     onPressed: () {
                                  //       Get.offNamed(
                                  //           '/avaria/detalhes/${controller.avarias[index].idAvaria}');
                                  //     },
                                  //     text: 'Ver mais',
                                  //   ),
                                  // ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConsultaProdutoAvariaController());
    return Scaffold(
      appBar: NavbarWidget(),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        child: Row(
          children: [
            Sidebar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 24,
                  right: 24,
                  left: 24,
                ),
                child: Column(
                  children: [
                    _buildFiltragem(controller),
                    _buildListar(controller),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
