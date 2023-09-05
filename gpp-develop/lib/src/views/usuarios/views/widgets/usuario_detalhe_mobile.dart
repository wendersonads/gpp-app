import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/models/perfil_usuario_model.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/DropdownButtonFormFieldComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/usuarios/controllers/usuario_detalhe_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class UsuarioDetalheMobile extends StatelessWidget {
  const UsuarioDetalheMobile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UsuarioDetalheController>();

    return Scaffold(
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      resizeToAvoidBottomInset: false,
      body: Container(
          margin: const EdgeInsets.all(16),
          child: Obx(() => !controller.carregandoUsuario.value
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Usuário',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 32),
                      child: Row(
                        children: [
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                controller.etapa(1);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: controller.etapa == 1
                                                ? secundaryColor
                                                : Colors.grey.shade200,
                                            width: controller.etapa == 1
                                                ? 4
                                                : 1))),
                                child: TextComponent('Dados pessoais'),
                              ),
                            ),
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                controller.etapa(2);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: controller.etapa == 2
                                              ? secundaryColor
                                              : Colors.grey.shade200,
                                          width:
                                              controller.etapa == 2 ? 4 : 1)),
                                ),
                                child: TextComponent('Perfil de usuário'),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Obx(() => controller.etapa == 1
                        ? Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: InputComponent(
                                        label: 'Código',
                                        initialValue:
                                            controller.usuario.id.toString(),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: InputComponent(
                                        label: 'RE',
                                        initialValue:
                                            controller.usuario.uid.toString(),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: InputComponent(
                                          label: 'Filial',
                                          initialValue: controller
                                              .usuario.idFilial
                                              .toString()),
                                    ),
                                  ],
                                ),
                                InputComponent(
                                  label: 'E-mail',
                                  initialValue:
                                      controller.usuario.email.toString(),
                                ),
                                InputComponent(
                                  label: 'Nome',
                                  initialValue: controller.usuario.nome
                                      .toString()
                                      .capitalize,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ButtonComponent(
                                        onPressed: () {
                                          Get.offAllNamed('/usuarios');
                                        },
                                        text: 'Voltar'),
                                    SizedBox(
                                      width: 8,
                                    )
                                    // ButtonComponent(
                                    //     color: primaryColor,
                                    //     colorHover: primaryColorHover,
                                    //     onPressed: () {
                                    //       controller
                                    //           .vincularPerfilUsuario(
                                    //               controller
                                    //                   .selecaoPerfilUsuario);
                                    //     },
                                    //     text: 'Salvar')
                                  ],
                                )
                              ],
                            ),
                          )
                        : Container()),
                    Obx(() => controller.etapa == 2
                        ? Container(
                            child: Column(
                              children: [
                                Obx(
                                  () => !controller
                                          .carregandoPerfisUsuario.value
                                      ? DropdownButtonFormFieldComponent(
                                          label: 'Perfil de usuário',
                                          color: Colors.black,
                                          hintText: controller.usuario
                                                  .perfilUsuario?.descricao ??
                                              'Selecione o perfil do usuário',
                                          onChanged: (value) async {
                                            controller.selecaoPerfilUsuario =
                                                value;
                                          },
                                          items: controller.perfisUsuario.map<
                                                  DropdownMenuItem<
                                                      PerfilUsuarioModel>>(
                                              (PerfilUsuarioModel value) {
                                            return DropdownMenuItem<
                                                PerfilUsuarioModel>(
                                              value: value,
                                              child: TextComponent(
                                                  value.descricao!),
                                            );
                                          }).toList(),
                                        )
                                      : Container(),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 8,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ButtonComponent(
                                          onPressed: () {
                                            Get.offAllNamed('/usuarios');
                                          },
                                          text: 'Voltar'),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      ButtonComponent(
                                          color: primaryColor,
                                          colorHover: primaryColorHover,
                                          onPressed: () {
                                            controller.vincularPerfilUsuario(
                                                controller
                                                    .selecaoPerfilUsuario);
                                          },
                                          text: 'Salvar')
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container()),
                  ],
                )
              : LoadingComponent())),
    );
  }
}
