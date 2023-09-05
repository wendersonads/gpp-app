import 'package:get/get.dart';
import 'package:gpp/src/models/CapacidadeEstoqueModel.dart';
import 'package:gpp/src/models/dashboard_model.dart';

import 'package:gpp/src/repositories/CapacidadeEstoqueRepository.dart';
import 'package:gpp/src/repositories/pecas_repository/dashboard_repositoy.dart';

import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:intl/intl.dart';

import '../../../utils/notificacao.dart';

class DashboardController extends GetxController {
  var carregando = true.obs;
  var onHoverPedidosaida = false.obs;
  var onHoverPedidoEntrada = false.obs;
  var onHoverAsteca = false.obs;
  late DashboardRepository dashboardRepository;
  late DashboardModel dashboard;
  late MaskFormatter maskFormatter;
  late CapacidadeEstoqueRepository capacidadeEstoqueRepository;
  List<CapacidadeEstoqueModel> capacidadeEstoqueModel = <CapacidadeEstoqueModel>[];
  NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

  DashboardController() {
    dashboardRepository = DashboardRepository();
    dashboard = DashboardModel();
    maskFormatter = MaskFormatter();
    capacidadeEstoqueRepository = CapacidadeEstoqueRepository();
  }

  @override
  void onInit() async {
    await buscarDashboard();
    await capacidadeBox();
    super.onInit();
  }

  buscarDashboard() async {
    try {
      carregando(true);
      dashboard = await dashboardRepository.buscarDashboard();
    } catch (e) {
      Notificacao.snackBar(e.toString(), tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
    }
  }

  capacidadeBox() async {
    try {
      carregando(true);
      var retorno = await capacidadeEstoqueRepository.consultaCapacidade(1);

      capacidadeEstoqueModel = retorno[0];
    } catch (e) {
      // Notificacao.snackBar(e.toString(),
      //     tipoNotificacao: TipoNotificacaoEnum.error);
    } finally {
      carregando(false);
    }
  }
}
