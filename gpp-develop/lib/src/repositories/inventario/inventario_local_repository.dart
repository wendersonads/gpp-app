import 'dart:developer';

import 'package:gpp/src/models/inventario/inventario_local_model.dart';
import 'package:gpp/src/models/inventario/inventario_local_peca_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InventarioLocalRepository {
  Box<InventarioLocalModel> get box => Hive.box<InventarioLocalModel>('inventario');

  void populate({required InventarioLocalModel inventarioLocalModel, required int idInventario}) {
    box.put(idInventario, inventarioLocalModel);
  }

  InventarioLocalModel? getInventarioLocal({required int idInventario}) {
    return box.get(idInventario);
  }

  InventarioLocalModel updatePeca({required int idInventario, required InventarioLocalPecaModel peca}) {
    InventarioLocalModel inventarioLocalModel = box.get(idInventario)!;

    int index = inventarioLocalModel.pecas.indexWhere((element) => element.idPeca == peca.idPeca);

    inventarioLocalModel.pecas[index] = peca;

    box.put(idInventario, inventarioLocalModel);

    return inventarioLocalModel;
  }

  void finishInventario({required int idInventario}) {
    box.delete(idInventario);
  }

  InventarioLocalPecaModel getPeca({required int idInventario, required int idPeca}) {
    InventarioLocalModel inventarioLocalModel = box.get(idInventario)!;

    return inventarioLocalModel.pecas.firstWhere((element) => element.idPeca == idPeca);
  }

  void printInventarioLocal({required int idInventario}) {
    InventarioLocalModel inventarioLocalModel = box.get(idInventario)!;

    for (InventarioLocalPecaModel peca in inventarioLocalModel.pecas) {
      log(peca.descricaoPeca);
    }
  }
}
