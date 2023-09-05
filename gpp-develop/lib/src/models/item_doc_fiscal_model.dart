class ItemDocFiscalModel {
  int? idLd;

  ItemDocFiscalModel({this.idLd});

  ItemDocFiscalModel.fromJson(Map<String, dynamic> json) {
    idLd = json['id_ld'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_ld'] = this.idLd;
    return data;
  }
}
