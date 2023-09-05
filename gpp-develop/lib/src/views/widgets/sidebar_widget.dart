import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/subfuncionalidade.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/shared/services/auth.dart';

import '../../../main.dart';
import '../../controllers/usuario_controller.dart';
import '../../shared/components/TextComponent.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UsuarioController());

    return Container(
      width: 220,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          children: [
            context.width < 576
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'GPP',
                          style: textStyleTitulo,
                        ),
                        TextComponent('Versão: ${info.version}', fontSize: 12, color: Colors.grey.shade400)
                      ],
                    ),
                  )
                : Container(),
            // context.width < 576
            //     ? Container(
            //         padding: EdgeInsets.symmetric(vertical: 16),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: [
            //             Container(
            //               height: 70,
            //               width: 70,
            //               child: ClipRRect(
            //                 borderRadius: BorderRadius.circular(50),
            //                 child: Image.network(
            //                     'https://as1.ftcdn.net/v2/jpg/01/71/25/36/1000_F_171253635_8svqUJc0BnLUtrUOP5yOMEwFwA8SZayX.jpg'),
            //               ),
            //             )
            //           ],
            //         ),
            //       )
            //     : Container(),
            context.width < 576 ? Divider() : Container(),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: getUsuario().perfilUsuario != null
                        ? Container(
                            child: Column(
                              children: getUsuario().perfilUsuario!.funcionalidades!.map((e) {
                                if (controller.verificarSubfuncionalidade(e.subFuncionalidades!)) {
                                  return ItemSideBar(e.nome ?? '', IconData(int.parse(e.icone!), fontFamily: 'MaterialIcons'),
                                      e.subFuncionalidades ?? []);
                                }

                                return Container();
                              }).toList(),
                            ),
                          )
                        : Container()),
              ),
            ),
            FooterSidebar()
          ],
        ),
      ),
    );
  }
}

class FooterSidebar extends StatelessWidget {
  const FooterSidebar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AvatarWidget(),
          SizedBox(
            width: 16,
          ),
          Flexible(
            child: TextComponent(
              '${getUsuario().nome!.split(' ').first} ${getUsuario().nome!.split(' ').last}',
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
              onPressed: () {
                logout();
                Get.offAllNamed('/login');
              },
              icon: Icon(Icons.logout_rounded))
        ],
      ),
    );
  }
}

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
          height: 40,
          width: 40,
          color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
          child: Center(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextComponent(
                '${getUsuario().nome!.split(' ').first[0].toUpperCase()}',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              TextComponent(
                '${getUsuario().nome!.split(' ').last[0].toUpperCase()}',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ],
          ))),
    );
  }
}

class ItemSideBar extends StatefulWidget {
  final String label;
  final IconData icon;
  final List<SubFuncionalidadeModel> subFuncionalidades;
  const ItemSideBar(
    this.label,
    this.icon,
    this.subFuncionalidades, {
    Key? key,
  }) : super(key: key);

  @override
  State<ItemSideBar> createState() => _ItemSideBarState();
}

class _ItemSideBarState extends State<ItemSideBar> {
  bool expandido = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: (() => setState(() {
                  expandido = !expandido;
                })),
            child: Container(
              child: Row(
                children: [
                  Icon(widget.icon),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    widget.label,
                    style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.20),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            height: expandido ? null : 0,
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 200),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: widget.subFuncionalidades.map((e) {
                  if (GetPlatform.isMobile && e.mobile!) {
                    return SubItemSidebar(e.nome ?? '', e.rota ?? '');
                  } else if (GetPlatform.isWeb && e.web!) {
                    return SubItemSidebar(e.nome ?? '', e.rota ?? '');
                  } else {
                    return Container();
                  }
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubItemSidebar extends StatefulWidget {
  final String label;
  final String rota;
  const SubItemSidebar(
    this.label,
    this.rota, {
    Key? key,
  }) : super(key: key);

  @override
  State<SubItemSidebar> createState() => _SubItemSidebarState();
}

class _SubItemSidebarState extends State<SubItemSidebar> {
  bool onHover = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.offAllNamed(widget.rota);
      },
      child: MouseRegion(
        onHover: (value) => setState(() {
          onHover = true;
        }),
        onExit: (value) => setState(() {
          onHover = false;
        }),
        child: Container(
          decoration:
              BoxDecoration(color: onHover ? Colors.grey.shade200 : Colors.transparent, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    widget.label,
                    style: TextStyle(fontWeight: FontWeight.w500, fontStyle: FontStyle.normal, fontSize: 14, letterSpacing: 0.15),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
