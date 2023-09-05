import 'package:get/get.dart';
import 'package:gpp/src/models/avaria/avaria_model.dart';
import 'package:gpp/src/repositories/avaria_repository/avaria_repository.dart';
import 'package:gpp/src/utils/notificacao.dart';

class DetalhesProdutoAvariaController extends GetxController {
  int? id;
  late AvariaRepository avariarepository;
  RxBool carregandoDados = false.obs;
  late List<AvariaModel> produtoAvaria;

  DetalhesProdutoAvariaController(id) {
    this.id = id;
    avariarepository = AvariaRepository();
    produtoAvaria = <AvariaModel>[];
  }

  @override
  void onInit() async {
    super.onInit();

    await buscaProduto();
  }

  Future<void> buscaProduto() async {
    try {
      carregandoDados.value = false;
      produtoAvaria = await avariarepository.buscarAvarias(id_avaria: id);

      print(produtoAvaria.toString());
    } catch (erro) {
      Notificacao.snackBar(erro.toString(),
          tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregandoDados.value = true;
    }
  }
}
