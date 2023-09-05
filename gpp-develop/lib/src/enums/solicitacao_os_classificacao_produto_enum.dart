enum SolicitacaoOsClassificacaoProdutoEnum {
  IMPROPRIO(1),
  OBSOLETO(2),
  EMCONFORMIDADE(3);

  final int value;

  const SolicitacaoOsClassificacaoProdutoEnum(this.value);

  String get name {
    switch (this) {
      case SolicitacaoOsClassificacaoProdutoEnum.IMPROPRIO:
        return 'Impróprio pra Revenda';

      case SolicitacaoOsClassificacaoProdutoEnum.OBSOLETO:
        return 'Produto Obsoleto';

      case SolicitacaoOsClassificacaoProdutoEnum.EMCONFORMIDADE:
        return 'Produto em Conformidade';
    }
  }
}
