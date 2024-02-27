import 'package:auth_migration/base/model/abstract_entity.dart';
import 'package:auth_migration/domain/model/item_documento_fiscal_model.dart';

class DocumentoFiscal extends AbstractEntity{
  int? idDocumentoFiscal;
  int? idFilialSaida;
  String? cpfCnpj;
  int? numDocFiscal;
  String? serieDocFiscal;
  String? dataEmissao;
  List<ItemDocumentoFiscal>? itens;
  String? descricao;
  String? fornecedor;

  DocumentoFiscal(
      {this.idDocumentoFiscal,
      this.idFilialSaida,
      this.cpfCnpj,
      this.numDocFiscal,
      this.serieDocFiscal,
      this.dataEmissao,
      this.itens,
      this.descricao,
      this.fornecedor});

  factory DocumentoFiscal.fromMap(Map<String, dynamic> map) {
    final List<dynamic>? itensList = map['itens'];
    final List<ItemDocumentoFiscal>? itensDoc;
    if (itensList != null) {
      itensDoc = itensList.map((e) => ItemDocumentoFiscal?.fromMap(e)).toList();
    } else {
      itensDoc = null;
    }
    return DocumentoFiscal(
      idDocumentoFiscal: map['idDocumentoFiscal'],
      idFilialSaida: map['idFilialSaida'],
      cpfCnpj: map['cpfCnpj'],
      numDocFiscal: map['numDocFiscal'],
      serieDocFiscal: map['serieDocFiscal'],
      dataEmissao: map['dataEmissao'],
      itens: itensDoc,
      descricao: map['descricao'],
      fornecedor: map['fornecedor']
    );
  }
  DocumentoFiscal.fromJson(Map<String,dynamic> json){
    idDocumentoFiscal = json['idDocumentoFiscal'];
    idFilialSaida = json['idFilialSaida'];
    cpfCnpj = json['cpfCnpj'];
    numDocFiscal = json['numDocFiscal'];
    serieDocFiscal = json['serieDocFiscal'];
    dataEmissao = json['dataEmissao'];
    itens = <ItemDocumentoFiscal>[];
    json['itens'].forEach((i) {
      itens?.add(ItemDocumentoFiscal.fromJson(i));
    });
    descricao = json['descricao'];
    fornecedor = json['fornecedor'];
  }
  
  @override
  toJson() {
    final Map<String,dynamic> data = <String,dynamic>{};
    data['idDocumentoFiscal'] = idDocumentoFiscal;
    data['idFilialSaida'] = idFilialSaida;
    data['cpfCnpj'] = cpfCnpj;
    data['numDocFiscal'] = numDocFiscal;
    data['serieDocFiscal'] = serieDocFiscal;
    data['dataEmissao'] = dataEmissao;
    data['itens'] = itens?.map((e) => e.toJson()).toList();
    data['descricao'] = descricao;
    data['fornecedor'] = fornecedor;
    return data;
  }
  
  @override
  toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
