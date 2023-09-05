import 'package:flutter/material.dart';
import 'package:gpp/src/shared/components/TextComponent.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';
import 'package:get/get.dart';

class PermissaoView extends StatelessWidget {
  const PermissaoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NavbarWidget(),
      body: WillPopScope(
        onWillPop: () async => false,
        child: Row(
          children: [
            Sidebar(),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 460,
                      child: Image.asset(
                          'lib/src/shared/assets/not_permission.png'),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    TextComponent(
                      'Ops, você não têm permissão para acessar essa página !',
                      fontSize: context.textScaleFactor * 24,
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
