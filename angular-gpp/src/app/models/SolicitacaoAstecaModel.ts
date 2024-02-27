import { AstecaMotivoModel } from "./AstecaMotivoModel";
import { DocumentoFiscalModel } from "./DocumentoFiscalModel";
import { ItemSolicitacaoAstecaModel } from "./ItemSolicitacaoAstecaModel";
import { SituacaoAstecaEnum } from "./SituacaoAstecaEnum";
import { TipoAstecaEnum } from "./TipoAstecaEnum";

export class SolicitacaoAstecaModel {
  constructor(
    public idAsteca?: number,
    public idProduto?: number,
    public descricaoProduto?: string,
    public observacao?: string,
    public dataCriacao?: Date,
    public situacaoAsteca?: SituacaoAstecaEnum,
    public tipoAsteca?: TipoAstecaEnum,
    public documentoFiscal?: DocumentoFiscalModel,
    public itensAsteca?: ItemSolicitacaoAstecaModel[],
    public motivoCriacaoAsteca?: AstecaMotivoModel
  ) {}
}