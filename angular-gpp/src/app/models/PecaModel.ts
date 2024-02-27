import { ProdutoModel } from "./ProdutoModel";

export class PecaModel {
  constructor(
    public idPeca: number = 0,
    public numero: string = "",
    public codigoFabrica: string = "",
    public unidade: number | null = null,
    public descricao?: string,
    public altura: number | null = null,
    public largura: number | null = null,
    public profundidade: number | null = null,
    public unidadeMedida: number | null = null,
    public volumes: string = "",
    public active: boolean = false,
    public custo: number | null = null,
    public cor: string = "",
    public material: string = "",
    public idFornecedor?: number,
    public materialFabricacao: string = "",
    // public produto: string = ""
    public produto: ProdutoModel = new ProdutoModel(),
    public saldoDisponivel?: number,
    public quantidade?: number
    
  ) {}
}

