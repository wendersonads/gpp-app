import 'package:gpp/src/models/avaria/video_avaria_model.dart';
import 'package:gpp/src/models/avaria/imagem_avaria_model.dart';

class AvariaModel {
  int? idAvaria;
  int? idFilial;
  int? idProduto;
  int? ldDestino;
  int? ldOrigem;
  int? situacao;
  int? cor;
  String? descricaoAvaria;
  int? tipoAmassado;
  int? tipoArranhado;
  int? tipoQuebrado;
  int? tipoManchado;
  int? reSolicitador;
  int? reAprovador;
  int? usrCria;
  String? caminho_video;
  DateTime? dataCria;
  int? usrAlt;
  DateTime? dataAlt;

  List<VideoAvariaModel>? videos;
  List<ImagemAvariaModel>? imagens;

  AvariaModel({
    this.idAvaria,
    this.idFilial,
    this.idProduto,
    this.ldDestino,
    this.situacao,
    this.ldOrigem,
    this.cor,
    this.descricaoAvaria,
    this.tipoAmassado,
    this.tipoArranhado,
    this.tipoQuebrado,
    this.tipoManchado,
    this.reSolicitador,
    this.videos,
    this.imagens,
    this.reAprovador,
    this.usrCria,
    this.dataCria,
    this.usrAlt,
    this.dataAlt,
  });

  AvariaModel.fromJson(Map<String, dynamic> json) {
    idAvaria = json['id_avaria'];
    idFilial = json['id_filial'];
    idProduto = json['id_produto'];
    ldDestino = json['id_ld_destino'];
    situacao = json['situacao'];
    ldOrigem = json['id_ld_origem'];
    cor = json['id_cor'];
    descricaoAvaria = json['descricao'];
    tipoAmassado = json['tipo_amassado'];
    tipoArranhado = json['tipo_arranhado'];
    tipoQuebrado = json['tipo_quebrado'];
    tipoManchado = json['tipo_manchado'];
    reSolicitador = json['re_solicitador'];
    caminho_video = json['caminho_video'] ?? '';
    reAprovador = json['re_aprovador'];
    usrCria = json['usr_cria'];
    dataCria =
        json['data_cria'] != null ? DateTime.parse(json['data_cria']) : null;
    usrAlt = json['usr_alt'];
    dataAlt =
        json['data_alt'] != null ? DateTime.parse(json['data_alt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_avaria'] = this.idAvaria;
    data['id_filial'] = this.idFilial;
    data['id_produto'] = this.idProduto;
    data['id_ld_destino'] = this.ldDestino;
    data['id_ld_origem'] = this.ldOrigem;
    data['situacao'] = this.situacao;
    data['id_cor'] = this.cor;
    data['descricao'] = this.descricaoAvaria;
    data['tipo_amassado'] = this.tipoAmassado;
    data['tipo_arranhado'] = this.tipoArranhado;
    data['tipo_quebrado'] = this.tipoQuebrado;
    data['tipo_manchado'] = this.tipoManchado;
    data['re_solicitador'] = this.reSolicitador;
    data['video_avaria'] = this.videos != null
        ? this.videos!.map((video) => video.toJson()).toList()
        : [];
    data['imagem_avaria'] = this.imagens != null
        ? this.imagens!.map((imagens) => imagens.toJson()).toList()
        : [];
    data['re_aprovador'] = this.reAprovador;
    data['usr_cria'] = this.usrCria;
    data['data_cria'] = this.dataCria;
    data['usr_alt'] = this.usrAlt;
    data['data_alt'] = this.dataAlt;
    return data;
  }
}
