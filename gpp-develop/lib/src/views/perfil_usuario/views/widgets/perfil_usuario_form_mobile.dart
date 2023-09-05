import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/perfil_usuario/controllers/perfil_usuario_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class PerfilUsuarioFormMobile extends StatelessWidget {
  const PerfilUsuarioFormMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PerfilUsuarioController>();

    return Scaffold(
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: 32,
                ),
                child: Row(
                  children: [
                    Text(
                      'Cadastrar perfil de usuário',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ],
                ),
              ),
              InputComponent(
                label: 'Descrição',
                hintText: 'Digite a descrição do perfil',
                onSaved: (value) {
                  controller.perfilUsuario.descricao = value;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonComponent(
                      color: primaryColor,
                      onPressed: () {
                        Get.offAllNamed('/perfil-usuario');
                      },
                      text: 'Voltar'),
                  SizedBox(
                    width: 8,
                  ),
                  ButtonComponent(
                      onPressed: () async {
                        controller.formKey.currentState!.save();

                        await controller.criarPerfilUsuario();
                      },
                      text: 'Cadastrar'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
