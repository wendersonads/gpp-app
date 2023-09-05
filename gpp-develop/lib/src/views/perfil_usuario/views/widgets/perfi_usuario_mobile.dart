import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/views/perfil_usuario/controllers/perfil_usuario_controller.dart';
import 'package:gpp/src/views/perfil_usuario/controllers/perfil_usuario_detalhe_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class PerfilUsuarioMobile extends StatelessWidget {
  const PerfilUsuarioMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PerfilUsuarioController>();

    return Scaffold(
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Perfil de Usuários',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(
              height: 16,
            ),
            InputComponent(
              hintText: 'Buscar',
              // onChanged: (value) =>
              //     produtoController.pesquisar = value,
              // onFieldSubmitted: (value) {
              //   produtoController.buscarProdutos();
              // },
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: Obx(
                () => !controller.carregando.value
                    ? Container(
                        child: ListView.builder(
                          itemCount: controller.perfisUsuarios.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: CardWidget(
                                widget: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              TextComponent(
                                                'Código',
                                                fontWeight: FontWeight.bold,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                  '${controller.perfisUsuarios[index].idPerfilUsuario.toString()}'),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            children: [
                                              TextComponent(
                                                'Descrição',
                                                fontWeight: FontWeight.bold,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  controller
                                                          .perfisUsuarios[index]
                                                          .descricao
                                                          .toString()
                                                          .capitalize ??
                                                      '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 24,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.delete<
                                                  PerfilUsuarioDetalheController>();

                                              Get.toNamed('/perfil-usuario/' +
                                                  controller
                                                      .perfisUsuarios[index]
                                                      .idPerfilUsuario
                                                      .toString());
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                child: Icon(
                                                  Icons.visibility_rounded,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () async {
                                              await controller
                                                  .deletarPerfilUsuario(
                                                      controller
                                                          .perfisUsuarios[index]
                                                          .idPerfilUsuario!);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                child: Icon(
                                                  Icons.delete_rounded,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : LoadingComponent(),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonComponent(
                    onPressed: () {
                      Get.toNamed('/perfil-usuario/registrar');
                    },
                    text: 'Adicionar',
                  ),
                ],
              ),
            )
            // Container(
            //   margin:
            //       const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
            //   child: GetBuilder<ProdutoController>(
            //     builder: (_) => PaginacaoComponent(
            //       total: produtoController.pagina.total,
            //       atual: produtoController.pagina.atual,
            //       primeiraPagina: () {
            //         produtoController.pagina.primeira();
            //         produtoController.buscarProdutos();
            //       },
            //       anteriorPagina: () {
            //         produtoController.pagina.anterior();
            //         produtoController.buscarProdutos();
            //       },
            //       proximaPagina: () {
            //         produtoController.pagina.proxima();
            //         produtoController.buscarProdutos();
            //       },
            //       ultimaPagina: () {
            //         produtoController.pagina.ultima();
            //         produtoController.buscarProdutos();
            //       },
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
