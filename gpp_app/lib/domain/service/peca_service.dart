import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/auth/usuario_service.dart';
import '../../shared/components/MaskFormatter.dart';
import '../model/pagina_model.dart';
import '../model/peca_model.dart';
import '../model/usuario_model.dart';
import '../repository/peca_repository.dart';

class PecaService extends GetxController {

  NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
  late MaskFormatter maskFormatter = MaskFormatter();
  String pesquisar = '';
  var carregando = true.obs;
  late PecaRepository pecaRepository;
  late List<Peca> pecas;
  late Pagina pagina;



  PecaService(){
    pecaRepository = PecaRepository();
    pecas = <Peca>[].obs;
    pagina = Pagina(total: 0, atual: 1);
  }

  @override
  void onInit() {
    listaPecas();
    super.onInit();
  }

  listaPecas() async {
    try {
      carregando(true);
      pecas = await pecaRepository.listaPecas();
    } catch (e) {
     null;
    } finally {
      carregando(false);
      update();
    }
  }

  adicionarPeca(Peca novaPeca) async {
    try {
      carregando(true);
      await pecaRepository.adicionarPeca(novaPeca);
    } catch (e) {
     null;
    } finally {
      carregando(false);
      update();
    }
  }


  Future<void> deletarPeca(int idPeca) async {
    try {
      print('Fornecedor para deletar: ${idPeca}');

      carregando(true);
      if (idPeca != null) {
        await pecaRepository.deletarPeca(idPeca);
      }
      listaPecas();
    } catch (e) {
      null;
    } finally {
      carregando(false);
      update();
    }
  }
}
