import 'package:auth_migration/base/model/abstract_entity.dart';
import 'fornecedor_model.dart';
import 'dart:convert';

class Produto extends AbstractEntity {
  int? idProduto;
  String? descricao;
  Fornecedor? fornecedor;

  Produto({
    this.idProduto,
    this.descricao,
    this.fornecedor,
  });

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      idProduto: map['idProduto'],
      descricao: map['descricao'],
      fornecedor: map['fornecedor'] != null
          ? Fornecedor.fromMap(map['fornecedor'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'idProduto': idProduto,
      'descricao': descricao,
      'fornecedor': fornecedor != null ? fornecedor!.toMap() : null,
    };
  }

  @override
   toJson(){
    final Map<String,dynamic> data = <String,dynamic>{};
    data['idProduto'] = idProduto;
    data['descricao'] = descricao;
    data['fornecedor'] = fornecedor != null ? fornecedor!.toJson() : null;
    return data;
  }

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      idProduto: json['idProduto'],
      descricao: json['descricao'],
      fornecedor: json['fornecedor'] != null
          ? Fornecedor.fromJson(json['fornecedor'])
          : null,
    );
  }

  @override
  String toString() {
    return 'Produto(idProduto: $idProduto, descricao: $descricao, fornecedor: $fornecedor)';
  }
}
