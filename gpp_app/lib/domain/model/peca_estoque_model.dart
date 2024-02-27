import 'package:auth_migration/base/model/abstract_entity.dart';
import 'package:auth_migration/domain/model/peca_model.dart';

class PecaEstoque extends AbstractEntity {
  int? idPecaEstoque;
  int saldoDisponivel = 0;
  int? saldoReservado;
  int? quantidadeMinima;
  int? quantidadeMaxima;
  int? quantidadeIdeal;
  Peca? peca;

  PecaEstoque(
      {this.idPecaEstoque,
      required this.saldoDisponivel,
      this.saldoReservado,
      this.quantidadeMinima,
      this.quantidadeMaxima,
      this.quantidadeIdeal,
      this.peca});

  factory PecaEstoque.fromMap(Map<String, dynamic> map) {
    return PecaEstoque(
      idPecaEstoque: map['idPecaEstoque'],
      saldoDisponivel: map['saldoDisponivel'],
      saldoReservado: map['saldoReservado'],
      quantidadeMinima: map['quantidadeMinima'],
      quantidadeMaxima: map['quantidadeMaxima'],
      quantidadeIdeal: map['quantidadeIdeal'],
      peca: map['peca'] != null ? Peca.fromMap(map['peca']) : null,
    );
  }

  PecaEstoque.fromJson(Map<String, dynamic> json) {
    idPecaEstoque = json['idPecaEstoque'];
    saldoDisponivel = json['saldoDisponivel'];
    saldoReservado = json['saldoReservado'];
    quantidadeMinima = json['quantidadeMinima'];
    quantidadeMaxima = json['quantidadeMaxima'];
    quantidadeIdeal = json['quantidadeIdeal'];
    peca = json['peca'] != null ? Peca.fromJson(json['peca']) : null;
  }

  @override
   toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idPecaEstoque'] = idPecaEstoque;
    data['saldoDisponivel'] = saldoDisponivel;
    data['saldoReservado'] = saldoReservado;
    data['quantidadeMinima'] = quantidadeMinima;
    data['quantidadeMaxima'] = quantidadeMaxima;
    data['quantidadeIdeal'] = quantidadeIdeal;
    data['peca'] = peca != null ? peca!.toJson() : null;
    return data;
  }

  @override
  toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
