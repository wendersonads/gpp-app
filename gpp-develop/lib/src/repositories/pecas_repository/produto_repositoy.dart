import 'dart:convert';

import 'package:gpp/src/models/PecaEstoqueModel.dart';
import 'package:gpp/src/models/box_enderecamento_model.dart';
import 'package:gpp/src/models/pecas_model/peca_model.dart';
import 'package:gpp/src/models/PaginaModel.dart';
import 'package:gpp/src/models/produto_peca_model.dart';
import 'package:gpp/src/models/produto/produto_model.dart';

import 'package:gpp/src/shared/repositories/status_code.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';
import 'package:universal_html/html.dart' as html;

class ProdutoRepository {
  late ApiService api;

  ProdutoRepository() {
    api = ApiService();
  }

  Future<List> buscarProdutos(int pagina, {String? pesquisar}) async {
    Map<String, String> queryParameters = {
      'pagina': pagina.toString(),
      'pesquisar': pesquisar ?? '',
    };

    Response response = await api.get('/produtos', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<ProdutoModel> produtos = data['dados'].map<ProdutoModel>((data) => ProdutoModel.fromJson(data)).toList();

      PaginaModel pagina = PaginaModel.fromJson(data['pagina']);
      return [produtos, pagina];
    } else {
      var error = json.decode(response.body)['error'];
      throw error;
    }
  }

  Future<ProdutoModel> buscarProduto(int id) async {
    Response response = await api.get('/produtos/${id}');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      return ProdutoModel.fromJson(data);
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  void downloadTemplate(int idProduto) async {
    Response response = await api.get('/produtos/${idProduto}/template');

    if (response.statusCode == StatusCode.OK) {
      final blob = html.Blob([response.bodyBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = 'template-pecas.csv';
      html.document.body!.children.add(anchor);

      anchor.click();

      html.document.body!.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

//remover depois
  Future<ProdutoModel> buscar(String id) async {
    Response response = await api.get('/produtos/${id}');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      return ProdutoModel.fromJson(data);
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> inserirProdutoPecas(int id, ProdutoModel produto) async {
    Response response = await api.post('/produtos/${id}/pecas', produto.toJson());

    if (response.statusCode == StatusCode.OK) {
      //var data = jsonDecode(response.body);
      return true;
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  Future<List<ProdutoPecaModel>> buscarProdutoPecas(int idProduto, {String? pesquisar}) async {
    Map<String, String> queryParameters = {
      'pesquisar': pesquisar ?? '',
    };

    Response response = await api.get('/produtos/${idProduto}/pecas', queryParameters: queryParameters);

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<ProdutoPecaModel> produtoPecas = data.map<ProdutoPecaModel>((data) => ProdutoPecaModel.fromJson(data)).toList();
      return produtoPecas;
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  Future<List<ProdutoPecaModel>> buscarProdutoPecasFornecedor(int idProduto, int idFornecedor) async {
    Response response = await api.get('/produtos/${idProduto}/pecas/fornecedor/${idFornecedor}');

    if (response.statusCode == StatusCode.OK) {
      var data = jsonDecode(response.body);

      List<ProdutoPecaModel> produtoPecas = data.map<ProdutoPecaModel>((data) => ProdutoPecaModel.fromJson(data)).toList();
      return produtoPecas;
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }

  Future<bool> deletarProdutoPeca(int idProduto, int idPeca) async {
    Response response = await api.delete('/produtos/${idProduto}/pecas/${idPeca}');

    if (response.statusCode == StatusCode.OK) {
      return true;
    } else {
      var error = jsonDecode(response.body)['error'];
      throw error;
    }
  }
}

tratarMeuEstoque(List<ProdutoPecaModel>? p) async {
  List<ProdutoPecaModel> novaLista = [];

  p!.forEach((pp) {
    if (pp.peca!.estoque!.isEmpty) {
      pp.peca!.estoqueUnico = null;
      novaLista.add(pp);
    } else {
      pp.peca?.estoque!.forEach((element) {
        PecasModel peca;
        peca = new PecasModel(
            active: pp.peca!.active,
            altura: pp.peca!.altura,
            classificacao_custo: pp.peca!.classificacao_custo,
            codigo_fabrica: pp.peca!.codigo_fabrica,
            cor: pp.peca!.cor,
            custo: pp.peca!.custo,
            descricao: pp.peca!.descricao,
            especie: pp.peca!.especie,
            estoque: null,
            estoqueUnico: PecaEstoqueModel(
              idPecaEstoque: element.idPecaEstoque,
              saldoDisponivel: element.saldoDisponivel,
              saldoReservado: element.saldoReservado,
              endereco: element.endereco,
              box: element.box != null
                  ? new BoxEnderecamentoModel(
                      id_box: element.box!.id_box,
                      altura: element.box!.altura,
                      desc_box: element.box!.desc_box,
                      largura: element.box!.largura,
                      profundidade: element.box!.profundidade,
                      unidade_medida: element.box!.unidade_medida,
                      id_prateleira: element.box!.id_prateleira != null ? element.box!.id_prateleira : null,
                      prateleira: null,
                      created_at: element.box!.created_at,
                    )
                  : null,
            ),
            id_peca: pp.peca!.id_peca,
            id_peca_cor: pp.peca!.id_peca_cor,
            id_peca_especie: pp.peca!.id_peca_especie,
            id_peca_material_fabricacao: pp.peca!.id_peca_material_fabricacao,
            largura: pp.peca!.largura,
            material_fabricacao: pp.peca!.material_fabricacao,
            numero: pp.peca!.numero,
            pecasCorModel: pp.peca!.pecasCorModel,
            pecasEspecieModel: pp.peca!.pecasEspecieModel,
            pecasMaterialModel: pp.peca!.pecasMaterialModel,
            produtoPeca: pp.peca!.produtoPeca,
            produto_peca: pp.peca!.produto_peca,
            profundidade: pp.peca!.profundidade,
            tipo_classificacao_custo: pp.peca!.tipo_classificacao_custo,
            unidade: pp.peca!.unidade,
            unidade_medida: pp.peca!.unidade_medida,
            volumes: pp.peca!.volumes);
        novaLista.add(ProdutoPecaModel(
            idProdutoPeca: pp.idProdutoPeca,
            id_produto: pp.idProdutoPeca,
            peca: peca,
            quantidadePorProduto: pp.quantidadePorProduto));
        //print("meu saldo: ${produtoPeca.peca!.id_peca} ${produtoPeca.peca!.estoqueUnico!.saldoDisponivel}");
      });
    }
  });
  return novaLista;
}
