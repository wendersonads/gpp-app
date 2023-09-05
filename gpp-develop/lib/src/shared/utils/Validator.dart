import 'package:brasil_fields/brasil_fields.dart';

class Validator {
  cpfOuCnpj(String value) {
    if (value.length == 11) {
      if (!UtilBrasilFields.isCPFValido(value)) {
        return 'CPF inválido';
      }
    } else if (value.length == 14) {
      if (!UtilBrasilFields.isCNPJValido(value)) {
        return 'CNPJ inválido';
      }
    } else {
      return 'CPF ou CNPJ inválido';
    }
  }
}
