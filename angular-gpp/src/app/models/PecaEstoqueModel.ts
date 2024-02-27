import { PecaModel } from "./PecaModel";

export class PecaEstoqueModel {
  idPecaEstoque?: number;
  peca: PecaModel;
  saldoDisponivel: number;
  saldoReservado: number;
  quantidadeMinima?: number;
  quantidadeMaxima?: number;
  quantidadeIdeal?: number;

  constructor(
    idPecaEstoque: number,
    peca: PecaModel,
    saldoDisponivel: number,
    saldoReservado: number,
    fornecedor?: string,
    endereco?: string,
    quantidadeMinima?: number,
    quantidadeMaxima?: number,
    quantidadeIdeal?: number
  ) {
    this.idPecaEstoque = idPecaEstoque;
    this.peca = peca;
    this.saldoDisponivel = saldoDisponivel;
    this.saldoReservado = saldoReservado;
    this.quantidadeMinima = quantidadeMinima;
    this.quantidadeMaxima = quantidadeMaxima;
    this.quantidadeIdeal = quantidadeIdeal;
  }
}
