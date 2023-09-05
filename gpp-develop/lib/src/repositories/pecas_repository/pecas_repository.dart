// // // import 'dart:convert';

// // // import 'package:gpp/src/models/pecas_model/peca_model.dart';
// // // import 'package:gpp/src/models/pecas_model/pecas_pagina_model.dart';
// // // import 'package:gpp/src/models/pecas_model/produto_peca_model.dart';
// // // import 'package:gpp/src/shared/repositories/status_code.dart';
// // // import 'package:gpp/src/shared/services/gpp_api.dart';
// // // import 'package:http/http.dart';

// // // class PecasRepository {
// // //   ApiService api;

// // //   PecasRepository({
// // //     required this.api,
// // //   });

// // //   // Future<bool> criar(PecasModel pecas) async {
// // //   //   print(jsonEncode(pecas.toJson()));
// // //   //   Response response = await api.post('/pecas', pecas.toJson());

// // //   //   print(jsonDecode(response.body));

// // //   //   if (response.statusCode == StatusCode.OK) {
// // //   //     return true;
// // //   //   } else {
// // //   //     throw 'Ocorreu um erro ao criar uma peça';
// // //   //   }
// // //   // }

// // //   Future<PecasModel> criarPeca(PecasModel pecas) async {
// // //     //  print(jsonEncode(pecas.toJson()));
// // //     Response response = await api.post('/pecas', pecas.toJson());

// // //     var data = jsonDecode(response.body);

// // //     if (response.statusCode == StatusCode.OK) {
// // //       PecasModel pecas = PecasModel.fromJson(data);

// // //       return pecas;
// // //     } else {
// // //       throw 'Ocorreu um erro ao criar uma peça';
// // //     }
// // //   }

// // //   Future<bool> criarProdutoPeca(ProdutoPecaModel produtoPecaModel) async {
// // //     print(jsonEncode(produtoPecaModel.toJson()));

// // //     Response response =
// // //         await api.post('/pecas/00/produto-peca', produtoPecaModel.toJson());

// // //     if (response.statusCode == StatusCode.OK) {
// // //       return true;
// // //     } else {
// // //       throw 'Ocorreu um erro ao criar um produto peça';
// // //     }
// // //   }

// // //   Future<List> buscarTodos(int pagina) async {
// // //     Map<String, String> queryParameters = {
// // //       'page': pagina.toString(),
// // //     };

// // //     Response response =
// // //         await api.get('/pecas', queryParameters: queryParameters);

// // //     //print(response.body);

// // //     if (response.statusCode == StatusCode.OK) {
// // //       var data = jsonDecode(response.body);
// // //       //print(data["data"]);
// // //       // print(jsonDecode(response.body));

// // //       // Fazer trazer array no model
// // //       List<PecasModel> pecas = data["data"]
// // //           .map<PecasModel>((data) => PecasModel.fromJson(data))
// // //           .toList();

// // //       PecasPaginaModel pecasPagina = PecasPaginaModel.fromJson(data);

// // //       return [pecas, pecasPagina];
// // //     } else {
// // //       var error = json.decode(response.body)['error'];
// // //       throw error;
// // //     }
// // //   }

// // //   Future<bool> editar(PecasModel pecasModel) async {
// // //     print(jsonEncode(pecasModel.toJson()));

// // //     Response response =
// // //         await api.put('/pecas/${pecasModel.id_peca}', pecasModel.toJson());

// // //     if (response.statusCode == StatusCode.OK) {
// // //       return true;
// // //     } else {
// // //       throw 'Ocorreu um erro ao editar uma peça';
// // //     }
// // //   }

// // //   Future<bool> editarProdutoPeca(ProdutoPecaModel produtoPecaModel) async {
// // //     print(jsonEncode(produtoPecaModel.toJson()));

// // //     Response response = await api.put(
// // //         '/pecas/${produtoPecaModel.id_peca}/produto-peca/${produtoPecaModel.id_produto_peca}',
// // //         produtoPecaModel.toJson());

// // //     if (response.statusCode == StatusCode.OK) {
// // //       return true;
// // //     } else {
// // //       throw 'Ocorreu um erro ao editar um produto peça';
// // //     }
// // //   }

// // //   Future<PecasModel> buscar(String codigo) async {
// // //     Response response = await api.get('/pecas/' + codigo);

// // //     print(response.body);

// // //     if (response.statusCode == StatusCode.OK) {
// // //       var data = jsonDecode(response.body);

// // //       PecasModel pecas = PecasModel.fromJson(data);

// // //       return pecas;
// // //     } else {
// // //       var error = json.decode(response.body)['error'];
// // //       throw error;
// // //     }
// // //   }

// // //   Future<bool> excluir(PecasModel pecasModel) async {
// // //     Response response =
// // //         await api.delete('/pecas/' + pecasModel.id_peca.toString());

// // //     if (response.statusCode == StatusCode.OK) {
// // //       print(response.body);
// // //       return true;
// // //     } else {
// // //       var error = json.decode(response.body)['error'];
// // //       throw Exception(error);
// // //     }
// // //   }
// // // }
