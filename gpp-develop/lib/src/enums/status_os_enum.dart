enum StatusOSEnum {
  AGUARDANDO(1),
  APROVADO(2),
  REPROVADO(3);

  final int value;
  const StatusOSEnum(this.value);

  String get name {
    switch (this) {
      case StatusOSEnum.AGUARDANDO:
        return 'AGUARDANDO APROVAÇÃO';
      case StatusOSEnum.APROVADO:
        return 'APROVADA';
      case StatusOSEnum.REPROVADO:
        return 'REPROVADA';
    }
  }
}
