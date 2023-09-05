import 'package:gpp/src/models/motivo_model.dart';
import 'package:gpp/src/repositories/motivo_troca_peca_repository.dart';

class MotivoTrocaPecaController {
  MotivoTrocaPecaRepository repository = MotivoTrocaPecaRepository();
  bool carregando = false;

  late MotivoModel motivo = MotivoModel();

  late List<MotivoModel> motivos = [];
}
