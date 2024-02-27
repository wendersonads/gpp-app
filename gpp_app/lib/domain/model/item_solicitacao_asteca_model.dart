import 'package:auth_migration/base/model/abstract_entity.dart';
import 'package:auth_migration/domain/model/peca_estoque_model.dart';

class ItemSolicitacaoAsteca extends AbstractEntity{
  int? idItemAsteca;
  int quantidade = 0;
  PecaEstoque? pecaEstoque;

  ItemSolicitacaoAsteca({
    this.idItemAsteca,
    required this.quantidade,
    this.pecaEstoque,
  });

  factory ItemSolicitacaoAsteca.fromMap(Map<String, dynamic> map) {
    return ItemSolicitacaoAsteca(
      idItemAsteca: map['idItemAsteca'],
      quantidade: map['quantidade'],
      pecaEstoque: map['pecaEstoque'] != null
          ? PecaEstoque.fromMap(map['pecaEstoque'])
          : null,
    );
  }

  ItemSolicitacaoAsteca.fromJson(Map<String, dynamic> json) {
    idItemAsteca = json['idItemAsteca'];
    quantidade = json['quantidade'];
    pecaEstoque = json['pecaEstoque'] != null
        ? PecaEstoque.fromJson(json['pecaEstoque'])
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idItemAsteca'] = idItemAsteca;
    data['quantidade'] = quantidade;
    data['pecaEstoque'] = pecaEstoque != null ? pecaEstoque!.toJson() : null;
    return data;
  }

  // O método toMap pode ser deixado vazio se não for necessário para a sua lógica.
  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}
