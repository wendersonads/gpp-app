import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/inventario/inventario_local_model.dart';
import 'package:gpp/src/models/inventario/inventario_local_peca_model.dart';
import 'package:gpp/src/models/inventario/inventario_local_result_model.dart';
import 'package:gpp/src/models/inventario/inventario_model.dart';
import 'package:gpp/src/models/inventario/inventario_peca_model.dart';
import 'package:gpp/src/repositories/inventario/inventario_local_repository.dart';
import 'package:gpp/src/repositories/inventario/inventario_repository.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';

import '../../../shared/components/ButtonComponent.dart';
import '../../../shared/repositories/styles.dart';
import '../../../utils/notificacao.dart';

class InventarioDetalheController extends GetxController {
  String codigo = '';
  var scrollPosition = 0.0.obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyQuantidade = GlobalKey<FormState>();
  var carregando = false.obs;
  var inventarioPecaPreenchido = false.obs;
  var multiplicar = 1.obs;
  late InventarioLocalModel inventario;
  late InventarioModel? inventarioBuscar;
  var quantidadeMultiplicar = 0;
  var contagemCompleta = true.obs;
  late InventarioRepository inventarioRepository;
  late InventarioLocalRepository inventarioLocalRepository;
  late int id;
  late ScrollController scrollController;

  InventarioDetalheController(id) {
    this.id = id;
    inventarioRepository = new InventarioRepository();
    inventarioLocalRepository = new InventarioLocalRepository();
    inventarioBuscar = new InventarioModel();
    scrollController = ScrollController(initialScrollOffset: scrollPosition.value);
  }

  toScrollPosition() {
    if (scrollController.hasClients) {
      scrollController.animateTo(scrollPosition.value, duration: Duration(seconds: 1), curve: Curves.ease);
    }
  }

  @override
  void onInit() async {
    await buscarInventario();
    scrollController.addListener(() {
      scrollPosition(scrollController.offset);
    });

    super.onInit();
  }

  void ordernarInventarioPeca(String codigo) {
    try {
      // if (inventario == null) return;
      int? index = inventario.pecas.indexWhere((element) => element.idPeca.toString() == codigo);

      if (index != -1) {
        /**
           * Guarda o objeto
           */

        InventarioLocalPecaModel item = inventario.pecas[index];

        /**
       * Realizo a remoção
       */

        inventario.pecas.removeAt(index);

        /**
       * Insere na primeira peça
       */

        inventario.pecas.insert(0, item);
      }
    } finally {
      carregando(false);
    }
  }

