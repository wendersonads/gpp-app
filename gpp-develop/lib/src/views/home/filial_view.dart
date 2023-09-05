import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/filial/empresa_filial_model.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/services/auth.dart';
import '../../controllers/usuario_controller.dart';

class FilialWidget extends StatelessWidget {
  const FilialWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<UsuarioController>();
    final controller = Get.put(UsuarioController());

    if (context.width < 576) {
      return Obx(() => !controller.carregando.value
          ? Container(
              width: 160,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.circular(25)),
              child: DropdownSearch<EmpresaFilialModel?>(
                mode: Mode.MENU,
                showSearchBox: true,
                items: controller.empresaFiliais,
                itemAsString: (EmpresaFilialModel? value) =>
                    value!.id_filial!.toString(),
                onChanged: (value) {
                  setFilial(filial: value);

                  Get.offAllNamed((Get.currentRoute));
                },
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    contentPadding:
                        EdgeInsets.only(top: 5, bottom: 5, left: 10),
                    border: InputBorder.none,
                    labelText: 'Pesquisar',
                    labelStyle: const TextStyle(color: Colors.black),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                dropdownBuilder: (context, value) {
                  return Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Filial ${value!.id_filial}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
                popupItemBuilder: (context, value, verdadeiro) {
                  return Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            "Filial ${value!.id_filial}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                dropdownSearchDecoration: InputDecoration(
                  fillColor: Colors.pinkAccent, // Cor fundo caixa dropdown

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  // labelText: 'Filial',
                  // labelStyle: TextStyle(color: Colors.white),
                ),

                emptyBuilder: (context, value) {
                  return Center(
                      child: TextComponent(
                    'Nenhuma filial encontrada',
                    textAlign: TextAlign.center,
                    color: Colors.grey.shade400,
                  ));
                },

                dropDownButton: const Icon(
                  Icons.expand_more_rounded,
                  color: Colors.white,
                ),
                popupBackgroundColor:
                    Colors.white, // Cor de fundo para caixa de seleção
                showAsSuffixIcons: true,
                selectedItem: getFilial(),
              ),
            )
          : Container());
    }

    return Obx(() => !controller.carregando.value
        ? Container(
            width: 160,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.circular(25)),
            child: DropdownSearch<EmpresaFilialModel?>(
              mode: Mode.MENU,
              showSearchBox: true,
              items: controller.empresaFiliais,
              itemAsString: (EmpresaFilialModel? value) =>
                  value!.id_filial!.toString(),
              onChanged: (value) {
                setFilial(filial: value);

                Get.offAllNamed((Get.currentRoute));
              },
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  contentPadding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                  border: InputBorder.none,
                  labelText: 'Pesquisar',
                  labelStyle: const TextStyle(color: Colors.black),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              dropdownBuilder: (context, value) {
                return Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Filial ${value!.id_filial}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
              popupItemBuilder: (context, value, verdadeiro) {
                return Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          "Filial ${value!.id_filial}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                );
              },
              dropdownSearchDecoration: InputDecoration(
                fillColor: Colors.pinkAccent, // Cor fundo caixa dropdown

                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                // labelText: 'Filial',
                // labelStyle: TextStyle(color: Colors.white),
              ),

              emptyBuilder: (context, value) {
                return Center(
                    child: TextComponent(
                  'Nenhuma filial encontrada',
                  textAlign: TextAlign.center,
                  color: Colors.grey.shade400,
                ));
              },

              dropDownButton: const Icon(
                Icons.expand_more_rounded,
                color: Colors.white,
              ),
              popupBackgroundColor:
                  Colors.white, // Cor de fundo para caixa de seleção
              showAsSuffixIcons: true,
              selectedItem: getFilial(),
            ),
          )
        : Container());
  }
}
