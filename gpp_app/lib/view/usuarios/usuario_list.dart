import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/service/perfil_usuario_service.dart';
import '../../shared/components/InputComponent.dart';
import '../../shared/components/LoadingComponent.dart';
import '../../shared/components/PaginacaoComponent.dart';
import '../../shared/components/TextComponent.dart';
import '../../shared/widgets/CardWidget.dart';
import '../../widgets/NavBarWidget.dart';
import '../../widgets/sidebar_widget.dart';

class UsuarioList extends StatelessWidget {
  const UsuarioList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final controller = Get.find<PerfilUsuarioService>();
    final controller = Get.put<PerfilUsuarioService>(PerfilUsuarioService());
    return Scaffold(
      appBar: NavbarWidget(),
      drawer: const Sidebar(),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Expanded(
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
                          controller.listarTodos();
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
              () => controller.carregando.value
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
                                          const TextComponent(
                                            'Código',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            controller.usuarios[index].id
                                                .toString(),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Row(
                                        children: [
                                          const TextComponent(
                                            'Nome',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(controller.usuarios[index].name
                                                  ?.toString() ??
                                              ''),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Row(
                                        children: [
                                         const TextComponent(
                                            'Usuário',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            controller.usuarios[index].username
                                                    ?.toString() ??
                                                '',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      const TextComponent(
                                        'Perfil',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Flexible(
                                        child: Text(
                                          controller.usuarios[index]
                                                  .perfilUsuario?.descricao
                                                  .toString() ??
                                              'Não possui perfil de usuário atribuído',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                       const TextComponent(
                                        'Ações',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.delete<PerfilUsuarioService>();
                                          Get.toNamed('/usuarios/' +
                                              controller.usuarios[index].id
                                                  .toString());
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 4,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(6),
                                            child: Icon(
                                              Icons.visibility_rounded,
                                              color: Colors.white,
                                              size: 10,
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
                  : const LoadingComponent(),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: GetBuilder<PerfilUsuarioService>(
              builder: (_) => PaginacaoComponent(
                total: controller.pagina.getTotal(),
                atual: controller.pagina.getAtual(),
                primeiraPagina: () {
                  controller.pagina.primeira();
                  controller.listarTodos();
                },
                anteriorPagina: () {
                  controller.pagina.anterior();
                  controller.listarTodos();
                },
                proximaPagina: () {
                  controller.pagina.proxima();
                  controller.listarTodos();
                },
                ultimaPagina: () {
                  controller.pagina.ultima();
                  controller.listarTodos();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
