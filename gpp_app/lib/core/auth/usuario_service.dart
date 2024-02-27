import 'dart:convert';

import 'package:auth_migration/domain/model/perfil_usuario.dart';
import 'package:auth_migration/domain/model/usuario_model.dart';
import 'package:hive/hive.dart';

class UsuarioService {
  final Box _storage = Hive.box('usuario');

  Future<void> setUsuario(Usuario usuario) async {
    Map<String, dynamic> usuarioMap = usuario.toJson();

    _storage.put('usuario', jsonEncode(usuarioMap));
  }

  Usuario getUsuario() {
    Map<String, dynamic> json = jsonDecode(_storage.get('usuario') ?? '');

    Usuario usuario = Usuario.fromJson(json);
    return usuario;
  }
}
