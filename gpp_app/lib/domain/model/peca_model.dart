import 'package:auth_migration/base/model/abstract_entity.dart';
import 'dart:convert';

import 'package:auth_migration/domain/model/produto_model.dart';

class Peca extends AbstractEntity {
  int? idPeca;
  String? numero;
  String? codigoFabrica;
  int? unidade;
  String? descricao;
  int? altura;
  int? largura;
  int? profundidade;
  int? unidadeMedida;
  String? volumes;
  bool? active;
  double? custo;
  String? cor;
  String? material;
  int? idFornecedor;
  String? materialFabricacao;
  Produto? produto;

  Peca({
    this.idPeca,
    this.numero,
    this.codigoFabrica,
    this.unidade,
    this.descricao,
    this.altura,
    this.largura,
    this.profundidade,
    this.unidadeMedida,
    this.volumes,
    this.active,
    this.custo,
    this.cor,
    this.material,
    this.idFornecedor,
    this.materialFabricacao,
    this.produto,
  });

  factory Peca.fromMap(Map<String, dynamic> map) {
    return Peca(
      idPeca: map['idPeca'],
      numero: map['numero'],
      codigoFabrica: map['codigoFabrica'],
      unidade: map['unidade'],
      descricao: map['descricao'],
      altura: map['altura'],
      largura: map['largura'],
      profundidade: map['profundidade'],
      unidadeMedida: map['unidadeMedida'],
      volumes: map['volumes'],
      active: map['active'],
      custo: map['custo'],
      cor: map['cor'],
      material: map['material'],
      idFornecedor: map['idFornecedor'],
      materialFabricacao: map['materialFabricacao'],
      produto: map['produto'] != null ? Produto.fromMap(map['produto']) : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'idPeca': idPeca,
      'numero': numero,
      'codigoFabrica': codigoFabrica,
      'unidade': unidade,
      'descricao': descricao,
      'altura': altura,
      'largura': largura,
      'profundidade': profundidade,
      'unidadeMedida': unidadeMedida,
      'volumes': volumes,
      'active': active,
      'custo': custo,
      'cor': cor,
      'material': material,
      'idFornecedor': idFornecedor,
      'materialFabricacao': materialFabricacao,
      'produto': produto != null ? produto!.toMap() : null,
    };
  }

  Peca.fromJson(Map<String, dynamic> json) {
    idPeca = json['idPeca'];
    numero = json['numero'];
    codigoFabrica = json['codigoFabrica'];
    unidade = json['unidade'];
    descricao = json['descricao'];
    altura = json['altura'];
    largura = json['largura'];
    profundidade = json['profundidade'];
    unidadeMedida = json['unidadeMedida'];
    volumes = json['volumes'];
    active = json['active'];
    custo = json['custo'];
    cor = json['cor'];
    material = json['material'];
    idFornecedor = json['idFornecedor'];
    materialFabricacao = json['materialFabricacao'];
    produto =
        json['produto'] != null ? Produto.fromJson(json['produto']) : null;
  }
   
  @override
    toJson(){
      final Map<String, dynamic> data = <String, dynamic>{};
      data['idPeca'] = idPeca;
      data['numero'] = numero;
      data['codigoFabrica'] = codigoFabrica;
      data['unidade'] = unidade;
      data['descricao'] = descricao;
      data['altura'] = altura;
      data['largura'] = largura;
      data['profundidade'] = profundidade;
      data['unidadeMedida'] = unidadeMedida;
      data['volumes'] = volumes;
      data['active'] = active;
      data['custo'] = custo;
      data['cor'] = cor;
      data['material'] = material;
      data['idFornecedor'] = idFornecedor;
      data['materialFabricacao'] = materialFabricacao;
      data['produto'] = produto != null ? produto!.toJson() : null;
      return data;
    }

  @override
  String toString() {
    return 'Peca(idPeca: $idPeca, numero: $numero, codigoFabrica: $codigoFabrica, unidade: $unidade, descricao: $descricao, altura: $altura, largura: $largura, profundidade: $profundidade, unidadeMedida: $unidadeMedida, volumes: $volumes, active: $active, custo: $custo, cor: $cor, material: $material, idFornecedor: $idFornecedor, materialFabricacao: $materialFabricacao, produto: $produto)';
  }
}
