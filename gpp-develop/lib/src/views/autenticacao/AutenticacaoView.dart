import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:gpp/src/controllers/AutenticacaoController.dart';

import 'package:gpp/src/controllers/responsive_controller.dart';

import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/shared/components/TitleComponent.dart';

import 'package:gpp/src/shared/repositories/styles.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/utils/notificacao.dart';

class AutenticacaoView extends StatefulWidget {
  const AutenticacaoView({
    Key? key,
  }) : super(key: key);

  @override
  _AutenticacaoViewState createState() => _AutenticacaoViewState();
}

class _AutenticacaoViewState extends State<AutenticacaoView> {
  late AutenticacaoController controller;
  final ResponsiveController _responsive = ResponsiveController();

  @override
  void initState() {
    super.initState();

    //Criar instência do controller de autenticação
    controller = AutenticacaoController();
  }

  void handleVisiblePassword() {
    setState(() {
      controller.visiblePassword = !controller.visiblePassword;
    });
  }

  void autenticar(context) async {
    try {
      if (await controller.repository.login(controller.autenticacao)) {
        setState(() {
          controller.autenticado = true;
        });

        Get.offAllNamed('/home');
      }
    } catch (e) {
      Notificacao.snackBar(e.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    }
  }

  Form _buildFormAuthenticated(MediaQueryData mediaQuery) {
    return Form(
      key: controller.formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: TitleComponent('Login')),
              InputComponent(
                label: "RE",
                onFieldSubmitted: (value) {
                  autenticar(context);
                },
                onChanged: (value) {
                  controller.autenticacao.id = value;
                },
                hintText: "Digite seu RE",
                inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                prefixIcon: Icon(Icons.account_box),
              ),
              const SizedBox(
                height: 12,
              ),
              InputComponent(
                label: "Senha",
                maxLines: 1,
                obscureText: !controller.visiblePassword,
                onFieldSubmitted: (value) {
                  autenticar(context);
                },
                onChanged: (value) {
                  controller.autenticacao.senha = value;
                },
                hintText: "Digite sua senha",
                prefixIcon: Icon(Icons.lock),
                suffixIcon: GestureDetector(
                  onTap: () => handleVisiblePassword(),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.visibility,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ButtonComponent(
                        color: secundaryColor,
                        colorHover: secundaryColorHover,
                        onPressed: () => autenticar(context),
                        text: "Entrar"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    Widget page = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // if (_responsive.isMobile(constraints.maxWidth)) {
        //   return Column(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       _buildAppBar(mediaQuery),
        //       Container(
        //         height: mediaQuery.size.height,
        //         color: Colors.white,
        //         child: _buildState(context, mediaQuery),
        //       ),
        //     ],
        //   );
        // }

        // if (_responsive.isTable(constraints.maxWidth)) {
        //   return Column(
        //     children: [
        //       _buildAppBar(mediaQuery),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           _buildMessageWelcome(),
        //         ],
        //       ),
        //       Row(
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Container(
        //             width: 400,
        //             height: 460,
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(10),
        //               color: Colors.white,
        //             ),
        //             child: _buildState(context, mediaQuery),
        //           ),
        //         ],
        //       )
        //     ],
        //   );
        // }

        return Column(
          children: [
            _buildAppBar(mediaQuery),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 140),
              child: SizedBox(
                height: mediaQuery.size.height * 0.90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [_buildMessageWelcome()],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 340,
                          height: 460,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: !controller.autenticado
                              ? _buildFormAuthenticated(mediaQuery)
                              : LoadingComponent(),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );

    return Scaffold(
        backgroundColor: primaryColor,
        body: SingleChildScrollView(child: page));
  }

  Container _buildAppBar(MediaQueryData mediaQuery) {
    return Container(
      color: primaryColor,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        if (_responsive.isMobile(constraints.maxWidth)) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TitleComponent(
                    'gpp',
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 160,
                    child: Image.asset('lib/src/shared/assets/brand.png'),
                  )
                ],
              ));
        } else {
          return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 140),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleComponent(
                    'gpp',
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 40,
                    width: 160,
                    child: Image.asset('lib/src/shared/assets/brand.png'),
                  )
                ],
              ));
        }
      }),
    );
  }

  SizedBox _buildMessageWelcome() {
    return SizedBox(
      width: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextComponent(
            'Bem vindo ao',
            color: Colors.white,
            fontSize: 42,
            fontWeight: FontWeight.bold,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: TextComponent(
              'Gerenciamento de Peças e Pedidos',
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
