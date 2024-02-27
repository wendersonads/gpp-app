import 'package:auth_migration/base/model/abstract_entity.dart';

class SubFuncionalidades extends AbstractEntity{
  int? idSubfuncionalidade;
  String? nome;
  String? rota;
  int? situacao;
  SubFuncionalidades(
      {this.idSubfuncionalidade, this.nome, this.rota, this.situacao});

  factory SubFuncionalidades.fromMap(Map<String, dynamic> map) {
    return SubFuncionalidades(
      idSubfuncionalidade: map['idSubfuncionalidade'],
      nome: map['nome'],
      rota: map['rota'],
      situacao: map['situacao'],
    );
  }

  SubFuncionalidades.fromJson(Map<String, dynamic> json) {
    idSubfuncionalidade = json['idSubfuncionalidade'];
    nome = json['nome'];
    rota = json['rota'];
    situacao = json['situacao'];
  }

  @override
   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idSubfuncionalidade'] = idSubfuncionalidade;
    data['nome'] = nome;
    data['rota'] = rota;
    data['situacao'] = situacao;
    return data;
  }
  
  @override
  toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
