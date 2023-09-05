// ignore_for_file: must_be_immutable, unused_element

import 'package:flutter/material.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/asteca/components/item_menu.dart';
import 'package:gpp/src/views/peca/views/peca_cadastrar_view.dart';
import 'package:gpp/src/views/peca/views/widgets/peca_cadastrar_view_desktop.dart';
import 'package:gpp/src/views/peca/views/widgets/peca_cadastrar_view_mobile.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

import 'cores_detail_view.dart';
import 'linha_detail_view.dart';
import 'material_detail_view.dart';

class MenuCadastrarView extends StatefulWidget {
  int? idProduto;
  MenuCadastrarView({this.idProduto, Key? key}) : super(key: key);

  @override
  _MenuCadastrarViewState createState() => _MenuCadastrarViewState();
}

class _MenuCadastrarViewState extends State<MenuCadastrarView> {
  @override
  void initState() {
    super.initState();
  }

  int selected = 1;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    if (Dispositivo.mobile(media.size.width)) {
      return PecaCadastrarViewMobile(
        idProduto: widget.idProduto,
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: NavbarWidget(),
        body: Row(
          children: [
            Expanded(child: Sidebar()),
            Expanded(
                flex: 4,
                child: PecaCadastrarViewDesktop(idProduto: widget.idProduto)),
          ],
        ),
      );
    }
  }

  _pecasMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: const TitleComponent(
            'Cadastros',
          ),
        ),
        Divider(),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selected = 1;
                  });
                },
                child: ItemMenu(
                  color:
                      selected == 1 ? Colors.grey.shade50 : Colors.transparent,
                  borderColor:
                      selected == 1 ? secundaryColor : Colors.transparent,
                  data: 'Peça',
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selected = 2;
                  });
                },
                child: ItemMenu(
                  color:
                      selected == 2 ? Colors.grey.shade50 : Colors.transparent,
                  borderColor:
                      selected == 2 ? secundaryColor : Colors.transparent,
                  data: 'Cores',
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selected = 3;
                  });
                },
                child: ItemMenu(
                  color:
                      selected == 3 ? Colors.grey.shade50 : Colors.transparent,
                  borderColor:
                      selected == 3 ? secundaryColor : Colors.transparent,
                  data: 'Fabricação',
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selected = 4;
                  });
                },
                child: ItemMenu(
                  color:
                      selected == 4 ? Colors.grey.shade50 : Colors.transparent,
                  borderColor:
                      selected == 4 ? secundaryColor : Colors.transparent,
                  data: 'Linha e Espécie',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _pecasNavigator() {
    switch (selected) {
      case 1:
        return PecaCadastrarView(idProduto: widget.idProduto);
      case 2:
        return CoresDetailView();
      case 3:
        return MaterialDetailView();
      case 4:
        return EspecieDetailView();
    }
  }
}
