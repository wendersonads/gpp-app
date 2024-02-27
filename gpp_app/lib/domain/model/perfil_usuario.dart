import 'package:auth_migration/base/model/abstract_entity.dart';
import 'package:auth_migration/domain/model/perfil_usuario_funcionalidades.dart';

class PerfilUsuario extends AbstractEntity {
  int? idPerfilUsuario;
  String? descricao;
  List<PerfilUsuarioFuncionalidades>? perfilUsuarioFuncionalidades;

  PerfilUsuario(
      {this.idPerfilUsuario,
      this.descricao,
      this.perfilUsuarioFuncionalidades});

  factory PerfilUsuario.fromMap(Map<String, dynamic> map) {
    final List<dynamic>? funcionalidadesData =
        map['perfilUsuarioFuncionalidades'];
    final List<PerfilUsuarioFuncionalidades>? funcionalidades;
    if (funcionalidadesData != null) {
      funcionalidades = funcionalidadesData
          .map((p) => PerfilUsuarioFuncionalidades.fromMap(p))
          .toList();
    } else {
      funcionalidades = null;
    }

    return PerfilUsuario(
      idPerfilUsuario: map['idPerfilUsuario'],
      descricao: map['descricao'],
      perfilUsuarioFuncionalidades: funcionalidades,
    );
  }

  PerfilUsuario.fromJson(Map<String, dynamic> json) {
    idPerfilUsuario = json['idPerfilUsuario'];
    descricao = json['descricao'];
    if (json['perfilUsuarioFuncionalidades'] != null) {
      perfilUsuarioFuncionalidades = <PerfilUsuarioFuncionalidades>[];
      json['perfilUsuarioFuncionalidades'].forEach((p) {
        perfilUsuarioFuncionalidades!
            .add(PerfilUsuarioFuncionalidades.fromJson(p));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idPerfilUsuario'] = idPerfilUsuario;
    data['descricao'] = descricao;
    if (perfilUsuarioFuncionalidades != null) {
      data['perfilUsuarioFuncionalidades'] =
          perfilUsuarioFuncionalidades!.map((e) => e.toJson()).toList();
    }
    return data;
  }

  @override
  toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
