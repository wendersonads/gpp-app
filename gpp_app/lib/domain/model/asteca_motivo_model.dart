import 'package:auth_migration/base/model/abstract_entity.dart';

class AstecaMotivo extends AbstractEntity {
  int? idAstecaMotivo;
  String? denominacao;

  AstecaMotivo({this.idAstecaMotivo, this.denominacao});

  factory AstecaMotivo.fromMap(Map<String, dynamic> map) {
    return AstecaMotivo(
        idAstecaMotivo: map['idAstecaMotivo'], denominacao: map['denominacao']);
  }
  AstecaMotivo.fromJson(Map<String, dynamic> json) {
    idAstecaMotivo = json['idAstecaMotivo'];
    denominacao = json['denominacao'];
  }

  @override
  toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idAstecaMotivo'] = idAstecaMotivo;
    data['denominacao'] = denominacao;
    return data;
  }

  @override
  toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
