class MotivoPecas {
  int? idMotivo;
  String? nome;
  bool? situacao;
  int? tipo_motivo;
  MotivoPecas({this.idMotivo, this.nome, this.situacao, this.tipo_motivo});

  factory MotivoPecas.fromJson(Map<String, dynamic> json) {
    return MotivoPecas(
      idMotivo: json['id_motivo'],
      nome: json['nome'],
      situacao: json['situacao'],
      tipo_motivo: json['tipo_motivo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_motivo'] = idMotivo;
    data['nome'] = nome;
    data['situacao'] = situacao;
    return data;
  }
}