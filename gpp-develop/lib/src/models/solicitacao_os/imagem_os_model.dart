import 'dart:convert';

class ImagemOSModel {
  int? idImagem;
  String? nome;
  String? base64;
  String? url;
  String? categoria;

  ImagemOSModel({
    this.idImagem,
    this.nome,
    this.base64,
    this.url,
    this.categoria,
  });

  ImagemOSModel.fromJson(Map<String, dynamic> json) {
    this.idImagem = json['id_solicitacao_os_imagem'];
    this.nome = json['nome_imagem'];
    this.base64 = json['base64'];
    this.url = json['url_imagem'];
    this.categoria = json['id_categoria_imagem'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['id_solicitacao_os_imagem'] = this.idImagem;
    data['nome_imagem'] = this.nome;
    data['base64'] = jsonEncode(this.base64);
    data['id_categoria_imagem'] = this.categoria;

    return data;
  }
}
