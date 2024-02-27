import { ClienteModel } from "./ClienteModel";
import { ItemDocumentoFiscalModel } from "./ItemDocumentoFiscalModel";

export class DocumentoFiscalModel {
  idDocumentoFiscal?: number;
  idFilialSaida?: number;
  cpfCnpj?: string;
  numDocFiscal?: number;
  serieDocFiscal?: string;
  dataEmissao?: Date;
  itens?: ItemDocumentoFiscalModel[];
  cliente?: ClienteModel;
  descricao?: string;
  fornecedor?: string;
}
