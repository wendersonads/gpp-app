import 'package:flutter/material.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/views/asteca/components/item_menu.dart';
import 'package:gpp/src/views/pecas/cores_list_view.dart';
import 'package:gpp/src/views/pecas/especie_list_view.dart';
import 'package:gpp/src/views/pecas/grupo_list_view.dart';
import 'package:gpp/src/views/pecas/linha_list_view.dart';
import 'package:gpp/src/views/pecas/material_list_view.dart';
import 'package:gpp/src/views/pecas/pecas_list_view.dart';

// ignore: must_be_immutable
class MenuConsultarView extends StatefulWidget {
  int? selected;

  MenuConsultarView({this.selected});

  @override
  _MenuConsultarViewState createState() => _MenuConsultarViewState();
}

class _MenuConsultarViewState extends State<MenuConsultarView> {
  int selected = 1;

  @override
  void initState() {
    if (widget.selected != null) selected = widget.selected!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _pecasMenu(),
        ),
        Padding(padding: EdgeInsets.only(left: 20)),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              _pecasNavigator(),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 20)),
      ],
    );
  }

  _pecasMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: const TitleComponent(
            'Consultas',
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
                  data: 'Peças',
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
                  data: 'Grupo Fabricação',
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
                  data: 'Material Fabricação',
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
                    selected = 5;
                  });
                },
                child: ItemMenu(
                  color:
                      selected == 5 ? Colors.grey.shade50 : Colors.transparent,
                  borderColor:
                      selected == 5 ? secundaryColor : Colors.transparent,
                  data: 'Linha',
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
                    selected = 6;
                  });
                },
                child: ItemMenu(
                  color:
                      selected == 6 ? Colors.grey.shade50 : Colors.transparent,
                  borderColor:
                      selected == 6 ? secundaryColor : Colors.transparent,
                  data: 'Espécie',
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
        return PecasListView();
      case 2:
        return CoresListView();
      case 3:
        return GrupoListView();
      case 4:
        return MaterialListView();
      case 5:
        return LinhaListView();
      case 6:
        return EspecieListView();
    }
  }
}
