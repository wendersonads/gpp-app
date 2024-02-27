import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'styles.dart';
import 'TextButtonComponent.dart';
import 'TextComponent.dart';

class Notificacao {
  static Future<bool> confirmacao(String mensagem) async {
    return await Get.dialog(AlertDialog(
          title: TextComponent(
            'Confirmação',
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          content: TextComponent(
            mensagem,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.normal,
          ),
          actions: <Widget>[
            Container(
              width: Get.width * 0.40,
              height: Get.height * 0.09,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButtonComponent(
                        onPressed: () {
                          Get.back(result: false);
                        },
                        text: 'Não',
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      TextButtonComponent(
                          onPressed: () {
                            Get.back(result: true);
                          },
                          text: 'Sim')
                    ],
                  )
                ],
              ),
            )
          ],
        )) ??
        false;
  }

  static void snackBar(String mensagem,
      {TipoNotificacaoEnum? tipoNotificacao}) {
    if (Get.width < 576) {
      Get.snackbar('Mensagem', mensagem,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: tipoNotificacaoColor(tipoNotificacao),
          borderRadius: 5,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
          maxWidth: Get.width * 0.9);
    } else {
      Get.snackbar('Mensagem', mensagem,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: tipoNotificacaoColor(tipoNotificacao),
          borderRadius: 5,
          margin: EdgeInsets.only(left: Get.width * 0.8, bottom: 20, right: 20),
          maxWidth: Get.width * 0.6);
    }
  }

  static tipoNotificacaoColor(value) {
    switch (value) {
      case TipoNotificacaoEnum.error:
        return Colors.redAccent;
      case TipoNotificacaoEnum.sucesso:
        {
          return secundaryColor;
        }
      default:
        return primaryColor;
    }
  }
}

enum TipoNotificacaoEnum { error, sucesso }
