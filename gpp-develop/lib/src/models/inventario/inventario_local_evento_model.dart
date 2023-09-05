import 'package:gpp/src/models/inventario/inventario_evento_model.dart';
import 'package:hive/hive.dart';

part 'inventario_local_evento_model.g.dart';

@HiveType(typeId: 3)
class InventarioLocalEventoModel {
  @HiveField(0)
  final int idInventarioEvento;

  @HiveField(1)
  final int idEventoStatus;

  @HiveField(2)
  final String dataEvento;

  @HiveField(3)
  final String descricao;

  @HiveField(4)
  final String mensagemPadrao;

  @HiveField(5)
  final String statusCor;

  InventarioLocalEventoModel({
    required this.idInventarioEvento,
    required this.idEventoStatus,
    required this.dataEvento,
    required this.descricao,
    required this.mensagemPadrao,
    required this.statusCor,
  });

  factory InventarioLocalEventoModel.fromInventarioEventoModel({required InventarioEventoModel inventarioEventoModel}) {
    return InventarioLocalEventoModel(
      idInventarioEvento: inventarioEventoModel.id_inventario_evento ?? 0,
      idEventoStatus: inventarioEventoModel.id_evento_status ?? 0,
      dataEvento: inventarioEventoModel.data_evento ?? '',
      descricao: inventarioEventoModel.eventoStatus?.descricao ?? '',
      mensagemPadrao: inventarioEventoModel.eventoStatus?.mensagemPadrao ?? '',
      statusCor: inventarioEventoModel.eventoStatus?.statusCor ?? '',
    );
  }
}
