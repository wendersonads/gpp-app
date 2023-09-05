import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/PaginacaoComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/views/usuarios/controllers/usuario_controller.dart';
import 'package:gpp/src/views/usuarios/controllers/usuario_detalhe_controller.dart';

import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/button_acao_widget.dart';
import 'package:gpp/src/views/widgets/card_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class UsuariosDesktop extends StatelessWidget {
  const UsuariosDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UsuarioController2>();

    return Scaffold(
      appBar: NavbarWidget(),
      body: Container(
        color: Colors.white,
        child: Row(
          children: [
            Sidebar(),
            Expanded(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Expanded(child: TitleComponent('Usuários')),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: ListView.builder(
                                itemCount: controller.usuarios.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    child: CardWidget(
                                      widget: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    TextComponent(
                                                      'Código do usuário',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  child: TextComponent(
                                                'Registro de empregado (RE)',
                                                fontWeight: FontWeight.bold,
                                              )),
                                              Expanded(
                                                  child: TextComponent(
                                                'Nome',
                                                fontWeight: FontWeight.bold,
                                              )),
                                              Expanded(
                                                  child: TextComponent(
                                                'E-mail',
                                                fontWeight: FontWeight.bold,
                                              )),
                                              Expanded(
                                                  child: TextComponent(
                                                'Perfil do usuário',
                                                fontWeight: FontWeight.bold,
                                              )),
                                              Expanded(
                                                  child: TextComponent(
                                                'Filial',
                                                fontWeight: FontWeight.bold,
                                              )),
                                              Expanded(
                                                  child: TextComponent(
                                                'Ações',
                                                fontWeight: FontWeight.bold,
                                              )),
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    SelectableText(
                                                      '${controller.usuarios[index].id.toString()}',
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  child: SelectableText(
                                                controller.usuarios[index].uid
                                                        ?.toString() ??
                                                    '',
                                              )),
                                              Expanded(
                                                  child: SelectableText(
                                                controller.usuarios[index].nome
                                                        .toString()
                                                        .capitalize ??
                                                    '',
                                              )),
                                              Expanded(
                                                  child: SelectableText(
                                                controller.usuarios[index].email
                                                        ?.toString() ??
                                                    '',
                                              )),
                                              Expanded(
                                                  child: SelectableText(
                                                controller
                                                        .usuarios[index]
                                                        .perfilUsuario
                                                        ?.descricao
                                                        .toString() ??
                                                    'Não possui perfil de usuário atribuído',
                                              )),
                                              Expanded(
                                                  child: SelectableText(
                                                controller.usuarios[index]
                                                        .idFilial
                                                        ?.toString() ??
                                                    'Não possui perfil de usuário atribuído',
                                              )),
                                              Expanded(
                                                child: ButtonAcaoWidget(
                                                  detalhe: () {
                                                    Get.delete<
                                                        UsuarioDetalheController>();

                                                    Get.toNamed('/usuarios/' +
                                                        controller
                                                            .usuarios[index].id
                                                            .toString());
                                                  },
                                                ),
                                              )
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
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
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
            ),
          ],
        ),
      ),
    );
  }
}
