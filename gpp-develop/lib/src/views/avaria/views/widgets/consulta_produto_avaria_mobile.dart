import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/avaria/avaria_model.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:gpp/src/views/avaria/controllers/consulta_produto_avaria_controller.dart';

class ConsultaProdutoAvariaMobile extends StatelessWidget {
  Widget _buildFiltragem(ConsultaProdutoAvariaController controller) {
    return Column(
      children: [
        Text(
          'Produtos Avaria',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
                child: InputComponent(
              hintText: 'Buscar',
            )),
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
            )
          ],
        ),
        Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: ButtonComponent(
                    color: primaryColor,
                    onPressed: () {
                      Get.offNamed('/avaria/criar');
                    },
                    text: 'Cadastrar Avaria',
                  ),
                ),
              ],
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
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: InputComponent(
                                label: 'Solicitador',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
          ),
        )
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
                        padding:
                            EdgeInsets.symmetric(vertical: 25, horizontal: 25),
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
                                width: 4),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    TextComponent(
                                      'Filial',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      avaria.idFilial.toString(),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    TextComponent(
                                      'Id Produto',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      avaria.idProduto.toString(),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    TextComponent(
                                      'ID',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      avaria.idAvaria.toString(),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    TextComponent(
                                      'Solicitador',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(width: 10),
                                    SelectableText(
                                      avaria.reSolicitador.toString(),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 100,
                                      // child: ButtonComponent(

                                      //   color: HexColor('#4175FC'),
                                      //   onPressed: () {
                                      //     Get.offNamed(
                                      //         '/avaria/detalhes/${controller.avarias[index].idAvaria}');
                                      //   },
                                      //   text: 'Ver mais',
                                      // ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    TextComponent(
                                      'Cor',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(width: 10),
                                    SelectableText(
                                      'SEM COR',
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    TextComponent(
                                      'Data Abertura',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      DateFormat('dd/MM/yyyy')
                                          .format(avaria.dataCria!),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 22),
                                Row(
                                  children: [
                                    Container(
                                      child: TextComponent(
                                        'Situação',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 100,
                                      child: ButtonComponent(
                                        color: controller
                                                    .avarias[index].situacao ==
                                                0
                                            ? HexColor('#FF9900')
                                            : controller.avarias[index]
                                                        .situacao ==
                                                    1
                                                ? HexColor('#00CF80')
                                                : controller.avarias[index]
                                                            .situacao ==
                                                        2
                                                    ? HexColor('FF0000')
                                                    : primaryColor,
                                        onPressed: () {},
                                        text: controller
                                                    .avarias[index].situacao ==
                                                0
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
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConsultaProdutoAvariaController());
    return Scaffold(
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        child: Column(
          children: [
            _buildFiltragem(controller),
            _buildListar(controller),
          ],
        ),
      ),
    );
  }
}
