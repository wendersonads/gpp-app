import 'package:auth_migration/domain/model/peca_estoque_model.dart';

class ItemProdutoPecaAsteca{
  bool marcado = false;
  late PecaEstoque produtoPeca;
  ItemProdutoPecaAsteca({
    required this.marcado,
    required this.produtoPeca,
  });
}