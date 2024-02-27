enum SituacaoAstecaEnum{
  ABERTA(1),
  CANCELADA(2),
  EXECUTANDO(3),
  CONCLUIDA(4);

  final int value;
  const SituacaoAstecaEnum(this.value);

  String get name{
    switch (this){
      case SituacaoAstecaEnum.ABERTA: 
        return 'Aberta';
      case SituacaoAstecaEnum.CANCELADA:
        return 'Cancelada';
      case SituacaoAstecaEnum.EXECUTANDO:
        return 'Executando';
      case SituacaoAstecaEnum.CONCLUIDA:
        return 'Concluída';
    }
  }
}