import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gpp/src/login/controllers/login_controller.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/CheckboxComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/shared/services/auth.dart';
import 'package:gpp/src/utils/dispositivo.dart';

import '../../../main.dart';
import '../../shared/components/TitleComponent.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // rememeber to import shared_preferences: ^0.5.4+8

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    if (Dispositivo.mobile(context.width)) {
      return LoginMobile(controller: controller);
    } else if (Dispositivo.tablet(context.width)) {
      return LoginTablet(controller: controller);
    } else {
      return LoginDesktop(controller: controller);
    }
  }
}

class LoginMobile extends StatelessWidget {
  const LoginMobile({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    controller.salvaLogin.value = getCheckSalvaLogin();

    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextComponent(
                      'GPP',
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      width: 160,
                      child: Image.asset('lib/src/shared/assets/brand.png'),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Obx(
                    () => !controller.carregando.value
                        ? Form(
                            key: controller.formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 24),
                                        child: TitleComponent('Login')),
                                    InputComponent(
                                      label: "RE",
                                      controller: controller.controllerRe,
                                      initialValue:
                                          controller.controllerRe.text,
                                      inputFormatter: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(19),
                                      ],
                                      onChanged: (value) {
                                        controller.autenticacao.id = value;
                                        controller.controllerRe.text = value;
                                      },
                                      hintText: "Digite seu RE",
                                      prefixIcon: Icon(Icons.account_box),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Obx(
                                      () => InputComponent(
                                        label: "Senha",
                                        controller: controller.controllerSenha,
                                        initialValue:
                                            controller.controllerSenha.text,
                                        maxLines: 1,
                                        obscureText:
                                            !controller.exibirSenha.value,
                                        onFieldSubmitted: (value) {
                                          if (controller.formKey.currentState!
                                              .validate()) {
                                            controller.formKey.currentState!
                                                .reset();
                                            controller.formKey.currentState!
                                                .save();
                                            controller.login();

                                            if (controller.salvaLogin.value) {
                                              controller.salvarLogin();
                                            } else {
                                              controller.removeLoginSalvo();
                                            }
                                          }
                                        },
                                        onChanged: (value) {
                                          controller.autenticacao.senha = value;
                                          controller.controllerSenha.text =
                                              value;
                                        },
                                        hintText: "Digite sua senha",
                                        prefixIcon: Icon(Icons.lock),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            controller.exibirSenha(
                                                !controller.exibirSenha.value);
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Icon(
                                              Icons.visibility,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Salvar Login',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ), // Commit
                                        CheckboxComponent(
                                          value: controller.salvaLogin.value,
                                          onChanged: (value) async {
                                            setCheckSalvaLogin(
                                                !controller.salvaLogin.value);
                                            controller.salvaLogin.value =
                                                getCheckSalvaLogin();
                                          },
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 24),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ButtonComponent(
                                              color: secundaryColor,
                                              colorHover: secundaryColorHover,
                                              onPressed: () {
                                                controller.formKey.currentState!
                                                    .reset();
                                                controller.formKey.currentState!
                                                    .save();
                                                controller.login();

                                                if (controller
                                                    .salvaLogin.value) {
                                                  controller.salvarLogin();
                                                } else {
                                                  controller.removeLoginSalvo();
                                                }
                                              },
                                              text: "Entrar",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(top: 64),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextComponent(
                                                'Versão: ${info.version}',
                                                fontSize: 12,
                                                color: Colors.grey.shade400)
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : LoadingComponent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginTablet extends StatelessWidget {
  const LoginTablet({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    controller.salvaLogin.value = getCheckSalvaLogin();

    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextComponent(
                    'GPP',
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(
                    width: 160,
                    child: Image.asset('lib/src/shared/assets/brand.png'),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Obx(
                  () => !controller.carregando.value
                      ? Form(
                          key: controller.formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 24),
                                      child: TitleComponent('Login')),
                                  InputComponent(
                                    label: "RE",
                                    controller: controller.controllerRe,
                                    initialValue: controller.controllerRe.text,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    onChanged: (value) {
                                      controller.autenticacao.id = value;
                                      controller.controllerRe.text = value;
                                    },
                                    hintText: "Digite seu RE",
                                    prefixIcon: Icon(Icons.account_box),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Obx(
                                    () => InputComponent(
                                      label: "Senha",
                                      controller: controller.controllerSenha,
                                      initialValue:
                                          controller.controllerSenha.text,
                                      maxLines: 1,
                                      obscureText:
                                          !controller.exibirSenha.value,
                                      onFieldSubmitted: (value) {
                                        controller.formKey.currentState!
                                            .reset();
                                        controller.formKey.currentState!.save();
                                        controller.login();

                                        if (controller.salvaLogin.value) {
                                          controller.salvarLogin();
                                        } else {
                                          controller.removeLoginSalvo();
                                        }
                                      },
                                      onChanged: (value) {
                                        controller.autenticacao.senha = value;
                                        controller.controllerSenha.text = value;
                                      },
                                      hintText: "Digite sua senha",
                                      prefixIcon: Icon(Icons.lock),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          controller.exibirSenha(
                                              !controller.exibirSenha.value);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Icon(
                                            !controller.exibirSenha.value
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Salvar Login',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      CheckboxComponent(
                                        value: controller.salvaLogin.value,
                                        onChanged: (value) async {
                                          setCheckSalvaLogin(
                                              !controller.salvaLogin.value);
                                          controller.salvaLogin.value =
                                              getCheckSalvaLogin();
                                        },
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 24),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ButtonComponent(
                                              color: secundaryColor,
                                              colorHover: secundaryColorHover,
                                              onPressed: () {
                                                controller.formKey.currentState!
                                                    .reset();
                                                controller.formKey.currentState!
                                                    .save();
                                                controller.login();

                                                if (controller
                                                    .salvaLogin.value) {
                                                  controller.salvarLogin();
                                                } else {
                                                  controller.removeLoginSalvo();
                                                }
                                              },
                                              text: "Entrar"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(top: 64),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextComponent(
                                              'Versão: ${info.version}',
                                              fontSize: 12,
                                              color: Colors.grey.shade400)
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ),
                        )
                      : LoadingComponent(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LoginDesktop extends StatelessWidget {
  LoginDesktop({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    controller.salvaLogin.value = getCheckSalvaLogin();

    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 120),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextComponent(
                    'GPP',
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(
                    width: 160,
                    child: Image.asset('lib/src/shared/assets/brand.png'),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 440,
                      margin: EdgeInsets.only(right: 48),
                      child: TextComponent(
                        'Bem vindo ao Gerenciamento de Peças e Pedidos',
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 340,
                      height: 460,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Obx(
                        () => !controller.carregando.value
                            ? Form(
                                key: controller.formKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ScrollConfiguration(
                                    behavior: ScrollConfiguration.of(context)
                                        .copyWith(scrollbars: false),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 24),
                                              child: SelectableText(
                                                'Login',
                                                style: textStyleTitulo,
                                              )),
                                          InputComponent(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Esse campo é obrigatório !';
                                              }
                                              return null;
                                            },
                                            autofocus: true,
                                            label: "RE",
                                            height: 60,
                                            controller: controller.controllerRe,
                                            initialValue:
                                                controller.controllerRe.text,
                                            inputFormatter: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  19),
                                            ],
                                            onChanged: (value) {
                                              controller.autenticacao.id =
                                                  value;
                                              controller.controllerRe.text =
                                                  value;
                                            },
                                            hintText: "Digite seu RE",
                                            prefixIcon: Icon(Icons.account_box),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          InputComponent(
                                            label: "Senha",
                                            height: 60,
                                            controller:
                                                controller.controllerSenha,
                                            initialValue:
                                                controller.controllerSenha.text,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Esse campo é obrigatório !';
                                              }
                                              return null;
                                            },
                                            inputFormatter: [
                                              LengthLimitingTextInputFormatter(
                                                  255),
                                            ],
                                            maxLines: 1,
                                            obscureText:
                                                !controller.exibirSenha.value,
                                            onFieldSubmitted: (value) {
                                              controller.formKey.currentState!
                                                  .reset();
                                              controller.formKey.currentState!
                                                  .save();
                                              controller.login();

                                              if (controller.salvaLogin.value) {
                                                controller.salvarLogin();
                                              } else {
                                                controller.removeLoginSalvo();
                                              }
                                            },
                                            onChanged: (value) {
                                              controller.autenticacao.senha =
                                                  value;
                                              controller.controllerSenha.text =
                                                  value;
                                            },
                                            hintText: "Digite sua senha",
                                            prefixIcon: Icon(Icons.lock),
                                            suffixIcon: GestureDetector(
                                              onTap: () {
                                                controller.exibirSenha(
                                                    !controller
                                                        .exibirSenha.value);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Icon(
                                                  !controller.exibirSenha.value
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Salvar Login',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              CheckboxComponent(
                                                value:
                                                    controller.salvaLogin.value,
                                                onChanged: (value) async {
                                                  setCheckSalvaLogin(!controller
                                                      .salvaLogin.value);
                                                  controller.salvaLogin.value =
                                                      getCheckSalvaLogin();
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 24),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Focus(
                                                  onKeyEvent:
                                                      (focusNode, event) {
                                                    if (event.logicalKey ==
                                                        LogicalKeyboardKey
                                                            .enter) {
                                                      if (controller
                                                          .formKey.currentState!
                                                          .validate()) {
                                                        controller.formKey
                                                            .currentState!
                                                            .reset();
                                                        controller.formKey
                                                            .currentState!
                                                            .save();
                                                        controller.login();

                                                        if (controller
                                                            .salvaLogin.value) {
                                                          controller
                                                              .salvarLogin();
                                                        } else {
                                                          controller
                                                              .removeLoginSalvo();
                                                        }
                                                      }
                                                    }
                                                    return KeyEventResult
                                                        .ignored;
                                                  },
                                                  focusNode:
                                                      controller.loginFocus,
                                                  child: ButtonComponent(
                                                    color: secundaryColor,
                                                    colorHover:
                                                        secundaryColorHover,
                                                    onPressed: () async {
                                                      if (controller
                                                          .formKey.currentState!
                                                          .validate()) {
                                                        controller.formKey
                                                            .currentState!
                                                            .reset();
                                                        controller.formKey
                                                            .currentState!
                                                            .save();
                                                        controller.login();

                                                        if (controller
                                                            .salvaLogin.value) {
                                                          controller
                                                              .salvarLogin();
                                                        } else {
                                                          controller
                                                              .removeLoginSalvo();
                                                        }
                                                      }
                                                    },
                                                    text: "Entrar",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextComponent(
                                                      'Versão: ${info.version}',
                                                      fontSize: 12,
                                                      color:
                                                          Colors.grey.shade400)
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : LoadingComponent(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
