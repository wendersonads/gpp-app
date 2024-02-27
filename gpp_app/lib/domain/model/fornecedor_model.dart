import 'dart:convert';

import 'package:auth_migration/base/model/abstract_entity.dart';

class Fornecedor extends AbstractEntity {
  int? idFornecedor;
  String? nomeFornecedor;
  String? email;
  String? cnpj;

  Fornecedor({this.idFornecedor, this.nomeFornecedor, this.email, this.cnpj});

  @override
  toMap() {
    return {
      'idFornecedor': idFornecedor,
      'nomeFornecedor': nomeFornecedor,
      'email': email,
      'cnpj': cnpj
    };
  }

  factory Fornecedor.fromMap(Map<String, dynamic> map) {
    return Fornecedor(
        idFornecedor: map['idFornecedor'],
        nomeFornecedor: map['nomeFornecedor'],
        email: map['email'],
        cnpj: map['cnpj']);
  }

  @override
  toJson() {
   final Map<String,dynamic> data = <String,dynamic>{};
   data['idFornecedor'] = idFornecedor;
   data['nomeFornecedor'] =  nomeFornecedor;
   data['email'] = email;
   data['cnpj'] = cnpj;
   return data;
  }

  Fornecedor.fromJson(Map<String, dynamic> json) {
    idFornecedor = json['idFornecedor'];
    nomeFornecedor = json['nomeFornecedor'];
    email = json['email'];
    cnpj = json['cnpj'];
  }

  @override
  String toString() {
    return 'Register(idFornecedor: $idFornecedor, nomeFornecedor: $nomeFornecedor, email: $email, cnpj: $cnpj)';
  }
}
