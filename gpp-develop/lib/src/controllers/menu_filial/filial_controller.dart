import 'package:gpp/src/models/filial/empresa_filial_model.dart';
import 'package:gpp/src/models/filial/filial_model.dart';
import 'package:gpp/src/models/user_model.dart';
import 'package:gpp/src/repositories/menu_filial/menu_filial_repository.dart';
import 'package:gpp/src/shared/services/auth.dart';
import 'package:gpp/src/shared/utils/Usuario.dart';

class FilialController {
  late final FilialRepository filialRepository = FilialRepository();
  FilialModel filialModel = FilialModel();

  void filialLogin() async {
    /* Método comentado pois não é mais necessário realizar essa validação de 
     * filial.
     *  
     *  try {
     *   List<dynamic> filiaisAsteca =
     *       await filialRepository.buscarFiliaisAsteca();
     *   List<dynamic> filiaisLoja = await filialRepository.buscarFiliaisLoja();
     *
     *   if (filiaisAsteca.contains(usuario.idFilial) ||
     *       filiaisLoja.contains(usuario.idFilial)) {
     *     setFilial(filial: EmpresaFilialModel(id_filial: usuario.idFilial));
     *   } else {
     *     setFilial(
     *         filial: EmpresaFilialModel(
     *       id_empresa: 1,
     *       id_filial: 500,
     *       filial: FilialModel(id_filial: 500, sigla: 'DP/ASTEC'),
     *     ));
     *   }
     * } catch (error) {
     *   throw error;
     * }
     */
    setFilial(
      filial: EmpresaFilialModel(id_filial: usuario.idFilial),
    );
  }

  Future<bool> mudarFilialSelecionada(UsuarioModel usuario) async {
    return await filialRepository.mudarFilialSelecionada(usuario);
  }

  Future<List<EmpresaFilialModel>> buscarTodos() async {
    return await filialRepository.buscarTodos();
  }
}
