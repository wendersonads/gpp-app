// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpp/src/models/pedido_entrada_model.dart';

import 'package:gpp/src/repositories/pedido_entrada_repository.dart';

import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'asteca_repository_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  dotenv.testLoad(fileInput: File("env").readAsStringSync());

  final api = MockApiService();
  final repository = PedidoEntradaRepository();

  group('Pedido de entrada: ', () {
    String dataReceived = '''{
    "pagina": {
        "total": 0,
        "atual": 1
    },
    "pedidos": [
        {
            "rn": "1",
            "id_pedido_entrada": 1,
            "id_asteca": "692535",
            "data_emissao": "2022-03-03T00:00:00.000000Z",
            "situacao": 1,
            "valor_total": null,
            "id_movimento_entrada": null,
            "id_funcionario": "1022189",
            "asteca": {
                "id_asteca": 692535,
                "tipo_asteca": 1,
                "id_filial_registro": 88,
                "observacao": "trocar peca de numero 3,divisao direita",
                "defeito_estado_prod": "trocar peca de numero 3,divisao direita",
                "data_emissao": "2021-12-18T00:00:00.000000Z",
                "produto": [
                    {
                        "id_produto": 62362,
                        "resumida": "BALCAO COOKTOP NT3050 1P 1G PRT BC/GRA",
                        "fornecedor": {
                            "id_fornecedor": 67105,
                            "cliente": {
                                "id_cliente": 13309722,
                                "nome": "INDUSTRIA DE MOVEIS NOTAVEL LTDA",
                                "cnpj_cpf": "00303732000150"
                            }
                        }
                    }
                ]
            },
            "items_pedido_entrada": [
                {
                    "id_item_pedido_entrada": 1,
                    "quantidade": 1,
                    "custo": null,
                    "id_pedido_entrada": "1",
                    "id_peca": "56779",
                    "peca": {
                        "id_peca": 56779,
                        "numero": "12",
                        "codigo_fabrica": "12",
                        "unidade": 1,
                        "descricao": "Peca Teste com produto",
                        "altura": 12,
                        "largura": 12,
                        "profundidade": 12,
                        "unidade_medida": 1,
                        "volumes": "1",
                        "active": 1,
                        "custo": 12,
                        "classificacao_custo": null,
                        "tipo_classificacao_custo": null,
                        "id_peca_material_fabricacao": "1",
                        "created_at": "2022-03-02T15:01:59.000000Z",
                        "updated_at": "2022-03-04T04:14:59.000000Z"
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 1022189,
                    "nome": "ALDAIR FERNANDO DE ARAUJO"
                }
            ]
        }
    ]
}''';

    test('Verifica a busca de ordens de entrada', () async {
      when(api.get(any)).thenAnswer((realInvocation) async => Response(dataReceived, 200));
      final resposta = await repository.buscarPedidosEntrada(1);
      expect(resposta, isA<List>());
    });

    dataReceived = '''
      {
    "id_pedido_entrada": 1,
    "id_asteca": "692535",
    "data_emissao": "2022-03-03T00:00:00.000000Z",
    "situacao": 1,
    "valor_total": null,
    "id_movimento_entrada": null,
    "id_funcionario": "1022189",
    "asteca": {
        "id_asteca": 692535,
        "tipo_asteca": 1,
        "id_filial_registro": 88,
        "observacao": "trocar peca de numero 3,divisao direita",
        "defeito_estado_prod": "trocar peca de numero 3,divisao direita",
        "data_emissao": "2021-12-18T00:00:00.000000Z"
    },
    "items_pedido_entrada": [
        {
            "id_item_pedido_entrada": 1,
            "quantidade": 1,
            "custo": null,
            "id_pedido_entrada": "1",
            "id_peca": "56779",
            "peca": {
                "id_peca": 56779,
                "numero": "12",
                "codigo_fabrica": "12",
                "unidade": 1,
                "descricao": "Peca Teste com produto",
                "altura": 12,
                "largura": 12,
                "profundidade": 12,
                "unidade_medida": 1,
                "volumes": "1",
                "active": 1,
                "custo": 12,
                "classificacao_custo": null,
                "tipo_classificacao_custo": null,
                "id_peca_material_fabricacao": "1",
                "created_at": "2022-03-02T15:01:59.000000Z",
                "updated_at": "2022-03-04T04:14:59.000000Z"
            }
        }
    ]
}
      ''';

    test('Verifica a busca de ordens de entrada utilizando o id como parâmetro', () async {
      when(api.get(any)).thenAnswer((realInvocation) async => Response(dataReceived, 200));
      final resposta = await repository.buscarPedidoEntrada(1);
      expect(resposta, isA<PedidoEntradaModel>());
    });

    test('Verifica a criação do pedido de entrada', () async {
      when(api.post(any, any)).thenAnswer((realInvocation) async => Response(dataReceived, 200));
      final resposta = await repository.criar(new PedidoEntradaModel());
      expect(resposta, isA<PedidoEntradaModel>());
    });

    // test('Verifica se não foi possível encontrar as astecas', () async {
    //   when(api.get(any))
    //       .thenAnswer((realInvocation) async => Response('', 404));

    //   expect(() async => await repository.buscar(1), throwsA(isA<Exception>()));
    // });
  });
}
