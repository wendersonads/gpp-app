import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/separacao/views/widgets/separacao_desktop.dart';
import 'package:gpp/src/views/separacao/views/widgets/separacao_mobile.dart';


// class SeparacaoView extends StatelessWidget {
//   const SeparacaoView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SeparacaoDesktop();
//   }
// }

class SeparacaoView extends StatelessWidget {
  const SeparacaoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return SeparacaoMobile();
    } else {
      return SeparacaoDesktop();
    }
  }
}
