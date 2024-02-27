import 'package:auth_migration/base/model/abstract_entity.dart';
import 'package:auth_migration/domain/model/subfuncionalidades_model.dart';

class Funcionalidades extends AbstractEntity {
  int? idFuncionalidade;
  String? nome;
  String? icone;
  int? situacao;
  List<SubFuncionalidades>? subFuncionalidades;

  Funcionalidades(
      {this.idFuncionalidade, this.icone, this.nome,this.situacao, this.subFuncionalidades});

  factory Funcionalidades.fromMap(Map<String, dynamic> map) {
    final List<dynamic>? subList = map['subfuncionalidades'];
    final List<SubFuncionalidades>? subFuncionalidades;
    if (subList != null) {
      subFuncionalidades =
          subList.map((e) => SubFuncionalidades?.fromMap(e)).toList();
    } else {
      subFuncionalidades = null;
    }
    return Funcionalidades(
      idFuncionalidade: map['idFuncionalidade'],
      nome: map['nome'],
      icone: map['icone'],
      situacao: map['situacao'],
      subFuncionalidades: subFuncionalidades,
    );
  }

  Funcionalidades.fromJson(Map<String, dynamic> json) {
    idFuncionalidade = json['idFuncionalidade'];
    icone = json['icone'];
    nome = json['nome'];
    situacao = json['situacao'];
    subFuncionalidades = <SubFuncionalidades>[];
      json['subFuncionalidades'].forEach((f) {
        subFuncionalidades?.add(SubFuncionalidades.fromMap(f));
      });
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idFuncionalidade'] = idFuncionalidade;
    data['icone'] = icone;
    data['nome'] = nome;
    data['situacao'] = situacao;
    data['subFuncionalidades'] = subFuncionalidades?.map((e) => e.toJson()).toList();
    return data;
  }

  @override
  toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
