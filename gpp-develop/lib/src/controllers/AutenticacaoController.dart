import 'package:flutter/material.dart';
import 'package:gpp/src/models/AutenticacaoModel.dart';

import 'package:gpp/src/repositories/AutenticacaoRepository.dart';

class AutenticacaoController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool visiblePassword = false;
  AutenticacaoRepository repository = AutenticacaoRepository();
  AutenticacaoModel autenticacao = AutenticacaoModel();
  bool autenticado = false;
  bool carregado = false;
}
