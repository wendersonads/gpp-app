import 'dart:convert';

class VideoAvariaModel {
  int? idVideo;
  String? nome;
  String? base64;
  String? url;

  VideoAvariaModel({
    this.idVideo,
    this.nome,
    this.base64,
    this.url,
  });

  VideoAvariaModel.fromJson(Map<String, dynamic> json) {
    this.idVideo = json['id_video_avaria'];
    this.nome = json['nome_video'];
    this.base64 = json['base64'];
    this.url = json['url_video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['id_video_avaria'] = this.idVideo;
    data['nome_video'] = this.nome;
    data['base64'] = jsonEncode(this.base64);

    return data;
  }
}
