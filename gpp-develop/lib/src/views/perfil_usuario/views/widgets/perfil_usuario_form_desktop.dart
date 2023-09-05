import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/views/perfil_usuario/controllers/perfil_usuario_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class PerfilUsuarioFormDesktop extends StatelessWidget {
  const PerfilUsuarioFormDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PerfilUsuarioController>();

    return Scaffold(
      appBar: NavbarWidget(),
      body: Container(
        color: Colors.white,
        child: Row(
          children: [
            Sidebar(),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(24),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        child: Row(children: [TitleComponent('Cadastrar perfil de usuário')]),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InputComponent(
                              label: 'Descrição',
                              hintText: 'Digite a descrição do perfil',
                              onSaved: (value) {
                                controller.perfilUsuario.descricao = value;
                              },
                            ),
                          ),
                          Expanded(child: Container()),
                          Expanded(child: Container())
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          ButtonComponent(
                              onPressed: () async {
                                controller.formKey.currentState!.save();

                                await controller.criarPerfilUsuario();
                              },
                              text: 'Cadastrar'),
                          Expanded(child: Container()),
                          Expanded(child: Container())
                        ]),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
