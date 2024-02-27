import 'package:auth_migration/domain/service/perfil_usuario_detalhe_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/model/perfil_usuario.dart';
import '../../shared/components/ButtonComponent.dart';
import '../../shared/components/DropdownButtonFormFieldComponent.dart';
import '../../shared/components/InputComponent.dart';
import '../../shared/components/LoadingComponent.dart';
import '../../shared/components/Notificacao.dart';
import '../../shared/components/TextComponent.dart';
import '../../shared/components/styles.dart';
import '../../shared/widgets/NavBarWidget.dart';
import '../../widgets/sidebar_widget.dart';

class UsuarioDetalhe extends StatelessWidget {
  const UsuarioDetalhe({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PerfilUsuarioDetalheService>();

    return Scaffold(
      appBar: const NavbarWidget(),
      drawer: const Sidebar(),
      resizeToAvoidBottomInset: false,
      body: Container(
          margin: const EdgeInsets.all(16),
          child: Obx(() => controller.carregandoUsuario.value
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
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: controller.etapa.value == 1
                                                ? secundaryColor
                                                : Colors.grey.shade200,
                                            width: controller.etapa.value == 1
                                                ? 4
                                                : 1))),
                                child: const TextComponent('Dados pessoais'),
                              ),
                            ),
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                controller.etapa(2);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: controller.etapa.value == 2
                                              ? secundaryColor
                                              : Colors.grey.shade200,
                                          width: controller.etapa.value == 2
                                              ? 4
                                              : 1)),
                                ),
                                child: const TextComponent('Perfil de usuário'),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Obx(() => controller.etapa.value == 1
                        ? Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: InputComponent(
                                        label: 'ID',
                                        initialValue: controller
                                            .usuario.value.id
                                            .toString(),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: InputComponent(
                                          label: 'Nome',
                                          initialValue: controller
                                              .usuario.value.name
                                              .toString()),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InputComponent(
                                        label: 'Usuário',
                                        initialValue: controller
                                            .usuario.value.username
                                            .toString(),
                                      ),
                                    ),
                                    Expanded(
                                      child: InputComponent(
                                        label: 'Ativo',
                                        initialValue:
                                            controller.usuario.value.ativo == 1
                                                ? 'Sim'
                                                : 'Não',
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ButtonComponent(
                                        onPressed: () {
                                          Get.offAllNamed('/usuarios');
                                        },
                                        text: 'Voltar'),
                                    const SizedBox(
                                      width: 8,
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        : Container()),
                    Obx(() => controller.etapa.value == 2
                        ? Column(
                            children: [
                              Obx(
                                () => controller.carregandoUsuario.value
                                    ? DropdownButtonFormFieldComponent(
                                        label: 'Perfil de usuário',
                                        color: Colors.black,
                                        hintText: controller.usuario.value
                                                .perfilUsuario?.descricao ??
                                            'Selecione o perfil do usuário',
                                        onChanged: (value) async {
                                          controller.idPerfilUsuario.value =
                                              value.idPerfilUsuario;
                                        },
                                        items: controller.usuarios.map<
                                                DropdownMenuItem<
                                                    PerfilUsuario>>(
                                            (PerfilUsuario value) {
                                          return DropdownMenuItem<
                                              PerfilUsuario>(
                                            value: value,
                                            child:
                                                TextComponent(value.descricao!),
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
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    ButtonComponent(
                                        color: primaryColor,
                                        colorHover: primaryColorHover,
                                        onPressed: () async {
                                          if (await controller
                                              .vincularPerfilUsuario()) {
                                           Get.toNamed('/usuarios');
                                          }
                                        },
                                        text: 'Salvar')
                                  ],
                                ),
                              )
                            ],
                          )
                        : Container()),
                  ],
                )
              : const LoadingComponent())),
    );
  }
}
