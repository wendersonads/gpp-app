import 'dart:convert';

class ImagemAvariaModel {
  int? idImagem;
  String? nome;
  String? base64;
  String? url;
  String? categoria;

  ImagemAvariaModel({
    this.idImagem,
    this.nome,
    this.base64,
    this.url,
    this.categoria,
  });

  ImagemAvariaModel.fromJson(Map<String, dynamic> json) {
    this.idImagem = json['id_midia_avaria'];
    this.nome = json['nome_imagem'];
    this.base64 = json['base64'];
    this.url = json['url_imagem'];
    this.categoria = json['categoria'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['id_midia_avaria'] = this.idImagem;
    data['nome_imagem'] = this.nome;
    data['base64'] = jsonEncode(this.base64);
    data['categoria'] = this.categoria;

    return data;
  }
}
