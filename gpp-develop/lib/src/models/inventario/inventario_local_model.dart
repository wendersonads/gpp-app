import 'package:gpp/src/models/inventario/inventario_local_evento_model.dart';
import 'package:gpp/src/models/inventario/inventario_local_peca_model.dart';
import 'package:gpp/src/models/inventario/inventario_model.dart';
import 'package:hive/hive.dart';

part 'inventario_local_model.g.dart';

@HiveType(typeId: 2)
class InventarioLocalModel {
  @HiveField(0)
  final int idInventario;

  @HiveField(1)
  final List<InventarioLocalPecaModel> pecas;

  @HiveField(2)
  final InventarioLocalEventoModel evento;

  InventarioLocalModel({
    required this.idInventario,
    required this.pecas,
    required this.evento,
  });

  factory InventarioLocalModel.fromInventarioModel({required InventarioModel inventarioModel}) {
    return InventarioLocalModel(
      idInventario: inventarioModel.id_inventario ?? 0,
      pecas: inventarioModel.inventarioPeca
              ?.map((e) => InventarioLocalPecaModel.fromInventarioPecaModel(inventarioPecaModel: e))
              .toList() ??
          [],
      evento: InventarioLocalEventoModel.fromInventarioEventoModel(inventarioEventoModel: inventarioModel.inventarioEvento!.last),
    );
  }
}
