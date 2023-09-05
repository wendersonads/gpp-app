import 'package:gpp/src/models/inventario/inventario_local_model.dart';
import 'package:gpp/src/models/inventario/inventario_local_peca_model.dart';

class InventarioLocalResultModel {
  final int idInventario;
  final List<InventarioLocalPecaResultModel> pecas;

  InventarioLocalResultModel({
    required this.idInventario,
    required this.pecas,
  });

  factory InventarioLocalResultModel.fromInventarioLocal({required InventarioLocalModel inventarioLocalModel}) {
    return InventarioLocalResultModel(
      idInventario: inventarioLocalModel.idInventario,
      pecas: inventarioLocalModel.pecas
          .map((peca) => InventarioLocalPecaResultModel(
                idInventarioPeca: peca.idInventarioPeca,
                quantidadeContada: peca.quantidadeContada,
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['inventario_pecas'] = this.pecas.map((e) => e.toJson()).toList();

    return data;
  }
}

class InventarioLocalPecaResultModel {
  final int idInventarioPeca;
  final int quantidadeContada;

  InventarioLocalPecaResultModel({
    required this.idInventarioPeca,
    required this.quantidadeContada,
  });

  factory InventarioLocalPecaResultModel.fromInventarioLocalPeca({required InventarioLocalPecaModel inventarioLocalPecaModel}) {
    return InventarioLocalPecaResultModel(
      idInventarioPeca: inventarioLocalPecaModel.idInventarioPeca,
      quantidadeContada: inventarioLocalPecaModel.quantidadeContada,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['id_inventario_peca'] = this.idInventarioPeca;
    data['qtd_contada'] = this.quantidadeContada;

    return data;
  }
}
