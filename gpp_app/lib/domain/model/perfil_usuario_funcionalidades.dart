import 'package:auth_migration/base/model/abstract_entity.dart';
import 'package:auth_migration/domain/model/funcionalidades_model.dart';

class PerfilUsuarioFuncionalidades extends AbstractEntity{
  int? idPerfilUsuarioFuncionalidadade;
  Funcionalidades? funcionalidade;

  PerfilUsuarioFuncionalidades(
      {this.idPerfilUsuarioFuncionalidadade, this.funcionalidade});

  factory PerfilUsuarioFuncionalidades.fromMap(Map<String, dynamic> map) {
    return PerfilUsuarioFuncionalidades(
      idPerfilUsuarioFuncionalidadade: map['idPerfilUsuarioFuncionalidadade'],
      funcionalidade: map['funcionalidade'] != null
          ? Funcionalidades.fromMap(map['funcionalidade'])
          : null,
    );
  }

  PerfilUsuarioFuncionalidades.fromJson(Map<String, dynamic> json) {
    idPerfilUsuarioFuncionalidadade = json['idPerfilUsuarioFuncionalidadade'];
    funcionalidade = json['funcionalidade'] != null
        ? Funcionalidades.fromJson(json['funcionalidade'])
        : null;
  }
  
  @override
  Map<String,dynamic>toJson() {
   final Map<String,dynamic> data = <String,dynamic>{};
   data['idPerfilUsuarioFuncionalidadade'] = idPerfilUsuarioFuncionalidadade;
   data['funcionalidade'] = funcionalidade != null ? funcionalidade!.toJson() : null;
    return data;
  }
  
  @override
  toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }

}