  Future<InventarioLocalPecaModel> selecionaPeca(String codigo) async {
    List<InventarioLocalPecaModel> inventarioPeca =
        inventario.pecas.where((element) => element.idPeca.toString() == codigo).toList();

    if (inventarioPeca.isEmpty) {
      await Get.dialog(
        AlertDialog(
          content: Container(
            height: Get.height * .05,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      codigo.isNotEmpty ? 'Peça não encontrada!' : 'Informe um código de peça!',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            ButtonComponent(
              onPressed: () {
                Get.back();
              },
              text: 'Ok',
            ),
          ],
        ),
      );
    }

    /**
     * Verifica se existe mais de uma peça com o mesmo identificador no inventário
     */
    if (inventarioPeca.length == 1) {
      if (multiplicar == 0) {
        await Get.dialog(
          AlertDialog(
            content: Container(
              height: Get.height * .2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Form(
                      key: formKeyQuantidade,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Expanded(
                          child: InputComponent(
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            keyboardType: TextInputType.number,
                            label: 'Quantidade',
                            hintText: 'Informe a quantidade',
                            onFieldSubmitted: (value) {
                              quantidadeMultiplicar = int.parse(value);
                              Get.back();
                            },
                            onSaved: (value) {
                              quantidadeMultiplicar = int.parse(value);
                            },
                          ),
                        )
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ButtonComponent(
                            color: vermelhoColor,
                            colorHover: vermelhoColorHover,
                            onPressed: () {
                              Get.back();
                            },
                            text: 'Cancelar',
                          ),
                          Padding(padding: EdgeInsets.only(right: 8)),
                          ButtonComponent(
                            onPressed: () async {
                              if (formKeyQuantidade.currentState!.validate()) {
                                formKeyQuantidade.currentState!.save();
                                Get.back();
                              }
                            },
                            text: 'Alterar',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );

        /**
         * Realiza a multiplicação
         */
        inventarioPeca.first.quantidadeContada = quantidadeMultiplicar;

        return inventarioPeca.first;
      }
    }
    inventarioPeca.first.addQuantidadeContada = 1;

    return inventarioPeca.first;
  }

  void biparPeca(String codigo) async {
    inventarioPecaPreenchido(false);
    try {
      InventarioLocalPecaModel inventarioPeca = await selecionaPeca(codigo);
      if (inventarioPeca != null) {
        inventario = inventarioLocalRepository.updatePeca(idInventario: id, peca: inventarioPeca);
        inventarioPecaPreenchido(true);
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      if (inventarioPecaPreenchido.value) {
        await buscarInventario();
        ordernarInventarioPeca(codigo);
      }
    }
  }

  ajustarPeca(InventarioLocalPecaModel inventarioPeca) async {
    try {
      carregando(true);

      inventario = inventarioLocalRepository.updatePeca(idInventario: id, peca: inventarioPeca);
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
      await buscarInventario();
      //NAO REMOVER O NULL CHECK. SERVIDOR DEPENDE DESTE NULL CHECK
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        toScrollPosition();
      });
    }
  }

  buscarInventario() {
    try {
      carregando(true);

      // inventario = await inventarioRepository.buscarInventario(this.id);
      inventario = inventarioLocalRepository.getInventarioLocal(idInventario: id)!;
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
      //verificaContagemCompleta();
    }
  }

  verificaContagemCompleta() {
    List<InventarioLocalPecaModel> verificaInventario = inventario.pecas
        .where((element) =>
            element.quantidadeContada == 0 &&
            element.quantidadeContada != (element.quantidadeDisponivel + element.quantidadeReservada))
        .toList();

    if (verificaInventario.length > 0) {
      contagemCompleta(true);
    } else {
      contagemCompleta(false);
    }
  }

  Future<void> cancelarInventario() async {
    try {
      if (await Notificacao.confirmacao('Deseja excluir este inventário ? pressione sim ou não para cancelar')) {
        if (await inventarioRepository.cancelarInventario(id)) {
          Notificacao.snackBar('Inventário cancelado!', tipoNotificacao: TipoNotificacaoEnum.sucesso);
          await Get.offAllNamed('/inventario');
        }
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    }
  }

  Future<void> finalizarInventario() async {
    try {
      carregando(true);
      await verificaContagemCompleta();
      contagemCompleta.value ? await confirmacaoFinalizacao() : null;
      if (await Notificacao.confirmacao('Você deseja realizar o ajuste do estoque, pressione sim ou não para cancelar')) {
        if (await inventarioRepository.finalizarInventario(
          idInventario: id,
          inventario: InventarioLocalResultModel.fromInventarioLocal(
            inventarioLocalModel: inventario,
          ),
        )) {
          Notificacao.snackBar('Inventário finalizado!', tipoNotificacao: TipoNotificacaoEnum.sucesso);
          Get.offAllNamed('/inventario');
        }
      } else {
        contagemCompleta(true);
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
    }
  }

  confirmacaoFinalizacao() async {
    return Get.dialog(
      AlertDialog(
        content: Container(
          height: Get.height * .30,
          // padding: EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning, color: vermelhoColorHover, size: 50),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Flexible(
                child: Text(
                  'Existem peças que estão com a quantidade disponível acima de 0, e a quantidade bipada é 0, isso pode gerar reajustes indevidos para o saldo disponível igual a 0. \n \nDeseja realmente finalizar esse inventário ?',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
        actions: [
          ButtonComponent(
            onPressed: () {
              Get.back();
            },
            color: primaryColor,
            text: 'Confirmar',
          ),
        ],
      ),
    );
  }
}
