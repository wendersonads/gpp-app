import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gpp/src/models/departament_model.dart';
import 'package:gpp/src/utils/dispositivo.dart';
import 'package:gpp/src/views/departamentos/view/widgets/departamento_form_desktop.dart';
import 'package:gpp/src/views/departamentos/view/widgets/departamento_form_mobile.dart';

class DepartamentoFormView extends StatelessWidget {
  final DepartamentoModel? departamentoModel;

  DepartamentoFormView({this.departamentoModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Dispositivo.mobile(context.width)) {
      return DepartamentoFormMobile(
        departamentoModel: departamentoModel,
      );
    } else {
      return DepartamentoFormDesktop(
        departamentoModel: departamentoModel,
      );
    }
  }
}
