import 'package:auth_migration/base/model/abstract_entity.dart';
import 'package:auth_migration/domain/model/asteca_motivo_model.dart';
import 'package:auth_migration/domain/model/documento_fiscal_model.dart';
import 'package:auth_migration/domain/model/item_solicitacao_asteca_model.dart';

class SolicitacaoAstecaModel extends AbstractEntity {
  int? idAsteca;
  int? idProduto;
  String? descricaoProduto;
  String? dataCriacao;
  String? dataInicioAsteca;
  String? dataCancela;
  String? dataFinaliza;
  int? situacaoAsteca;
  int? tipoAsteca;
  DocumentoFiscal? documentoFiscal;
  AstecaMotivo? motivoCriacaoAsteca;
  List<ItemSolicitacaoAsteca>? itensAsteca;

  SolicitacaoAstecaModel({
    this.idAsteca,
    this.idProduto,
    this.descricaoProduto,
    this.dataCriacao,
    this.dataInicioAsteca,
    this.dataCancela,
    this.dataFinaliza,
    this.situacaoAsteca,
    this.tipoAsteca,
    this.documentoFiscal,
    this.motivoCriacaoAsteca,
    this.itensAsteca,
  });

  factory SolicitacaoAstecaModel.fromMap(Map<String, dynamic> map) {
    final List<dynamic>? listMap = map['itensAsteca'];
    final List<ItemSolicitacaoAsteca>? itensAst;
    if (listMap != null) {
      itensAst = listMap.map((e) => ItemSolicitacaoAsteca?.fromMap(e)).toList();
    } else {
      itensAst = null;
    }
    return SolicitacaoAstecaModel(
      idAsteca: map['idAsteca'],
      idProduto: map['idProduto'],
      descricaoProduto: map['descricaoProduto'],
      dataCriacao:  map['dataCriacao'] ?? '',
      dataInicioAsteca: map['dataInicioAsteca'] ?? '',
      dataCancela: map['dataCancela'] ?? '',
      dataFinaliza : map['dataFinaliza'] ?? '',
      situacaoAsteca: map['situacaoAsteca'],
      tipoAsteca: map['tipoAsteca'],
      documentoFiscal: map['documentoFiscal'] != null
          ? DocumentoFiscal.fromMap(map['documentoFiscal'])
          : null,
      motivoCriacaoAsteca: map['motivoCriacaoAsteca'] != null
          ? AstecaMotivo.fromMap(map['motivoCriacaoAsteca'])
          : null,
      itensAsteca: itensAst,
    );
  }

  SolicitacaoAstecaModel.fromJson(Map<String, dynamic> json) {
    idAsteca = json['idAsteca'];
    idProduto = json['idProduto'];
    descricaoProduto = json['descricaoProduto'];
    dataCriacao = json['dataCriacao'] ?? '';
    dataInicioAsteca = json['dataInicioAsteca'] ?? '';
    dataCancela = json['dataCancela'] ?? '';
    dataFinaliza = json['dataFinaliza'] ?? '';
    situacaoAsteca = json['situacaoAsteca'];
    tipoAsteca = json['tipoAsteca'];

    // Adaptando para o objeto DocumentoFiscal
    documentoFiscal = json['documentoFiscal'] != null
        ? DocumentoFiscal.fromJson(json['documentoFiscal'])
        : null;

    // Adaptando para o objeto AstecaMotivo
    motivoCriacaoAsteca = json['motivoCriacaoAsteca'] != null
        ? AstecaMotivo.fromJson(json['motivoCriacaoAsteca'])
        : null;
     itensAsteca = json['itensAsteca'].map<ItemSolicitacaoAsteca>((itens){
      return ItemSolicitacaoAsteca.fromJson(itens);
     }).toList();
  }

 @override
Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['idAsteca'] = idAsteca;
  data['idProduto'] = idProduto;
  data['descricaoProduto'] = descricaoProduto;
  data['dataCriacao'] = dataCriacao ?? '';
  data['dataInicioAsteca'] = dataInicioAsteca ?? '';
  data['dataCancela'] = dataCancela ?? '';
  data['dataFinaliza'] = dataFinaliza ?? '';
  data['situacaoAsteca'] = situacaoAsteca;
  data['tipoAsteca'] = tipoAsteca;
  // Adaptando para o objeto DocumentoFiscal
  data['documentoFiscal'] = documentoFiscal != null ? documentoFiscal!.toJson() : null;
  // Adaptando para o objeto AstecaMotivo
  data['motivoCriacaoAsteca'] = motivoCriacaoAsteca != null ? motivoCriacaoAsteca!.toJson() : null;
  // Adaptando para a lista de ItemSolicitacaoAsteca
  data['itensAsteca'] = itensAsteca?.map((e) {
    return e.toJson();
  }).toList();

  return data;
}


  @override
  toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
