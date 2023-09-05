import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/PaginacaoComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/views/usuarios/controllers/usuario_controller.dart';
import 'package:gpp/src/views/usuarios/controllers/usuario_detalhe_controller.dart';

import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class UsuariosMobile extends StatelessWidget {
  const UsuariosMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UsuarioController2>();

    return Scaffold(
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Usuários',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                          child: InputComponent(
                        hintText: 'Buscar',
                        onFieldSubmitted: (value) {
                          controller.pesquisar = value;
                          controller.buscarUsuarios();
                        },
                      ))
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => !controller.carregando.value
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                        itemCount: controller.usuarios.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: CardWidget(
                              widget: Column(
                                children: [
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          TextComponent(
                                            'Código',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text('${controller.usuarios[index].id.toString()}'),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Row(
                                        children: [
                                          TextComponent(
                                            'RE',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(controller.usuarios[index].uid?.toString() ?? ''),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Row(
                                        children: [
                                          TextComponent(
                                            'Filial',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            controller.usuarios[index].idFilial?.toString() ?? '',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      TextComponent(
                                        'Nome',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Flexible(
                                        child: Text(
                                          controller.usuarios[index].nome.toString().capitalize ?? '',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      TextComponent(
                                        'E-mail',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Flexible(
                                        child: Text(
                                          controller.usuarios[index].email?.toString() ?? '',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      TextComponent(
                                        'Perfil',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Flexible(
                                        child: Text(
                                          controller.usuarios[index].perfilUsuario?.descricao.toString() ??
                                              'Não possui perfil de usuário atribuído',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.delete<UsuarioDetalheController>();

                                          Get.toNamed('/usuarios/' + controller.usuarios[index].id.toString());
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 4,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(6),
                                            child: Icon(
                                              Icons.visibility_rounded,
                                              color: Colors.white,
                                              size: 18,
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
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: GetBuilder<UsuarioController2>(
              builder: (_) => PaginacaoComponent(
                total: controller.pagina.getTotal(),
                atual: controller.pagina.getAtual(),
                primeiraPagina: () {
                  controller.pagina.primeira();
                  controller.buscarUsuarios();
                },
                anteriorPagina: () {
                  controller.pagina.anterior();
                  controller.buscarUsuarios();
                },
                proximaPagina: () {
                  controller.pagina.proxima();
                  controller.buscarUsuarios();
                },
                ultimaPagina: () {
                  controller.pagina.ultima();
                  controller.buscarUsuarios();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
