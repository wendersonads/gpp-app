import 'package:auth_migration/base/model/abstract_entity.dart';
import 'package:auth_migration/domain/model/produto_model.dart';

class ItemDocumentoFiscal extends AbstractEntity{
  int? idItemDocFiscal;
  Produto? produto;
  int? qtde;
  double? valorVenda;
  
  ItemDocumentoFiscal({
    this.idItemDocFiscal,this.produto,this.qtde,this.valorVenda
  });

  factory ItemDocumentoFiscal.fromMap(Map<String,dynamic> map){
    return ItemDocumentoFiscal(
      idItemDocFiscal: map['idItemDocFiscal'],
      produto: map['produto'] != null ? Produto.fromMap(map['produto']) : null,
      qtde: map['qtde'],
      valorVenda: map['valorVenda'],
      );
  }

  ItemDocumentoFiscal.fromJson(Map<String,dynamic> json){
    idItemDocFiscal = json['idItemDocFiscal'];
    produto = json['produto'] != null ? Produto.fromJson(json['produto']) : null;
    qtde = json['qtde'];
    valorVenda = json['valorVenda'];

  }
  
  @override
  toJson() {
    final Map<String,dynamic> data = <String,dynamic>{};
    data['idItemDocFiscal'] = idItemDocFiscal;
    data['produto'] = produto != null ? produto!.toJson() : null;
    data['qtde'] = qtde;
    data['valorVenda'] = valorVenda;
    return data;
  }
  
  @override
  toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
} 