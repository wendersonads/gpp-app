import { PecaEstoqueModel } from "./PecaEstoqueModel";

export class ItemSolicitacaoAstecaModel {
  constructor(
    public idItemAsteca?: number,
    public quantidade?: number,
    public pecaEstoque?: PecaEstoqueModel
  ) {}

}
