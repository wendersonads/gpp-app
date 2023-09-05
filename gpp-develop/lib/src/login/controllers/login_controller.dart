import 'dart:convert';

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/models/AutenticacaoModel.dart';
import 'package:gpp/src/models/user_model.dart';
import 'package:gpp/src/shared/services/auth.dart';
import 'package:gpp/src/utils/notificacao.dart';

import '../../repositories/AutenticacaoRepository.dart';

class LoginController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var exibirSenha = false.obs;
  var salvaLogin = false.obs;
  late AutenticacaoRepository autenticacaoRepository;
  late AutenticacaoModel autenticacao;
  late FocusNode loginFocus;
  var carregando = false.obs;
  TextEditingController controllerRe = TextEditingController();
  TextEditingController controllerSenha = TextEditingController();

  LoginController() {
    autenticacaoRepository = AutenticacaoRepository();
    autenticacao = AutenticacaoModel();
    loginFocus = FocusNode();
  }

  @override
  void onClose() {
    loginFocus.dispose();
    super.onClose();
  }

  @override
  void onInit() async {
    await recuperaDadosLogin();
    super.onInit();
  }

  login() async {
    try {
      carregando(true);
      if (await autenticacaoRepository.login(autenticacao)) {
        // Obtém o usuário que acabou de logar
        UsuarioModel usuarioLogado = getUsuario();
        // Cria uma lista que irá salvar as telas permitidas para o usuário
        List<String> telasPermitidas = [];

        // Itera sobre as funcionalidades do usuário
        usuarioLogado.perfilUsuario?.funcionalidades?.forEach((funcionalidade) {
          // Verifica se a funcionalidade está ativa
          if (funcionalidade.situacao!) {
            // Itera sobre as subfuncionalidades do usuário
            funcionalidade.subFuncionalidades?.forEach((subFuncionalidade) {
              // Verifica se a subfuncionalidade está ativa
              if (subFuncionalidade.situacao!) {
                // Adiciona a rota da subfuncionalidade na lista de telas permitidas
                telasPermitidas.add(subFuncionalidade.rota!);
              }
            });
          }
        });

        if (telasPermitidas.isEmpty) {
          // Se o usuário não tem nenhuma tela permitida, então ele ainda possui acesso ao GPP
          throw 'O usuário informado ainda não possui acesso ao GPP.';
        } else if (telasPermitidas.contains('/dashboard')) {
          // Se o usuário possui acesso a Dashboard, então ele será redirecionado para ela
          Get.offAllNamed('/dashboard');
        } else {
          // Se o usuário não possui acesso a Dashboard, então ele será redirecionado para a tela que ele tem permissão
          Get.offAllNamed(telasPermitidas[0]);
        }
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        Notificacao.snackBar(
            'Não foi possível conectar com o servidor, tente novamente.',
            tipoNotificacao: TipoNotificacaoEnum.error);
      } else {
        Notificacao.snackBar(e.toString(),
            tipoNotificacao: TipoNotificacaoEnum.error);
      }
    } finally {
      carregando(false);
      update();
    }
  }

  salvarLogin() async {
    if (controllerRe.text.isNotEmpty && controllerSenha.text.isNotEmpty) {
      EncryptedSharedPreferences encrypPrefs =
          await EncryptedSharedPreferences(mode: AESMode.cfb64);
      await encrypPrefs.setString('re', controllerRe.text).then((bool success) {
        if (success) {
        } else {}
      });

      await encrypPrefs
          .setString('senha', controllerSenha.text)
          .then((bool success) {
        if (success) {
        } else {}
      });
    }
  }

  removeLoginSalvo() async {
    EncryptedSharedPreferences encrypPrefs =
        await EncryptedSharedPreferences(mode: AESMode.cfb64);

    await encrypPrefs.remove('re');
    await encrypPrefs.remove('senha');
  }

  Future<String?> buscarReSalvo() async {
    EncryptedSharedPreferences encrypPrefs =
        await EncryptedSharedPreferences(mode: AESMode.cfb64);
    return await encrypPrefs.getString('re');
  }

  Future<String?> buscarSenhaSalva() async {
    EncryptedSharedPreferences encrypPrefs =
        await EncryptedSharedPreferences(mode: AESMode.cfb64);
    return await encrypPrefs.getString('senha');
  }

  Future<bool> validaReSenhaSalvos() async {
    EncryptedSharedPreferences encrypPrefs =
        await EncryptedSharedPreferences(mode: AESMode.cfb64);

    bool validaRE = false;
    bool validaSenha = false;
    await encrypPrefs.getString('re').then((value) {
      if (value.isNotEmpty) {
        validaRE = true;
      }
    });
    await encrypPrefs.getString('senha').then((value) {
      if (value.isNotEmpty) {
        validaSenha = true;
      }
    });

    if (validaRE && validaSenha) {
      return true;
    } else {
      return false;
    }
  }

  recuperaDadosLogin() async {
    if (await validaReSenhaSalvos()) {
      carregando(true);
      try {
        controllerRe.text = await buscarReSalvo() ?? '';
        controllerSenha.text = await buscarSenhaSalva() ?? '';

        autenticacao.id = controllerRe.text;
        autenticacao.senha = controllerSenha.text;

        await Future.delayed(Duration(milliseconds: 1));
      } catch (e) {
      } finally {
        carregando(false);
        update();
      }
    }
  }
}
