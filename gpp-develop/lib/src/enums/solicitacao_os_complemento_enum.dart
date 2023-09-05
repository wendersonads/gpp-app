enum SolicitacaoOSComplementoEnum {
  JURIDICO(1),
  TROCA_CONSUMIDOR(2),
  ESTOQUE(3),
  TROCA_CENTRAL_CLIENTE(4);

  final int value;

  const SolicitacaoOSComplementoEnum(this.value);

  String get name {
    switch (this) {
      case SolicitacaoOSComplementoEnum.JURIDICO:
        return 'JURÍDICO';
      case SolicitacaoOSComplementoEnum.TROCA_CONSUMIDOR:
        return 'TROCA CONSUMIDOR';
      case SolicitacaoOSComplementoEnum.ESTOQUE:
        return 'ESTOQUE';
      case SolicitacaoOSComplementoEnum.TROCA_CENTRAL_CLIENTE:
        return 'TROCA CENTRAL CLIENTE';
    }
  }
}
