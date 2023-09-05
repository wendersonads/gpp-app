import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MaskFormatter {
  NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

  MaskTextInputFormatter? cpfCnpjFormatter({String? value}) {
    if (value!.length == 11) {
      return cpfFormatter(value: value);
    } else if (value.length == 14) {
      return cnpjFormatter(value: value);
    }
    return null;
  }

  cpfFormatter({String? value}) {
    return MaskTextInputFormatter(
      initialText: value.toString(),
      mask: '###.###.###-##',
      filter: {"#": RegExp(r'[0-9]')},
    );
  }

  MaskTextInputFormatter dataFormatter({String? value}) {
    return MaskTextInputFormatter(
      initialText: value.toString(),
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
    );
  }

  MaskTextInputFormatter dataFormatterAmericano({String? value}) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return MaskTextInputFormatter(
      initialText: formatter.format(DateTime.parse(value ?? '')).toString(),
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
    );
  }

  cnpjFormatter({String? value}) {
    return MaskTextInputFormatter(
      initialText: value,
      mask: '##.###.###/####-##',
      filter: {"#": RegExp(r'[0-9]')},
    );
  }

  MaskTextInputFormatter telefoneInputFormmater(String? value) {
    return MaskTextInputFormatter(
      initialText: value,
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
    );
  }

  MaskTextInputFormatter cepInputFormmater(String? value) {
    return MaskTextInputFormatter(
      initialText: value,
      mask: '#####-###',
      filter: {"#": RegExp(r'[0-9]')},
    );
  }

  MaskTextInputFormatter medida({String? value}) {
    return MaskTextInputFormatter(
      initialText: value,
      mask: '#,##',
      filter: {"#": RegExp(r'[0-9]')},
    );
  }

  realInputFormmater(value) {
    return formatter.format(value);
  }

  MaskTextInputFormatter medidaCMeMMeMetro({String? value}) {
    return MaskTextInputFormatter(
      initialText: value,
      mask: '##,##',
      filter: {"#": RegExp(r'[0-9]')},
    );
  }
}
