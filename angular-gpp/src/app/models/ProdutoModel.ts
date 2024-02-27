import { FornecedorModel } from "./FornecedorModel";

export class ProdutoModel {
  idProduto?: number;
  descricao?: string;
  fornecedor: FornecedorModel = new FornecedorModel;

}
