import 'package:gpp/src/models/inventario/inventario_model.dart';
import 'package:gpp/src/models/inventario/inventario_peca_model.dart';
import 'package:hive/hive.dart';

part 'inventario_local_peca_model.g.dart';

@HiveType(typeId: 1)
class InventarioLocalPecaModel {
  @HiveField(0)
  final int idInventario;

  @HiveField(1)
  final int idPeca;

  @HiveField(2)
  final int idInventarioPeca;

  @HiveField(3)
  final String descricaoPeca;

  @HiveField(4)
  final String endereco;

  @HiveField(5)
  final int quantidadeDisponivel;

  @HiveField(6)
  final int quantidadeReservada;

  @HiveField(7)
  int quantidadeContada;

  InventarioLocalPecaModel({
    required this.idInventario,
    required this.idPeca,
    required this.idInventarioPeca,
    required this.descricaoPeca,
    required this.endereco,
    required this.quantidadeDisponivel,
    required this.quantidadeReservada,
    this.quantidadeContada = 0,
  });

  int get total => quantidadeDisponivel + quantidadeReservada;

  set addQuantidadeContada(int quantidade) {
    quantidadeContada += quantidade;
  }

  set removeQuantidadeContada(int quantidade) {
    quantidadeContada -= quantidade;
  }

  factory InventarioLocalPecaModel.fromInventarioPecaModel({required InventarioPecaModel inventarioPecaModel}) {
    return InventarioLocalPecaModel(
      idInventario: inventarioPecaModel.id_inventario ?? 0,
      idPeca: inventarioPecaModel.id_peca ?? 0,
      idInventarioPeca: inventarioPecaModel.id_inventario_peca ?? 0,
      descricaoPeca: inventarioPecaModel.peca?.descricao ?? '',
      endereco: inventarioPecaModel.endereco ?? '',
      quantidadeDisponivel: inventarioPecaModel.qtd_disponivel ?? 0,
      quantidadeReservada: inventarioPecaModel.qtd_reservado ?? 0,
      quantidadeContada: inventarioPecaModel.qtd_contada ?? 0,
    );
  }
}
