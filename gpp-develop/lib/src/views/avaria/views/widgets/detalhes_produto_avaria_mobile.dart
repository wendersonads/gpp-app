import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/views/avaria/views/controller/detalhes_produto_avaria_controller.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class DetalhesProdutoAvariaMobile extends StatelessWidget {
  final controller = Get.find<DetalhesProdutoAvariaController>();

  Widget _menuAvaria(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(
            top: 16,
            //left: 16,
            right: 16,
          ),
          margin: EdgeInsets.only(
            bottom: 16,
          ),
          child: Text(
            'Cadastro de Avaria',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
              child: InputComponent(
                enable: false,
                label: 'ID Produto/SKU',
                keyboardType: TextInputType.number,
                inputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: InputComponent(
                enable: false,
                label: 'Filial Origem',
                keyboardType: TextInputType.number,
                inputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  margin: EdgeInsets.only(
                    bottom: 10,
                    right: 8,
                  ),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.1),
                      fontSize: 14,
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.1),
                      labelText: 'Cor',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  width: 150,
                  height: 55,
                  margin: EdgeInsets.only(
                    bottom: 10,
                    right: 8,
                  ),
                  child: TextFormField(
                    readOnly: true,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.1),
                      fontSize: 14,
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: InputComponent(
                enable: false,
                label: 'LD Origem',
                keyboardType: TextInputType.number,
                inputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _SliderAvaria(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  'Defeito do produto',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 110, right: 20),
              child: Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Leve',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Médio',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Alto',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Grave',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Amassado:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Slider(
                            min: 0.0,
                            max: 4.0,
                            divisions: 4,
                            value: 1,
                            onChanged: null,
                            activeColor: Color.fromRGBO(4, 4, 145, 1)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Arranhado:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Slider(
                          min: 0.0,
                          max: 4.0,
                          divisions: 4,
                          value: 2,
                          onChanged: null,
                          activeColor: Color.fromRGBO(4, 4, 145, 1),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Quebrado:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Slider(
                            min: 0.0,
                            max: 4.0,
                            divisions: 4,
                            value: 3,
                            onChanged: null,
                            activeColor: Color.fromRGBO(4, 4, 145, 1)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Manchado:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Slider(
                            min: 0.0,
                            max: 4.0,
                            divisions: 4,
                            value: 3,
                            onChanged: null,
                            activeColor: Color.fromRGBO(4, 4, 145, 1)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarWidget(),
      drawer: Sidebar(),
      body: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          child: Obx(
            () {
              return controller.carregandoDados.value
                  ? Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Form(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _menuAvaria(context),
                                  // _SliderAvaria(context),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: LoadingComponent(),
                    );
            },
          )),
    );
  }
}
