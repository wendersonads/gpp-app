enum TipoAstecaEnum {
  VISTORIA(1),
  REPARO(2);

  final int value;
  const TipoAstecaEnum(this.value);

  String get name {
    switch (this) {
      case TipoAstecaEnum.REPARO:
        return 'Reparo';
      case TipoAstecaEnum.VISTORIA:
        return 'Vistoría';
    }
  }
}
