// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpp/src/models/asteca/asteca_model.dart';

import 'package:gpp/src/repositories/AstecaRepository.dart';

import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'asteca_repository_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  dotenv.testLoad(fileInput: File("env").readAsStringSync());

  final api = MockApiService();
  final repository = AstecaRepository();

  group('Astecas: ', () {
    String dataReceived = '''{
    "pagina": {
        "total": 47,
        "atual": 1
    },
    "astecas": [
        {
            "id_asteca": 687924,
            "tipo_asteca": 1,
            "id_filial_registro": 500,
            "observacao": "PEÇA QUEBRADA",
            "defeito_estado_prod": "CÓD.15520 - PUXADOR ALUMINIO",
            "data_emissao": "2021-10-07T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1044590,
                "logradouro": "RUA GENERAL OSORIO NR 1 QD-Y1 LT-15",
                "localidade": "GOIANIA",
                "numero": 1,
                "complemento": "QD-Y1 LT-15",
                "bairro": "VILA CONCORDIA",
                "uf": "GO",
                "cep": 74770350,
                "ponto_referencia_1": null,
                "ponto_referencia_2": null,
                "ddd": 62,
                "telefone": 994907199
            },
            "asteca_motivo": null,
            "documento_fiscal": {
                "id_documento_fiscal": 62397354,
                "id_filial_saida": 515,
                "id_filial_venda": 1748,
                "id_cliente": "13924252",
                "nome": "LYLIAN TAVARES PEREIRA",
                "cpf_cnpj": "70807959154",
                "num_doc_fiscal": 4569496,
                "serie_doc_fiscal": "10",
                "data_emissao": "2020-02-13T13:35:43.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 4
                },
                "cliente": {
                    "id_cliente": 13924252,
                    "cnpj_cpf": "70807959154",
                    "nome": "LYLIAN TAVARES PEREIRA"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "120088",
                    "id_produto": "58414",
                    "produto": {
                        "id_produto": 58414,
                        "resumida": "G ROUPA GHAIA STATUS 2P C/ESP PES AME/BC",
                        "id_fornecedor": "14584",
                        "fornecedores": [
                            {
                                "id_fornecedor": 14584,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 7433048,
                                    "nome": "MOVEIS BOM PASTOR LTDA",
                                    "e_mail": "nfe@bompastor.ind.br",
                                    "cnpj_cpf": "01610917000332"
                                }
                            },
                            {
                                "id_fornecedor": 14584,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 5580205,
                                    "nome": "MOVEIS BOM PASTOR LTDA",
                                    "e_mail": "nfe@bompastor.ind.br",
                                    "cnpj_cpf": "01610917000413"
                                }
                            },
                            {
                                "id_fornecedor": 14584,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 4668618,
                                    "nome": "MOVEIS BOM PASTOR LTDA",
                                    "e_mail": "nfe@bompastor.ind.br",
                                    "cnpj_cpf": "01610917000251"
                                }
                            },
                            {
                                "id_fornecedor": 14584,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 3543535,
                                    "nome": "MOVEIS BOM PASTOR LTDA",
                                    "e_mail": "nfe@bompastor.ind.br",
                                    "cnpj_cpf": "01610917000170"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 1031386,
                    "nome": "LYLIAN TAVARES PEREIRA"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "687924",
                        "id_tipo_pendencia": "3622"
                    }
                },
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "687924",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 687752,
            "tipo_asteca": 1,
            "id_filial_registro": 500,
            "observacao": "1 CORREDICA TELESCOPICA N3196 VEIO COM DEFEITO.",
            "defeito_estado_prod": "1 CORREDICA TELESCOPICA N3196 VEIO COM DEFEITO.",
            "data_emissao": "2021-10-05T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1044443,
                "logradouro": "1 RUA TUPI NR.0 Q 31 L 32",
                "localidade": "GOIANIA",
                "numero": 0,
                "complemento": "Q 31 L 32",
                "bairro": "SETOR URIAS MAGALHAES",
                "uf": "GO",
                "cep": 74565650,
                "ponto_referencia_1": null,
                "ponto_referencia_2": null,
                "ddd": 62,
                "telefone": 999045259
            },
            "asteca_motivo": {
                "id_asteca_motivo": 14,
                "denominacao": "MOTIVO CRIADO PELO SISMA"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 66297433,
                "id_filial_saida": 515,
                "id_filial_venda": 20,
                "id_cliente": "2687103",
                "nome": "MARIA BETANIA PEREIRA DA SILVA",
                "cpf_cnpj": "40446565334",
                "num_doc_fiscal": 5316826,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-09-30T10:33:50.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 2687103,
                    "cnpj_cpf": "40446565334",
                    "nome": "MARIA BETANIA PEREIRA DA SILVA"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "120085",
                    "id_produto": "58411",
                    "produto": {
                        "id_produto": 58411,
                        "resumida": "COMODA KING 5GAV C/PES AMENDOA",
                        "id_fornecedor": "14584",
                        "fornecedores": [
                            {
                                "id_fornecedor": 14584,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 7433048,
                                    "nome": "MOVEIS BOM PASTOR LTDA",
                                    "e_mail": "nfe@bompastor.ind.br",
                                    "cnpj_cpf": "01610917000332"
                                }
                            },
                            {
                                "id_fornecedor": 14584,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 5580205,
                                    "nome": "MOVEIS BOM PASTOR LTDA",
                                    "e_mail": "nfe@bompastor.ind.br",
                                    "cnpj_cpf": "01610917000413"
                                }
                            },
                            {
                                "id_fornecedor": 14584,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 4668618,
                                    "nome": "MOVEIS BOM PASTOR LTDA",
                                    "e_mail": "nfe@bompastor.ind.br",
                                    "cnpj_cpf": "01610917000251"
                                }
                            },
                            {
                                "id_fornecedor": 14584,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 3543535,
                                    "nome": "MOVEIS BOM PASTOR LTDA",
                                    "e_mail": "nfe@bompastor.ind.br",
                                    "cnpj_cpf": "01610917000170"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 99803223,
                    "nome": "PROATIVA INTERMEDICOES EIRELI"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "687752",
                        "id_tipo_pendencia": "3622"
                    }
                },
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "687752",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 686459,
            "tipo_asteca": 1,
            "id_filial_registro": 61,
            "observacao": "MONTADO",
            "defeito_estado_prod": "PORTA N67 VEIO COM FURAÇÃO ERRADA",
            "data_emissao": "2021-09-20T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1042896,
                "logradouro": "1 AV PORTO ALEGRE NR 1158 QD. 72 LT. 19 NR.1158 QD. 72 LT. 19",
                "localidade": "PRIMAVERA DO LESTE",
                "numero": 1158,
                "complemento": "QD. 72 LT. 19",
                "bairro": "CENTRO",
                "uf": "MT",
                "cep": 78850000,
                "ponto_referencia_1": null,
                "ponto_referencia_2": null,
                "ddd": 66,
                "telefone": 997175461
            },
            "asteca_motivo": {
                "id_asteca_motivo": 32,
                "denominacao": "MONTAGEM E DESMONTAGEM PRODUTOS/ESTOFADOS/PROD.SEM AVARIA"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 66210560,
                "id_filial_saida": 61,
                "id_filial_venda": 61,
                "id_cliente": "14356213",
                "nome": "ILDSON FERNANDES DA SILVA",
                "cpf_cnpj": "06527683189",
                "num_doc_fiscal": 9843,
                "serie_doc_fiscal": "11",
                "data_emissao": "2021-09-14T13:45:43.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 14356213,
                    "cnpj_cpf": "06527683189",
                    "nome": "ILDSON FERNANDES DA SILVA"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "123270",
                    "id_produto": "61596",
                    "produto": {
                        "id_produto": 61596,
                        "resumida": "G ROUPA NEW MAFRA PLUS 6P 2G CAST WO/OFF",
                        "id_fornecedor": "470",
                        "fornecedores": [
                            {
                                "id_fornecedor": 470,
                                "enviado": "2",
                                "cli_forn_principal": "1",
                                "cliente": {
                                    "id_cliente": 367,
                                    "nome": "MOVAL-MOVEIS ARAPONGAS LTDA",
                                    "e_mail": "nfemoval@moval.com.br",
                                    "cnpj_cpf": "75400903000169"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 1030823,
                    "nome": "ANDRESSA DIAS DO NASCIMENTO"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "686459",
                        "id_tipo_pendencia": "3622"
                    }
                },
                {
                    "id_tipo_pendencia": 3500,
                    "descricao": "PEÇAS EM SEPARAÇÃO NO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "DBANM",
                    "data_cria": "2014-05-12 13:58:44",
                    "usr_alt": "18331",
                    "data_alt": "2019-06-06 16:13:00",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "686459",
                        "id_tipo_pendencia": "3500"
                    }
                },
                {
                    "id_tipo_pendencia": 651,
                    "descricao": "PECA SOLICITADA AO FORNECEDOR",
                    "situacao": "1",
                    "usr_cria": "DBANM",
                    "data_cria": "2014-05-12 13:58:44",
                    "usr_alt": "18000",
                    "data_alt": "2016-10-11 07:29:14",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "686459",
                        "id_tipo_pendencia": "651"
                    }
                },
                {
                    "id_tipo_pendencia": 3625,
                    "descricao": "AGUARDANDO MOTORISTA CD",
                    "situacao": "1",
                    "usr_cria": "1029456",
                    "data_cria": "2018-12-28 09:20:34",
                    "usr_alt": "18331",
                    "data_alt": "2021-03-19 16:52:08",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "686459",
                        "id_tipo_pendencia": "3625"
                    }
                },
                {
                    "id_tipo_pendencia": 3613,
                    "descricao": "PEÇAS ENVIADA PARA LOJA (MOSTRUARIO DE LOJA)",
                    "situacao": "1",
                    "usr_cria": "586",
                    "data_cria": "2014-11-20 08:06:01",
                    "usr_alt": "18331",
                    "data_alt": "2020-12-11 10:31:41",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "686459",
                        "id_tipo_pendencia": "3613"
                    }
                },
                {
                    "id_tipo_pendencia": 3623,
                    "descricao": "PEÇA ENVIADA (500) ERRADA/AVARIADA",
                    "situacao": "1",
                    "usr_cria": "18331",
                    "data_cria": "2017-07-28 10:55:49",
                    "usr_alt": "18331",
                    "data_alt": "2017-07-28 10:57:05",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "686459",
                        "id_tipo_pendencia": "3623"
                    }
                }
            ]
        },
        {
            "id_asteca": 684804,
            "tipo_asteca": 1,
            "id_filial_registro": 541,
            "observacao": "troca um encosto de uma cadeira q veio rasgada dentro da embalagem",
            "defeito_estado_prod": "troca um encosto de uma cadeira q veio rasgada dentro da embalagem",
            "data_emissao": "2021-08-25T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1040656,
                "logradouro": "1 RUA CINCO NR.9 QD-21",
                "localidade": "SAO LUIS",
                "numero": 9,
                "complemento": "QD-21",
                "bairro": "IPEM SAO CRISTOVAO",
                "uf": "MA",
                "cep": 65055284,
                "ponto_referencia_1": "EM FRENTE AO BAR BODEGA DOS AMIGOS",
                "ponto_referencia_2": null,
                "ddd": 98,
                "telefone": 987678399
            },
            "asteca_motivo": {
                "id_asteca_motivo": 14,
                "denominacao": "MOTIVO CRIADO PELO SISMA"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 66064291,
                "id_filial_saida": 540,
                "id_filial_venda": 275,
                "id_cliente": "14580242",
                "nome": "CONCEICAO DE MARIA LIMA DA SILVA",
                "cpf_cnpj": "42881234372",
                "num_doc_fiscal": 799662,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-08-21T11:51:35.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 14580242,
                    "cnpj_cpf": "42881234372",
                    "nome": "CONCEICAO DE MARIA LIMA DA SILVA"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "118830",
                    "id_produto": "57156",
                    "produto": {
                        "id_produto": 57156,
                        "resumida": "CJ SALA CRONOS 180X90 7PCS VDOCAST TC BE",
                        "id_fornecedor": "17530",
                        "fornecedores": [
                            {
                                "id_fornecedor": 17530,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 4042411,
                                    "nome": "LJ MOVEIS LTDA",
                                    "e_mail": "vendas@ljmoveis.com.br",
                                    "cnpj_cpf": "01792254000152"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 7002612,
                    "nome": "FRANCISCO RICARDO RIBEIRO FERREIRA"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "684804",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 684826,
            "tipo_asteca": 1,
            "id_filial_registro": 441,
            "observacao": "CORREDIÇA CEDEU",
            "defeito_estado_prod": "TROCAR 01 PAR DE CORREDIÇAS",
            "data_emissao": "2021-08-25T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1040671,
                "logradouro": "1 R SEGUNDA NR.38 PROX A ARENA DO ROGERIO",
                "localidade": "ANANINDEUA",
                "numero": 38,
                "complemento": "PROX A ARENA DO ROGERIO",
                "bairro": "MAGUARI",
                "uf": "PA",
                "cep": 67145280,
                "ponto_referencia_1": "ENTRE BOA VISTA E SANTAREM",
                "ponto_referencia_2": null,
                "ddd": 91,
                "telefone": 981993592
            },
            "asteca_motivo": {
                "id_asteca_motivo": 8,
                "denominacao": "DEFEITO DE FABRICAÇÃO"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 65767725,
                "id_filial_saida": 547,
                "id_filial_venda": 407,
                "id_cliente": "14524148",
                "nome": "MARINELMA MARTINS DA SILVA",
                "cpf_cnpj": "78663644272",
                "num_doc_fiscal": 722420,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-07-07T07:11:44.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 14524148,
                    "cnpj_cpf": "78663644272",
                    "nome": "MARINELMA MARTINS DA SILVA"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "126498",
                    "id_produto": "64824",
                    "produto": {
                        "id_produto": 64824,
                        "resumida": "COZ CLEAN 3PCS C/VDO GRAFITE",
                        "id_fornecedor": "72",
                        "fornecedores": [
                            {
                                "id_fornecedor": 72,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 13638771,
                                    "nome": "ITATIAIA MOVEIS S/A",
                                    "e_mail": null,
                                    "cnpj_cpf": "25331521001205"
                                }
                            },
                            {
                                "id_fornecedor": 72,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 9398126,
                                    "nome": "ITATIAIA MOVEIS S/A",
                                    "e_mail": null,
                                    "cnpj_cpf": "25331521001124"
                                }
                            },
                            {
                                "id_fornecedor": 72,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 7161735,
                                    "nome": "ITATIAIA MOVEIS S/A",
                                    "e_mail": null,
                                    "cnpj_cpf": "25331521001043"
                                }
                            },
                            {
                                "id_fornecedor": 72,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 1767982,
                                    "nome": "ITATIAIA MOVEIS S/A",
                                    "e_mail": null,
                                    "cnpj_cpf": "42666058620"
                                }
                            },
                            {
                                "id_fornecedor": 72,
                                "enviado": "2",
                                "cli_forn_principal": "1",
                                "cliente": {
                                    "id_cliente": 4744,
                                    "nome": "ITATIAIA MOVEIS S/A",
                                    "e_mail": "adriana.ribeiro@cozinhasitatiaia.com.br",
                                    "cnpj_cpf": "25331521000152"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 7001262,
                    "nome": "GLEIDSON ANDRE LIMA PANTOJA"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "684826",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 684363,
            "tipo_asteca": 1,
            "id_filial_registro": 548,
            "observacao": "NAO MONTADO",
            "defeito_estado_prod": "TROCA DE 02 PORTAS PEÇA 14159 DO VL 3/5 AVARIADAS \nCRM 210817-003597",
            "data_emissao": "2021-08-19T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1040134,
                "logradouro": "1 AVENIDA MAX TEIXEIRA NR.2900 PROCURAR SILENE",
                "localidade": "MANAUS",
                "numero": 2900,
                "complemento": "PROCURAR SILENE",
                "bairro": "FLORES",
                "uf": "AM",
                "cep": 69058415,
                "ponto_referencia_1": "NOS FUNDOS DA LOJA AIBARA",
                "ponto_referencia_2": null,
                "ddd": 92,
                "telefone": 994203854
            },
            "asteca_motivo": {
                "id_asteca_motivo": 8,
                "denominacao": "DEFEITO DE FABRICAÇÃO"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 66018257,
                "id_filial_saida": 548,
                "id_filial_venda": 425,
                "id_cliente": "14573332",
                "nome": "LUANA BEATRIZ CARVALHO ESQUERDO",
                "cpf_cnpj": "04785358211",
                "num_doc_fiscal": 371604,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-08-14T11:02:00.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 14573332,
                    "cnpj_cpf": "04785358211",
                    "nome": "LUANA BEATRIZ CARVALHO ESQUERDO"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "112460",
                    "id_produto": "50786",
                    "produto": {
                        "id_produto": 50786,
                        "resumida": "G ROUPA RESIDENCE 3PTS ESP/PES BRANCO",
                        "id_fornecedor": "1850",
                        "fornecedores": [
                            {
                                "id_fornecedor": 1850,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 14664422,
                                    "nome": "DEMOBILE INDUSTRIA DE MOVEIS LTDA",
                                    "e_mail": "contabil@demobile.com.br",
                                    "cnpj_cpf": "75069849000625"
                                }
                            },
                            {
                                "id_fornecedor": 1850,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 2554063,
                                    "nome": "DEMOBILE INDUSTRIA DE MOVEIS LTDA",
                                    "e_mail": "recebenfe@demobile.com.br",
                                    "cnpj_cpf": "75069849000110"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 7005690,
                    "nome": "DAYSE LIRA SANTOS IONARIA"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "684363",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 684226,
            "tipo_asteca": 1,
            "id_filial_registro": 529,
            "observacao": "MONTADO",
            "defeito_estado_prod": "TROCAR UMA LATERAL DIREITA  CODIGO 14 . VEIO COM O CANTO QUEBRADO PROVAVELMENTE NO TRASPORTE\n E UMA BUCHA DE FIXACAO PARA ESPELHO CODIGO \"QB\" .",
            "data_emissao": "2021-08-18T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1039985,
                "logradouro": "1 QUADRA QR 210 CONJUNTO D NR.14 CASA 14",
                "localidade": "BRASILIA",
                "numero": 14,
                "complemento": "CASA 14",
                "bairro": "SANTA MARIA",
                "uf": "DF",
                "cep": 72510404,
                "ponto_referencia_1": "PROXIMO IGREJA UNIVERSAL",
                "ponto_referencia_2": null,
                "ddd": 61,
                "telefone": 991178671
            },
            "asteca_motivo": {
                "id_asteca_motivo": 8,
                "denominacao": "DEFEITO DE FABRICAÇÃO"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 66023525,
                "id_filial_saida": 529,
                "id_filial_venda": 94,
                "id_cliente": "4711545",
                "nome": "VILMA MARIA DA SILVA",
                "cpf_cnpj": "95626280197",
                "num_doc_fiscal": 1386364,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-08-16T05:10:54.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 4711545,
                    "cnpj_cpf": "95626280197",
                    "nome": "VILMA MARIA DA SILVA"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "123252",
                    "id_produto": "61578",
                    "produto": {
                        "id_produto": 61578,
                        "resumida": "G ROUPA DESTAQUE 4P 6G C/ESP EBANO",
                        "id_fornecedor": "1850",
                        "fornecedores": [
                            {
                                "id_fornecedor": 1850,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 14664422,
                                    "nome": "DEMOBILE INDUSTRIA DE MOVEIS LTDA",
                                    "e_mail": "contabil@demobile.com.br",
                                    "cnpj_cpf": "75069849000625"
                                }
                            },
                            {
                                "id_fornecedor": 1850,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 2554063,
                                    "nome": "DEMOBILE INDUSTRIA DE MOVEIS LTDA",
                                    "e_mail": "recebenfe@demobile.com.br",
                                    "cnpj_cpf": "75069849000110"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 1025996,
                    "nome": "ALAN RUAN FERNANDES BARBOZA"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "684226",
                        "id_tipo_pendencia": "3622"
                    }
                },
                {
                    "id_tipo_pendencia": 3500,
                    "descricao": "PEÇAS EM SEPARAÇÃO NO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "DBANM",
                    "data_cria": "2014-05-12 13:58:44",
                    "usr_alt": "18331",
                    "data_alt": "2019-06-06 16:13:00",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "684226",
                        "id_tipo_pendencia": "3500"
                    }
                },
                {
                    "id_tipo_pendencia": 651,
                    "descricao": "PECA SOLICITADA AO FORNECEDOR",
                    "situacao": "1",
                    "usr_cria": "DBANM",
                    "data_cria": "2014-05-12 13:58:44",
                    "usr_alt": "18000",
                    "data_alt": "2016-10-11 07:29:14",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "684226",
                        "id_tipo_pendencia": "651"
                    }
                },
                {
                    "id_tipo_pendencia": 3627,
                    "descricao": "TROCA CONSUMIDOR",
                    "situacao": "1",
                    "usr_cria": "18331",
                    "data_cria": "2021-01-08 14:11:22",
                    "usr_alt": null,
                    "data_alt": null,
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "684226",
                        "id_tipo_pendencia": "3627"
                    }
                },
                {
                    "id_tipo_pendencia": 651,
                    "descricao": "PECA SOLICITADA AO FORNECEDOR",
                    "situacao": "1",
                    "usr_cria": "DBANM",
                    "data_cria": "2014-05-12 13:58:44",
                    "usr_alt": "18000",
                    "data_alt": "2016-10-11 07:29:14",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "684226",
                        "id_tipo_pendencia": "651"
                    }
                },
                {
                    "id_tipo_pendencia": 3625,
                    "descricao": "AGUARDANDO MOTORISTA CD",
                    "situacao": "1",
                    "usr_cria": "1029456",
                    "data_cria": "2018-12-28 09:20:34",
                    "usr_alt": "18331",
                    "data_alt": "2021-03-19 16:52:08",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "684226",
                        "id_tipo_pendencia": "3625"
                    }
                },
                {
                    "id_tipo_pendencia": 3613,
                    "descricao": "PEÇAS ENVIADA PARA LOJA (MOSTRUARIO DE LOJA)",
                    "situacao": "1",
                    "usr_cria": "586",
                    "data_cria": "2014-11-20 08:06:01",
                    "usr_alt": "18331",
                    "data_alt": "2020-12-11 10:31:41",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "684226",
                        "id_tipo_pendencia": "3613"
                    }
                },
                {
                    "id_tipo_pendencia": 881,
                    "descricao": "PEÇA SEPARADA NO BOX",
                    "situacao": "1",
                    "usr_cria": "DBANM",
                    "data_cria": "2014-05-12 13:58:44",
                    "usr_alt": "DBANM",
                    "data_alt": "2014-09-22 06:25:52",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "684226",
                        "id_tipo_pendencia": "881"
                    }
                },
                {
                    "id_tipo_pendencia": 3623,
                    "descricao": "PEÇA ENVIADA (500) ERRADA/AVARIADA",
                    "situacao": "1",
                    "usr_cria": "18331",
                    "data_cria": "2017-07-28 10:55:49",
                    "usr_alt": "18331",
                    "data_alt": "2017-07-28 10:57:05",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "684226",
                        "id_tipo_pendencia": "3623"
                    }
                }
            ]
        },
        {
            "id_asteca": 684254,
            "tipo_asteca": 2,
            "id_filial_registro": 427,
            "observacao": "VIDRO DA ESTANTE DO MEIO ESTÁ QUEBRADA E O PAINEL ESTÁ COM ARRANHÃO NA PARTE DO MEIO.",
            "defeito_estado_prod": "VIDRO DA ESTANTE DO MEIO ESTÁ QUEBRADA E O PAINEL ESTÁ COM ARRANHÃO NA PARTE DO MEIO",
            "data_emissao": "2021-08-18T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1040003,
                "logradouro": "AVENIDA LEOPOLDO PERES NR 309 QUADRA 26 LOTE 167",
                "localidade": "MANAUS",
                "numero": 309,
                "complemento": "QUADRA 26 LOTE 167",
                "bairro": "EDUCANDOS",
                "uf": "AM",
                "cep": 69070250,
                "ponto_referencia_1": null,
                "ponto_referencia_2": null,
                "ddd": 0,
                "telefone": 0
            },
            "asteca_motivo": null,
            "documento_fiscal": {
                "id_documento_fiscal": 65968709,
                "id_filial_saida": 548,
                "id_filial_venda": 462,
                "id_cliente": "14520819",
                "nome": "NOVO MUNDO AMAZONIA MOVEIS E UTILIDADES LTDA",
                "cpf_cnpj": "13530973011461",
                "num_doc_fiscal": 370631,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-08-06T00:00:00.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 14520819,
                    "cnpj_cpf": "13530973011461",
                    "nome": "NOVO MUNDO AMAZONIA MOVEIS E UTILIDADES LTDA"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "112935",
                    "id_produto": "51261",
                    "produto": {
                        "id_produto": 51261,
                        "resumida": "RACK C/PAINEL DONNA OFF WHITE/DEMOLICAO",
                        "id_fornecedor": "28813",
                        "fornecedores": [
                            {
                                "id_fornecedor": 28813,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 12749006,
                                    "nome": "DJ-INDUSTRIA E COMERCIO DE MOVEIS LTDA",
                                    "e_mail": null,
                                    "cnpj_cpf": "85074623000242"
                                }
                            },
                            {
                                "id_fornecedor": 28813,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 5799879,
                                    "nome": "DJ INDUSTRIA E COMERCIO DE MOVEIS LTDA",
                                    "e_mail": "edvaldo.goncalves@djmoveis.ind.br",
                                    "cnpj_cpf": "85074623000161"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 7006482,
                    "nome": "JOSIANE GONCALVES DA SILVA"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "684254",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 683895,
            "tipo_asteca": 1,
            "id_filial_registro": 448,
            "observacao": "todos os parafuso do puxador ",
            "defeito_estado_prod": "todos os parafuso do puxador ",
            "data_emissao": "2021-08-13T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1039610,
                "logradouro": "1 AVENIDA AUTAZ MIRIM NR 8234 NR.8234 ",
                "localidade": "MANAUS",
                "numero": 8234,
                "complemento": null,
                "bairro": "TANCREDO NEVES",
                "uf": "AM",
                "cep": 69087215,
                "ponto_referencia_1": null,
                "ponto_referencia_2": null,
                "ddd": 92,
                "telefone": 984179583
            },
            "asteca_motivo": {
                "id_asteca_motivo": 14,
                "denominacao": "MOTIVO CRIADO PELO SISMA"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 65990003,
                "id_filial_saida": 423,
                "id_filial_venda": 423,
                "id_cliente": "14569660",
                "nome": "FRANCISCA HELENA DE SOUZA E SOUZA",
                "cpf_cnpj": "00452768209",
                "num_doc_fiscal": 21373,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-08-10T16:23:19.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 14569660,
                    "cnpj_cpf": "00452768209",
                    "nome": "FRANCISCA HELENA DE SOUZA E SOUZA"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "112224",
                    "id_produto": "50550",
                    "produto": {
                        "id_produto": 50550,
                        "resumida": "COZ PARATY P4P/AP3P/CP 3PCS BC",
                        "id_fornecedor": "288",
                        "fornecedores": [
                            {
                                "id_fornecedor": 288,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 13832168,
                                    "nome": "COLOR VISAO DO BRASIL INDUSTRIA ACRILICA LTDA",
                                    "e_mail": "diego.ferreira@colormaq.com.br",
                                    "cnpj_cpf": "47747969000356"
                                }
                            },
                            {
                                "id_fornecedor": 288,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 1583,
                                    "nome": "COLOR VISAO DO BRASIL INDUSTRIA ACRILICA LIMITADA",
                                    "e_mail": "comercial4@colormaq.com.br",
                                    "cnpj_cpf": "47747969000194"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 7005650,
                    "nome": "LUCIO ADRIANO ANDRADE DE AGUIAR"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "683895",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 683552,
            "tipo_asteca": 1,
            "id_filial_registro": 500,
            "observacao": "cadeira com acento furado ",
            "defeito_estado_prod": "cadeira com acento furado ",
            "data_emissao": "2021-08-11T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1039221,
                "logradouro": "AREA AREA DE CIRCULACAO NR.0 QD 10 LT 46",
                "localidade": "TRINDADE",
                "numero": 0,
                "complemento": "QD 10 LT 46",
                "bairro": "CHACARAS SANTA LUZIA",
                "uf": "GO",
                "cep": 75387212,
                "ponto_referencia_1": null,
                "ponto_referencia_2": null,
                "ddd": 62,
                "telefone": 992020247
            },
            "asteca_motivo": {
                "id_asteca_motivo": 14,
                "denominacao": "MOTIVO CRIADO PELO SISMA"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 65974137,
                "id_filial_saida": 529,
                "id_filial_venda": 600,
                "id_cliente": "9876140",
                "nome": "JOHNATHAN RITA DE SOUSA",
                "cpf_cnpj": "02137913151",
                "num_doc_fiscal": 1380685,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-08-07T13:03:11.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 9876140,
                    "cnpj_cpf": "02137913151",
                    "nome": "JOHNATHAN RITA DE SOUSA"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "110378",
                    "id_produto": "38710",
                    "produto": {
                        "id_produto": 38710,
                        "resumida": "CJ COPA LUANA 5PC 120X75 GRANITO CRAQ PT",
                        "id_fornecedor": "1552",
                        "fornecedores": [
                            {
                                "id_fornecedor": 1552,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 2015925,
                                    "nome": "ARTEFAMOL-INDUSTRIA E COMERCIO DE ARTEFATOS E MOVEIS LTDA.",
                                    "e_mail": null,
                                    "cnpj_cpf": "82227158000163"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 20164,
                    "nome": "MARCOS ANTONIO MARINHO LOURECO"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "683552",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 683471,
            "tipo_asteca": 2,
            "id_filial_registro": 407,
            "observacao": "FALTAM OS PÉS",
            "defeito_estado_prod": "FALTAM OS PÉS",
            "data_emissao": "2021-08-10T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1039120,
                "logradouro": "TRAVESSA WE-62 NR 412 CONJUNTO CIDADE NOVA VI",
                "localidade": "ANANINDEUA",
                "numero": 412,
                "complemento": "CONJUNTO CIDADE NOVA VI",
                "bairro": "CIDADE NOVA",
                "uf": "PA",
                "cep": 67140040,
                "ponto_referencia_1": null,
                "ponto_referencia_2": null,
                "ddd": 0,
                "telefone": 0
            },
            "asteca_motivo": {
                "id_asteca_motivo": 12,
                "denominacao": "LOGISTICA"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 65862375,
                "id_filial_saida": 547,
                "id_filial_venda": 407,
                "id_cliente": "8588842",
                "nome": "NOVO MUNDO AMAZONIA MOVEIS E UTILIDADES LTDA",
                "cpf_cnpj": "13530973003604",
                "num_doc_fiscal": 726603,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-07-20T00:00:00.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 8588842,
                    "cnpj_cpf": "13530973003604",
                    "nome": "NOVO MUNDO AMAZONIA MOVEIS E UTILIDADES LTDA"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "120208",
                    "id_produto": "58534",
                    "produto": {
                        "id_produto": 58534,
                        "resumida": "SOFA ELEGANTE 2LUG CINZA",
                        "id_fornecedor": "20848",
                        "fornecedores": [
                            {
                                "id_fornecedor": 20848,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 12483847,
                                    "nome": "MONTREAL  MONTADORA DE MOVEIS E ELETRODOMESTICOS LTDA",
                                    "e_mail": "gercompras@montrealindustria.com.br",
                                    "cnpj_cpf": "07019882000429"
                                }
                            },
                            {
                                "id_fornecedor": 20848,
                                "enviado": "1",
                                "cli_forn_principal": "1",
                                "cliente": {
                                    "id_cliente": 4848367,
                                    "nome": "MONTREAL MONTADORA DE MOVEIS E ELETRODOMESTICOS LTDA",
                                    "e_mail": "financeiro.industria@montrealindustria.com.br",
                                    "cnpj_cpf": "07019882000186"
                                }
                            },
                            {
                                "id_fornecedor": 20848,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 4593948,
                                    "nome": "MONTREAL - MONTADORA DE MOVEIS E ELETRODOMESTICOS LTDA",
                                    "e_mail": null,
                                    "cnpj_cpf": "07019882000267"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 7004780,
                    "nome": "CINTHYA SUELY LINS MINOWA"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "683471",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 683324,
            "tipo_asteca": 1,
            "id_filial_registro": 529,
            "observacao": "MONTADO",
            "defeito_estado_prod": "1 PORTA GRANDE N°16 AMASSADA NO CANTO, NO TRASPORTE PROVAVELMENTE",
            "data_emissao": "2021-08-07T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1038919,
                "logradouro": "1 QUADRA 5 CONJUNTO C CASA NR.13 CASA 13",
                "localidade": "BRASILIA",
                "numero": 13,
                "complemento": "CASA 13",
                "bairro": "CEILANDIA NORTE (CEILANDIA)",
                "uf": "DF",
                "cep": 72251003,
                "ponto_referencia_1": null,
                "ponto_referencia_2": null,
                "ddd": 61,
                "telefone": 985582775
            },
            "asteca_motivo": {
                "id_asteca_motivo": 8,
                "denominacao": "DEFEITO DE FABRICAÇÃO"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 65955907,
                "id_filial_saida": 529,
                "id_filial_venda": 92,
                "id_cliente": "6262680",
                "nome": "MAURICIO ROBERTO ROQUE DE LIMA",
                "cpf_cnpj": "78783127100",
                "num_doc_fiscal": 1379217,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-08-05T08:45:52.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 6262680,
                    "cnpj_cpf": "78783127100",
                    "nome": "MAURICIO ROBERTO ROQUE DE LIMA"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "122537",
                    "id_produto": "60863",
                    "produto": {
                        "id_produto": 60863,
                        "resumida": "G ROUPA POP 6PTS 2GAV TABACO",
                        "id_fornecedor": "68731",
                        "fornecedores": [
                            {
                                "id_fornecedor": 68731,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 13673586,
                                    "nome": "RGS INDUSTRIA E COMERCIO DE MOVEIS LTDA",
                                    "e_mail": "juliana@rgsmoveis.com.br",
                                    "cnpj_cpf": "24444786000102"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 99803223,
                    "nome": "PROATIVA INTERMEDICOES EIRELI"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "683324",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 683125,
            "tipo_asteca": 1,
            "id_filial_registro": 451,
            "observacao": "mas ja veio da loja, produto  esta no mostroario .",
            "defeito_estado_prod": "mas ja veio da loja, produto  esta no mostroario .",
            "data_emissao": "2021-08-04T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1038592,
                "logradouro": "1 AVENIDA JAIME BRASIL NR 277 NR.277 ",
                "localidade": "BOA VISTA",
                "numero": 277,
                "complemento": null,
                "bairro": "CENTRO",
                "uf": "RR",
                "cep": 69301350,
                "ponto_referencia_1": null,
                "ponto_referencia_2": null,
                "ddd": 95,
                "telefone": 984122870
            },
            "asteca_motivo": {
                "id_asteca_motivo": 14,
                "denominacao": "MOTIVO CRIADO PELO SISMA"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 65932975,
                "id_filial_saida": 438,
                "id_filial_venda": 438,
                "id_cliente": "10822092",
                "nome": "MARIA CLEUDIA GOMES DE SOUSA",
                "cpf_cnpj": "50898655234",
                "num_doc_fiscal": 87353,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-07-31T17:36:45.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 10822092,
                    "cnpj_cpf": "50898655234",
                    "nome": "MARIA CLEUDIA GOMES DE SOUSA"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "126505",
                    "id_produto": "64831",
                    "produto": {
                        "id_produto": 64831,
                        "resumida": "GABINETE CLEAN 120 C/TAMPO GRAFITE",
                        "id_fornecedor": "72",
                        "fornecedores": [
                            {
                                "id_fornecedor": 72,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 13638771,
                                    "nome": "ITATIAIA MOVEIS S/A",
                                    "e_mail": null,
                                    "cnpj_cpf": "25331521001205"
                                }
                            },
                            {
                                "id_fornecedor": 72,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 9398126,
                                    "nome": "ITATIAIA MOVEIS S/A",
                                    "e_mail": null,
                                    "cnpj_cpf": "25331521001124"
                                }
                            },
                            {
                                "id_fornecedor": 72,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 7161735,
                                    "nome": "ITATIAIA MOVEIS S/A",
                                    "e_mail": null,
                                    "cnpj_cpf": "25331521001043"
                                }
                            },
                            {
                                "id_fornecedor": 72,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 1767982,
                                    "nome": "ITATIAIA MOVEIS S/A",
                                    "e_mail": null,
                                    "cnpj_cpf": "42666058620"
                                }
                            },
                            {
                                "id_fornecedor": 72,
                                "enviado": "2",
                                "cli_forn_principal": "1",
                                "cliente": {
                                    "id_cliente": 4744,
                                    "nome": "ITATIAIA MOVEIS S/A",
                                    "e_mail": "adriana.ribeiro@cozinhasitatiaia.com.br",
                                    "cnpj_cpf": "25331521000152"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 7006016,
                    "nome": "VALDNEY DA SILVA THOMAZ"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "683125",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 682790,
            "tipo_asteca": 1,
            "id_filial_registro": 500,
            "observacao": "PEÇA SOLICITADA PELO TECNICO",
            "defeito_estado_prod": "UMA VISTA SUPERIOR/ FOI ENVIADO A PEÇA NA COR ERRADA , ENVIAR NOVAMENTE",
            "data_emissao": "2021-07-30T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1038098,
                "logradouro": "AV ANHANGUERA NR 14404 PORTAL SHOPPING",
                "localidade": "GOIANIA",
                "numero": 14404,
                "complemento": "PORTAL SHOPPING",
                "bairro": "CAPUAVA",
                "uf": "GO",
                "cep": 74450010,
                "ponto_referencia_1": null,
                "ponto_referencia_2": null,
                "ddd": 0,
                "telefone": 0
            },
            "asteca_motivo": null,
            "documento_fiscal": {
                "id_documento_fiscal": 64508360,
                "id_filial_saida": 515,
                "id_filial_venda": 10,
                "id_cliente": "11105",
                "nome": "NOVO MUNDO MOVEIS E UTILIDADES LTDA",
                "cpf_cnpj": "01534080002503",
                "num_doc_fiscal": 5020180,
                "serie_doc_fiscal": "10",
                "data_emissao": "2020-12-02T00:00:00.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 11105,
                    "cnpj_cpf": "01534080002503",
                    "nome": "NOVO MUNDO MOVEIS E UTILIDADES LTDA"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "123253",
                    "id_produto": "61579",
                    "produto": {
                        "id_produto": 61579,
                        "resumida": "G ROUPA RESIDENCE 3PTS ESP/PES AMEND/OFF",
                        "id_fornecedor": "1850",
                        "fornecedores": [
                            {
                                "id_fornecedor": 1850,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 14664422,
                                    "nome": "DEMOBILE INDUSTRIA DE MOVEIS LTDA",
                                    "e_mail": "contabil@demobile.com.br",
                                    "cnpj_cpf": "75069849000625"
                                }
                            },
                            {
                                "id_fornecedor": 1850,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 2554063,
                                    "nome": "DEMOBILE INDUSTRIA DE MOVEIS LTDA",
                                    "e_mail": "recebenfe@demobile.com.br",
                                    "cnpj_cpf": "75069849000110"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 1032891,
                    "nome": "EVERTON OLIVEIRA DA SILVA JUNIOR"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "682790",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 682715,
            "tipo_asteca": 1,
            "id_filial_registro": 555,
            "observacao": "faltou um trilho esquerdo peca numero 25",
            "defeito_estado_prod": "faltou um trilho esquerdo peca numero 25",
            "data_emissao": "2021-07-29T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1038021,
                "logradouro": "1 R ALVES DE OLIVEIRA NR.111 ",
                "localidade": "VARZEA GRANDE",
                "numero": 111,
                "complemento": null,
                "bairro": "PONTE NOVA",
                "uf": "MT",
                "cep": 78115701,
                "ponto_referencia_1": null,
                "ponto_referencia_2": null,
                "ddd": 65,
                "telefone": 996470058
            },
            "asteca_motivo": {
                "id_asteca_motivo": 14,
                "denominacao": "MOTIVO CRIADO PELO SISMA"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 65898176,
                "id_filial_saida": 555,
                "id_filial_venda": 62,
                "id_cliente": "4046558",
                "nome": "RONALDO VITOR DA SILVA",
                "cpf_cnpj": "82149445115",
                "num_doc_fiscal": 493432,
                "serie_doc_fiscal": "11",
                "data_emissao": "2021-07-26T15:28:58.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 4046558,
                    "cnpj_cpf": "82149445115",
                    "nome": "RONALDO VITOR DA SILVA"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "114888",
                    "id_produto": "53214",
                    "produto": {
                        "id_produto": 53214,
                        "resumida": "COZ PARATY P4P/AP3P/CP 3PCS BC/PT",
                        "id_fornecedor": "288",
                        "fornecedores": [
                            {
                                "id_fornecedor": 288,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 13832168,
                                    "nome": "COLOR VISAO DO BRASIL INDUSTRIA ACRILICA LTDA",
                                    "e_mail": "diego.ferreira@colormaq.com.br",
                                    "cnpj_cpf": "47747969000356"
                                }
                            },
                            {
                                "id_fornecedor": 288,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 1583,
                                    "nome": "COLOR VISAO DO BRASIL INDUSTRIA ACRILICA LIMITADA",
                                    "e_mail": "comercial4@colormaq.com.br",
                                    "cnpj_cpf": "47747969000194"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 7004127,
                    "nome": "IVONECI FRANCISCO PORTO"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "682715",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 682597,
            "tipo_asteca": 1,
            "id_filial_registro": 500,
            "observacao": "trocar o volume 4 ",
            "defeito_estado_prod": "trocar o volume 4 ",
            "data_emissao": "2021-07-28T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1037836,
                "logradouro": "1 RUA 08 NR.1 QD 08 LT 21",
                "localidade": "GOIANIRA",
                "numero": 1,
                "complemento": "QD 08 LT 21",
                "bairro": "RESIDENCIAL MONTREAL",
                "uf": "GO",
                "cep": 75370000,
                "ponto_referencia_1": "MURRO AMARELO",
                "ponto_referencia_2": null,
                "ddd": 62,
                "telefone": 993069922
            },
            "asteca_motivo": {
                "id_asteca_motivo": 14,
                "denominacao": "MOTIVO CRIADO PELO SISMA"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 65853331,
                "id_filial_saida": 515,
                "id_filial_venda": 203,
                "id_cliente": "3806178",
                "nome": "KARLA MORAES SANTOS",
                "cpf_cnpj": "01181007186",
                "num_doc_fiscal": 5250730,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-07-19T12:59:26.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 3806178,
                    "cnpj_cpf": "01181007186",
                    "nome": "KARLA MORAES SANTOS"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "126445",
                    "id_produto": "64771",
                    "produto": {
                        "id_produto": 64771,
                        "resumida": "G ROUPA MONTREAL PLUS 3P C/ESP BRANCO",
                        "id_fornecedor": "470",
                        "fornecedores": [
                            {
                                "id_fornecedor": 470,
                                "enviado": "2",
                                "cli_forn_principal": "1",
                                "cliente": {
                                    "id_cliente": 367,
                                    "nome": "MOVAL-MOVEIS ARAPONGAS LTDA",
                                    "e_mail": "nfemoval@moval.com.br",
                                    "cnpj_cpf": "75400903000169"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 20058,
                    "nome": "JOSE ROBERTO DE OLIVEIRA SANTANA"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "682597",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 682354,
            "tipo_asteca": 1,
            "id_filial_registro": 500,
            "observacao": "MONTADO",
            "defeito_estado_prod": "1 PUXADOR DA PORTA ESQUERDA\n30 TAPA FUROS LATERAIS",
            "data_emissao": "2021-07-26T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1037579,
                "logradouro": "1 R 5 UNIDADE 201 L 32 NR.1 LIGAR",
                "localidade": "GOIANIA",
                "numero": 1,
                "complemento": "LIGAR",
                "bairro": "PARQUE ATHENEU",
                "uf": "GO",
                "cep": 74890140,
                "ponto_referencia_1": "SUPERMERCADO W ECONOMICO",
                "ponto_referencia_2": null,
                "ddd": 62,
                "telefone": 991574813
            },
            "asteca_motivo": null,
            "documento_fiscal": {
                "id_documento_fiscal": 65845115,
                "id_filial_saida": 515,
                "id_filial_venda": 14,
                "id_cliente": "1562947",
                "nome": "DIVANI BENEDITA DE ALMEIDA SILVA",
                "cpf_cnpj": "47596635172",
                "num_doc_fiscal": 5249542,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-07-17T11:05:37.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 1562947,
                    "cnpj_cpf": "47596635172",
                    "nome": "DIVANI BENEDITA DE ALMEIDA SILVA"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "122726",
                    "id_produto": "61052",
                    "produto": {
                        "id_produto": 61052,
                        "resumida": "COZ MODERNA 2 C/VIDRO 3PCS BRANCO/GRAFIT",
                        "id_fornecedor": "288",
                        "fornecedores": [
                            {
                                "id_fornecedor": 288,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 13832168,
                                    "nome": "COLOR VISAO DO BRASIL INDUSTRIA ACRILICA LTDA",
                                    "e_mail": "diego.ferreira@colormaq.com.br",
                                    "cnpj_cpf": "47747969000356"
                                }
                            },
                            {
                                "id_fornecedor": 288,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 1583,
                                    "nome": "COLOR VISAO DO BRASIL INDUSTRIA ACRILICA LIMITADA",
                                    "e_mail": "comercial4@colormaq.com.br",
                                    "cnpj_cpf": "47747969000194"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 1030823,
                    "nome": "ANDRESSA DIAS DO NASCIMENTO"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "682354",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 682269,
            "tipo_asteca": 1,
            "id_filial_registro": 500,
            "observacao": "MOLDURA N15 VEIO QUEBRADA",
            "defeito_estado_prod": "MOLDURA N15 VEIO QUEBRADA",
            "data_emissao": "2021-07-23T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1037447,
                "logradouro": "RUA RUA 59 NR.8 QD 141 LT 08",
                "localidade": "APARECIDA DE GOIANIA",
                "numero": 8,
                "complemento": "QD 141 LT 08",
                "bairro": "INDEPENDENCIA - 1 COMPLEMENTO SETOR DAS MANSOES",
                "uf": "GO",
                "cep": 74959270,
                "ponto_referencia_1": null,
                "ponto_referencia_2": null,
                "ddd": 62,
                "telefone": 983015212
            },
            "asteca_motivo": null,
            "documento_fiscal": {
                "id_documento_fiscal": 65872061,
                "id_filial_saida": 529,
                "id_filial_venda": 600,
                "id_cliente": "14550412",
                "nome": "LUANNA SOUZA",
                "cpf_cnpj": "04956884109",
                "num_doc_fiscal": 1369428,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-07-21T19:41:10.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 14550412,
                    "cnpj_cpf": "04956884109",
                    "nome": "LUANNA SOUZA"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "127272",
                    "id_produto": "65598",
                    "produto": {
                        "id_produto": 65598,
                        "resumida": "G ROUPA MONTREAL PLUS 3P F C/ESP CASW/AW",
                        "id_fornecedor": "470",
                        "fornecedores": [
                            {
                                "id_fornecedor": 470,
                                "enviado": "2",
                                "cli_forn_principal": "1",
                                "cliente": {
                                    "id_cliente": 367,
                                    "nome": "MOVAL-MOVEIS ARAPONGAS LTDA",
                                    "e_mail": "nfemoval@moval.com.br",
                                    "cnpj_cpf": "75400903000169"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 1030823,
                    "nome": "ANDRESSA DIAS DO NASCIMENTO"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "682269",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 682165,
            "tipo_asteca": 1,
            "id_filial_registro": 541,
            "observacao": "MONTADO",
            "defeito_estado_prod": "faltou 1 lateral de gaveta n9",
            "data_emissao": "2021-07-22T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1037288,
                "logradouro": "1 R VIRIATO CORREA NR.115 NUM FIXO 32436237",
                "localidade": "SAO LUIS",
                "numero": 115,
                "complemento": "NUM FIXO 32436237",
                "bairro": "SANTO ANTONIO",
                "uf": "MA",
                "cep": 65046475,
                "ponto_referencia_1": "PROX AO MERCADINHO PEREIRA",
                "ponto_referencia_2": null,
                "ddd": 98,
                "telefone": 987913608
            },
            "asteca_motivo": {
                "id_asteca_motivo": 14,
                "denominacao": "MOTIVO CRIADO PELO SISMA"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 65859277,
                "id_filial_saida": 540,
                "id_filial_venda": 276,
                "id_cliente": "14544003",
                "nome": "MARIA DALVA FERREIRA LUZ",
                "cpf_cnpj": "75116367304",
                "num_doc_fiscal": 790985,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-07-20T09:47:33.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 14544003,
                    "cnpj_cpf": "75116367304",
                    "nome": "MARIA DALVA FERREIRA LUZ"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "119319",
                    "id_produto": "57645",
                    "produto": {
                        "id_produto": 57645,
                        "resumida": "COZ EXCLUSIVE 3PCS C/VIDRO PRETO",
                        "id_fornecedor": "72",
                        "fornecedores": [
                            {
                                "id_fornecedor": 72,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 13638771,
                                    "nome": "ITATIAIA MOVEIS S/A",
                                    "e_mail": null,
                                    "cnpj_cpf": "25331521001205"
                                }
                            },
                            {
                                "id_fornecedor": 72,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 9398126,
                                    "nome": "ITATIAIA MOVEIS S/A",
                                    "e_mail": null,
                                    "cnpj_cpf": "25331521001124"
                                }
                            },
                            {
                                "id_fornecedor": 72,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 7161735,
                                    "nome": "ITATIAIA MOVEIS S/A",
                                    "e_mail": null,
                                    "cnpj_cpf": "25331521001043"
                                }
                            },
                            {
                                "id_fornecedor": 72,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 1767982,
                                    "nome": "ITATIAIA MOVEIS S/A",
                                    "e_mail": null,
                                    "cnpj_cpf": "42666058620"
                                }
                            },
                            {
                                "id_fornecedor": 72,
                                "enviado": "2",
                                "cli_forn_principal": "1",
                                "cliente": {
                                    "id_cliente": 4744,
                                    "nome": "ITATIAIA MOVEIS S/A",
                                    "e_mail": "adriana.ribeiro@cozinhasitatiaia.com.br",
                                    "cnpj_cpf": "25331521000152"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 99803223,
                    "nome": "PROATIVA INTERMEDICOES EIRELI"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "682165",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 682159,
            "tipo_asteca": 1,
            "id_filial_registro": 529,
            "observacao": "MONTADO [ASTECA CANCELADA POR FECHAMENTO INDEVIDO, UMA NOVA ASSISTÊNCIA FOI ABERTA. N º684498]",
            "defeito_estado_prod": "01 PORTA TALHER/ AMASSADO NA CAIXA.",
            "data_emissao": "2021-07-22T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1037312,
                "logradouro": "1 Q 3 CJ 5 LOTE 1 BLOCO N PARANOA PARQUE NR.404 APARTAMENTO",
                "localidade": "BRASILIA",
                "numero": 404,
                "complemento": "APARTAMENTO",
                "bairro": "PARANOA",
                "uf": "DF",
                "cep": 71587700,
                "ponto_referencia_1": null,
                "ponto_referencia_2": null,
                "ddd": 61,
                "telefone": 985065881
            },
            "asteca_motivo": {
                "id_asteca_motivo": 8,
                "denominacao": "DEFEITO DE FABRICAÇÃO"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 65793653,
                "id_filial_saida": 529,
                "id_filial_venda": 43,
                "id_cliente": "7294743",
                "nome": "CARLA ABREU CARNEIRO",
                "cpf_cnpj": "78301084120",
                "num_doc_fiscal": 1360188,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-07-10T08:34:58.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 7294743,
                    "cnpj_cpf": "78301084120",
                    "nome": "CARLA ABREU CARNEIRO"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "126510",
                    "id_produto": "64836",
                    "produto": {
                        "id_produto": 64836,
                        "resumida": "GABINETE NEW JAZ 120 C/TAMPO OFF WHITE",
                        "id_fornecedor": "72",
                        "fornecedores": [
                            {
                                "id_fornecedor": 72,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 13638771,
                                    "nome": "ITATIAIA MOVEIS S/A",
                                    "e_mail": null,
                                    "cnpj_cpf": "25331521001205"
                                }
                            },
                            {
                                "id_fornecedor": 72,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 9398126,
                                    "nome": "ITATIAIA MOVEIS S/A",
                                    "e_mail": null,
                                    "cnpj_cpf": "25331521001124"
                                }
                            },
                            {
                                "id_fornecedor": 72,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 7161735,
                                    "nome": "ITATIAIA MOVEIS S/A",
                                    "e_mail": null,
                                    "cnpj_cpf": "25331521001043"
                                }
                            },
                            {
                                "id_fornecedor": 72,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 1767982,
                                    "nome": "ITATIAIA MOVEIS S/A",
                                    "e_mail": null,
                                    "cnpj_cpf": "42666058620"
                                }
                            },
                            {
                                "id_fornecedor": 72,
                                "enviado": "2",
                                "cli_forn_principal": "1",
                                "cliente": {
                                    "id_cliente": 4744,
                                    "nome": "ITATIAIA MOVEIS S/A",
                                    "e_mail": "adriana.ribeiro@cozinhasitatiaia.com.br",
                                    "cnpj_cpf": "25331521000152"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 15980,
                    "nome": "CRISTINA RIBEIRO DIAS"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "682159",
                        "id_tipo_pendencia": "3622"
                    }
                },
                {
                    "id_tipo_pendencia": 3500,
                    "descricao": "PEÇAS EM SEPARAÇÃO NO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "DBANM",
                    "data_cria": "2014-05-12 13:58:44",
                    "usr_alt": "18331",
                    "data_alt": "2019-06-06 16:13:00",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "682159",
                        "id_tipo_pendencia": "3500"
                    }
                },
                {
                    "id_tipo_pendencia": 651,
                    "descricao": "PECA SOLICITADA AO FORNECEDOR",
                    "situacao": "1",
                    "usr_cria": "DBANM",
                    "data_cria": "2014-05-12 13:58:44",
                    "usr_alt": "18000",
                    "data_alt": "2016-10-11 07:29:14",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "682159",
                        "id_tipo_pendencia": "651"
                    }
                },
                {
                    "id_tipo_pendencia": 3625,
                    "descricao": "AGUARDANDO MOTORISTA CD",
                    "situacao": "1",
                    "usr_cria": "1029456",
                    "data_cria": "2018-12-28 09:20:34",
                    "usr_alt": "18331",
                    "data_alt": "2021-03-19 16:52:08",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "682159",
                        "id_tipo_pendencia": "3625"
                    }
                },
                {
                    "id_tipo_pendencia": 3613,
                    "descricao": "PEÇAS ENVIADA PARA LOJA (MOSTRUARIO DE LOJA)",
                    "situacao": "1",
                    "usr_cria": "586",
                    "data_cria": "2014-11-20 08:06:01",
                    "usr_alt": "18331",
                    "data_alt": "2020-12-11 10:31:41",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "682159",
                        "id_tipo_pendencia": "3613"
                    }
                },
                {
                    "id_tipo_pendencia": 881,
                    "descricao": "PEÇA SEPARADA NO BOX",
                    "situacao": "1",
                    "usr_cria": "DBANM",
                    "data_cria": "2014-05-12 13:58:44",
                    "usr_alt": "DBANM",
                    "data_alt": "2014-09-22 06:25:52",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "682159",
                        "id_tipo_pendencia": "881"
                    }
                },
                {
                    "id_tipo_pendencia": 3623,
                    "descricao": "PEÇA ENVIADA (500) ERRADA/AVARIADA",
                    "situacao": "1",
                    "usr_cria": "18331",
                    "data_cria": "2017-07-28 10:55:49",
                    "usr_alt": "18331",
                    "data_alt": "2017-07-28 10:57:05",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "682159",
                        "id_tipo_pendencia": "3623"
                    }
                }
            ]
        },
        {
            "id_asteca": 682054,
            "tipo_asteca": 1,
            "id_filial_registro": 500,
            "observacao": "o led veio queimado ",
            "defeito_estado_prod": "o led veio queimado ",
            "data_emissao": "2021-07-21T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1037133,
                "logradouro": "1 R BR DO RIO BRANCO NR.1 QD 13 LT 22",
                "localidade": "APARECIDA DE GOIANIA",
                "numero": 1,
                "complemento": "QD 13 LT 22",
                "bairro": "PARQUE REAL DE GOIANIA",
                "uf": "GO",
                "cep": 74910127,
                "ponto_referencia_1": "PROXIMO TERMINAL VILA BRASILA 629 85459541",
                "ponto_referencia_2": null,
                "ddd": 62,
                "telefone": 985260923
            },
            "asteca_motivo": {
                "id_asteca_motivo": 14,
                "denominacao": "MOTIVO CRIADO PELO SISMA"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 65856714,
                "id_filial_saida": 515,
                "id_filial_venda": 12,
                "id_cliente": "11530825",
                "nome": "DIEGO ADRIANO OLIVEIRA",
                "cpf_cnpj": "03307757156",
                "num_doc_fiscal": 5251384,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-07-19T18:48:27.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 11530825,
                    "cnpj_cpf": "03307757156",
                    "nome": "DIEGO ADRIANO OLIVEIRA"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "111490",
                    "id_produto": "39822",
                    "produto": {
                        "id_produto": 39822,
                        "resumida": "G ROUPA INFINITY 6P 5G PES/ESP AMADEIRAD",
                        "id_fornecedor": "63",
                        "fornecedores": [
                            {
                                "id_fornecedor": 63,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 1420,
                                    "nome": "GELIUS - INDUSTRIA DE MOVEIS LTDA",
                                    "e_mail": "zanini@gelius.com.br",
                                    "cnpj_cpf": "53128781000160"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 99803223,
                    "nome": "PROATIVA INTERMEDICOES EIRELI"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "682054",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 681943,
            "tipo_asteca": 1,
            "id_filial_registro": 441,
            "observacao": "trocar uma lateral direita",
            "defeito_estado_prod": "trocar uma lateral direita",
            "data_emissao": "2021-07-20T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1037010,
                "logradouro": "1 AV DESEMBARGADOR PAULO FROTA NR. ALAMEDA MURANO N 01",
                "localidade": "BELEM",
                "numero": null,
                "complemento": "ALAMEDA MURANO N 01",
                "bairro": "VAL-DE-CAES",
                "uf": "PA",
                "cep": 66617418,
                "ponto_referencia_1": "CONDOMINIO CIDADE CRISTAL",
                "ponto_referencia_2": null,
                "ddd": 91,
                "telefone": 41410361
            },
            "asteca_motivo": {
                "id_asteca_motivo": 14,
                "denominacao": "MOTIVO CRIADO PELO SISMA"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 65796983,
                "id_filial_saida": 547,
                "id_filial_venda": 404,
                "id_cliente": "14539660",
                "nome": "M L FISIOTERAPIA E NEUROPSICOLOGIA LTDA",
                "cpf_cnpj": "28663861000179",
                "num_doc_fiscal": 723620,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-07-10T12:24:40.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 14539660,
                    "cnpj_cpf": "28663861000179",
                    "nome": "M L FISIOTERAPIA E NEUROPSICOLOGIA LTDA"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "112393",
                    "id_produto": "50719",
                    "produto": {
                        "id_produto": 50719,
                        "resumida": "BALCAO DUETTO DUPLO FORNO 2P 1G BRANCO",
                        "id_fornecedor": "222",
                        "fornecedores": [
                            {
                                "id_fornecedor": 222,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 11373057,
                                    "nome": "KITS PARANA INDUSTRIA E COMERCIO DE MOVEIS LTDA.",
                                    "e_mail": "rafaela@kitsparana.com.br",
                                    "cnpj_cpf": "79460192000250"
                                }
                            },
                            {
                                "id_fornecedor": 222,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 1922620,
                                    "nome": "PER-SEL METALURGICA ARTISTICA LTDA",
                                    "e_mail": null,
                                    "cnpj_cpf": "43903970000100"
                                }
                            },
                            {
                                "id_fornecedor": 222,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 241,
                                    "nome": "KITS PARANA",
                                    "e_mail": "rafaela@kitsparana.com.br",
                                    "cnpj_cpf": "79460192000179"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 7001374,
                    "nome": "JORGE LUIZ SILVA SOUZA"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "681943",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 681939,
            "tipo_asteca": 1,
            "id_filial_registro": 441,
            "observacao": "trocar uma lateral direita veio batida",
            "defeito_estado_prod": "trocar uma lateral direita veio batida",
            "data_emissao": "2021-07-20T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1037030,
                "logradouro": "1 AV DESEMBARGADOR PAULO FROTA NR. ALAMEDA MURANO N 01",
                "localidade": "BELEM",
                "numero": null,
                "complemento": "ALAMEDA MURANO N 01",
                "bairro": "VAL-DE-CAES",
                "uf": "PA",
                "cep": 66617418,
                "ponto_referencia_1": "CONDOMINIO CIDADE CRISTAL",
                "ponto_referencia_2": null,
                "ddd": 91,
                "telefone": 41410361
            },
            "asteca_motivo": {
                "id_asteca_motivo": 14,
                "denominacao": "MOTIVO CRIADO PELO SISMA"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 65796983,
                "id_filial_saida": 547,
                "id_filial_venda": 404,
                "id_cliente": "14539660",
                "nome": "M L FISIOTERAPIA E NEUROPSICOLOGIA LTDA",
                "cpf_cnpj": "28663861000179",
                "num_doc_fiscal": 723620,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-07-10T12:24:40.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 14539660,
                    "cnpj_cpf": "28663861000179",
                    "nome": "M L FISIOTERAPIA E NEUROPSICOLOGIA LTDA"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "112393",
                    "id_produto": "50719",
                    "produto": {
                        "id_produto": 50719,
                        "resumida": "BALCAO DUETTO DUPLO FORNO 2P 1G BRANCO",
                        "id_fornecedor": "222",
                        "fornecedores": [
                            {
                                "id_fornecedor": 222,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 11373057,
                                    "nome": "KITS PARANA INDUSTRIA E COMERCIO DE MOVEIS LTDA.",
                                    "e_mail": "rafaela@kitsparana.com.br",
                                    "cnpj_cpf": "79460192000250"
                                }
                            },
                            {
                                "id_fornecedor": 222,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 1922620,
                                    "nome": "PER-SEL METALURGICA ARTISTICA LTDA",
                                    "e_mail": null,
                                    "cnpj_cpf": "43903970000100"
                                }
                            },
                            {
                                "id_fornecedor": 222,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 241,
                                    "nome": "KITS PARANA",
                                    "e_mail": "rafaela@kitsparana.com.br",
                                    "cnpj_cpf": "79460192000179"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 7001374,
                    "nome": "JORGE LUIZ SILVA SOUZA"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "681939",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 681713,
            "tipo_asteca": 1,
            "id_filial_registro": 549,
            "observacao": "veio com um espelho trincado",
            "defeito_estado_prod": "veio com um espelho trincado",
            "data_emissao": "2021-07-17T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1036752,
                "logradouro": "1 AVENIDA RUI BARBOSA NR 545 NR.545",
                "localidade": "SANTAREM",
                "numero": 545,
                "complemento": null,
                "bairro": "CENTRO",
                "uf": "PA",
                "cep": 68005080,
                "ponto_referencia_1": null,
                "ponto_referencia_2": null,
                "ddd": 93,
                "telefone": 981139626
            },
            "asteca_motivo": {
                "id_asteca_motivo": 14,
                "denominacao": "MOTIVO CRIADO PELO SISMA"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 65808773,
                "id_filial_saida": 419,
                "id_filial_venda": 419,
                "id_cliente": "8355823",
                "nome": "ROSIANE QUINTAS SERRAO",
                "cpf_cnpj": "75123339272",
                "num_doc_fiscal": 96728,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-07-12T19:09:43.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 8355823,
                    "cnpj_cpf": "75123339272",
                    "nome": "ROSIANE QUINTAS SERRAO"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "120089",
                    "id_produto": "58415",
                    "produto": {
                        "id_produto": 58415,
                        "resumida": "G ROUPA GHAIA STATUS 2PT C/ESP PES CAFE",
                        "id_fornecedor": "14584",
                        "fornecedores": [
                            {
                                "id_fornecedor": 14584,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 7433048,
                                    "nome": "MOVEIS BOM PASTOR LTDA",
                                    "e_mail": "nfe@bompastor.ind.br",
                                    "cnpj_cpf": "01610917000332"
                                }
                            },
                            {
                                "id_fornecedor": 14584,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 5580205,
                                    "nome": "MOVEIS BOM PASTOR LTDA",
                                    "e_mail": "nfe@bompastor.ind.br",
                                    "cnpj_cpf": "01610917000413"
                                }
                            },
                            {
                                "id_fornecedor": 14584,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 4668618,
                                    "nome": "MOVEIS BOM PASTOR LTDA",
                                    "e_mail": "nfe@bompastor.ind.br",
                                    "cnpj_cpf": "01610917000251"
                                }
                            },
                            {
                                "id_fornecedor": 14584,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 3543535,
                                    "nome": "MOVEIS BOM PASTOR LTDA",
                                    "e_mail": "nfe@bompastor.ind.br",
                                    "cnpj_cpf": "01610917000170"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 7002303,
                    "nome": "EDERSON SOUSA DE OLIVEIRA"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "681713",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 681687,
            "tipo_asteca": 1,
            "id_filial_registro": 451,
            "observacao": "PRODUTO MONTADO",
            "defeito_estado_prod": "A PORTA DOS ESPELHO VEIO COM A COR ERRADA E OS FUNDOS TAMBÉM",
            "data_emissao": "2021-07-17T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1036725,
                "logradouro": "1 R ECILDON DE S PINTO 55 NR.",
                "localidade": "BOA VISTA",
                "numero": null,
                "complemento": "N/D",
                "bairro": "SAO BENTO",
                "uf": "RR",
                "cep": 69315662,
                "ponto_referencia_1": null,
                "ponto_referencia_2": null,
                "ddd": 95,
                "telefone": 991272630
            },
            "asteca_motivo": null,
            "documento_fiscal": {
                "id_documento_fiscal": 65765512,
                "id_filial_saida": 548,
                "id_filial_venda": 438,
                "id_cliente": "11651151",
                "nome": "TAIANE PINHEIRO FLOR",
                "cpf_cnpj": "03734922275",
                "num_doc_fiscal": 367174,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-07-06T15:59:39.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 11651151,
                    "cnpj_cpf": "03734922275",
                    "nome": "TAIANE PINHEIRO FLOR"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "126445",
                    "id_produto": "64771",
                    "produto": {
                        "id_produto": 64771,
                        "resumida": "G ROUPA MONTREAL PLUS 3P C/ESP BRANCO",
                        "id_fornecedor": "470",
                        "fornecedores": [
                            {
                                "id_fornecedor": 470,
                                "enviado": "2",
                                "cli_forn_principal": "1",
                                "cliente": {
                                    "id_cliente": 367,
                                    "nome": "MOVAL-MOVEIS ARAPONGAS LTDA",
                                    "e_mail": "nfemoval@moval.com.br",
                                    "cnpj_cpf": "75400903000169"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 1030823,
                    "nome": "ANDRESSA DIAS DO NASCIMENTO"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "681687",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 681423,
            "tipo_asteca": 1,
            "id_filial_registro": 500,
            "observacao": "PRODUTO MONTADO",
            "defeito_estado_prod": "2 TRAVAS PLASTICAS DO CANTO VIERAM QUEBRADAS. MERCADORIA DE MOSTRUARIO",
            "data_emissao": "2021-07-15T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1036386,
                "logradouro": "1 R J 19 NR.1 QD 23 LT 19",
                "localidade": "APARECIDA DE GOIANIA",
                "numero": 1,
                "complemento": "QD 23 LT 19",
                "bairro": "MANSOES PARAISO",
                "uf": "GO",
                "cep": 74952180,
                "ponto_referencia_1": "ESCOLA CRIATIVA",
                "ponto_referencia_2": null,
                "ddd": 62,
                "telefone": 991519428
            },
            "asteca_motivo": null,
            "documento_fiscal": {
                "id_documento_fiscal": 65740643,
                "id_filial_saida": 12,
                "id_filial_venda": 12,
                "id_cliente": "1685335",
                "nome": "YARA PEREIRA DA SILVA",
                "cpf_cnpj": "97432628149",
                "num_doc_fiscal": 59364,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-07-02T11:59:16.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 1685335,
                    "cnpj_cpf": "97432628149",
                    "nome": "YARA PEREIRA DA SILVA"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "128134",
                    "id_produto": "66460",
                    "produto": {
                        "id_produto": 66460,
                        "resumida": "CJ COPA MALVA 4118 VDO 75X75 5PC PT/AZ T",
                        "id_fornecedor": "1552",
                        "fornecedores": [
                            {
                                "id_fornecedor": 1552,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 2015925,
                                    "nome": "ARTEFAMOL-INDUSTRIA E COMERCIO DE ARTEFATOS E MOVEIS LTDA.",
                                    "e_mail": null,
                                    "cnpj_cpf": "82227158000163"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 1030823,
                    "nome": "ANDRESSA DIAS DO NASCIMENTO"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "681423",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 681361,
            "tipo_asteca": 1,
            "id_filial_registro": 500,
            "observacao": "manda um puxador veio quebrando ",
            "defeito_estado_prod": "manda um puxador veio quebrando ",
            "data_emissao": "2021-07-14T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1036320,
                "logradouro": "RUA RUA FC 14 QD28 LT 17 NR.0 ",
                "localidade": "ANAPOLIS",
                "numero": 0,
                "complemento": "N/D",
                "bairro": "RESIDENCIAL FLOR DO CERRADO",
                "uf": "GO",
                "cep": 75085016,
                "ponto_referencia_1": null,
                "ponto_referencia_2": null,
                "ddd": 62,
                "telefone": 994975737
            },
            "asteca_motivo": {
                "id_asteca_motivo": 14,
                "denominacao": "MOTIVO CRIADO PELO SISMA"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 65800493,
                "id_filial_saida": 529,
                "id_filial_venda": 600,
                "id_cliente": "9571257",
                "nome": "EMERSON ALVES",
                "cpf_cnpj": "01433694158",
                "num_doc_fiscal": 1360993,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-07-11T13:41:11.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 9571257,
                    "cnpj_cpf": "01433694158",
                    "nome": "EMERSON DUTRA ALVES"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "111400",
                    "id_produto": "39732",
                    "produto": {
                        "id_produto": 39732,
                        "resumida": "G ROUPA IMAGINARE 6PTS BC/BC C/PES",
                        "id_fornecedor": "181",
                        "fornecedores": [
                            {
                                "id_fornecedor": 181,
                                "enviado": "1",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 8479402,
                                    "nome": "SANTOS ANDIRA INDUSTRIA DE MOVEIS LTDA",
                                    "e_mail": "anderson.peres@santosandira.com.br",
                                    "cnpj_cpf": "75205831000522"
                                }
                            },
                            {
                                "id_fornecedor": 181,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 378,
                                    "nome": "SANTOS ANDIRA IND DE MOVEIS LTDA",
                                    "e_mail": null,
                                    "cnpj_cpf": "75205831000107"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 19956,
                    "nome": "FRANCISCO OLIVEIRA DOS REIS"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "681361",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 681358,
            "tipo_asteca": 1,
            "id_filial_registro": 500,
            "observacao": "PEÇA CROMADA DE CIMA DA CADEIRA  E PEÇA DO PÉ DA CADEIRA.",
            "defeito_estado_prod": " PEÇA CROMADA DE CIMA DA CADEIRA E PEÇA DO PÉ DA CADEIRA.",
            "data_emissao": "2021-07-14T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1036304,
                "logradouro": "RUA RUA EVARISTO DA VEIGA NR.0 QD 24 LT08B CASA DA ESQUINA",
                "localidade": "ANAPOLIS",
                "numero": 0,
                "complemento": "QD 24 LT08B CASA DA ESQUINA",
                "bairro": "CAMPOS ELISIOS",
                "uf": "GO",
                "cep": 75103590,
                "ponto_referencia_1": null,
                "ponto_referencia_2": null,
                "ddd": 62,
                "telefone": 992485023
            },
            "asteca_motivo": {
                "id_asteca_motivo": 14,
                "denominacao": "MOTIVO CRIADO PELO SISMA"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 65792467,
                "id_filial_saida": 529,
                "id_filial_venda": 600,
                "id_cliente": "3830647",
                "nome": "PAULO PASSOS",
                "cpf_cnpj": "95144986153",
                "num_doc_fiscal": 1359968,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-07-09T18:23:10.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 3830647,
                    "cnpj_cpf": "95144986153",
                    "nome": "PAULO HENRIQUE SOARES PASSOS"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "110379",
                    "id_produto": "38711",
                    "produto": {
                        "id_produto": 38711,
                        "resumida": "CJ COPA LUANA 7PC 150X75 GRANITO CRAQ PT",
                        "id_fornecedor": "1552",
                        "fornecedores": [
                            {
                                "id_fornecedor": 1552,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 2015925,
                                    "nome": "ARTEFAMOL-INDUSTRIA E COMERCIO DE ARTEFATOS E MOVEIS LTDA.",
                                    "e_mail": null,
                                    "cnpj_cpf": "82227158000163"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 1030530,
                    "nome": "THIAGO PEREIRA DE ASSIS"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "681358",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 681319,
            "tipo_asteca": 1,
            "id_filial_registro": 541,
            "observacao": "PEÇA - FALTA NA EMBALAGEM, PRODUTO MONTADO",
            "defeito_estado_prod": "faltou o espelho do guarda roupa.",
            "data_emissao": "2021-07-14T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1036252,
                "logradouro": "1 RUA H QUADRA 9 CASA 91 CONJ PROMORAR LIBERDADE NR.91 98988297430",
                "localidade": "SAO LUIS",
                "numero": 91,
                "complemento": "98988297430",
                "bairro": "LIBERDADE",
                "uf": "MA",
                "cep": 65037007,
                "ponto_referencia_1": "PERTO DA CRECHE BASILIO",
                "ponto_referencia_2": null,
                "ddd": 98,
                "telefone": 988867822
            },
            "asteca_motivo": {
                "id_asteca_motivo": 14,
                "denominacao": "MOTIVO CRIADO PELO SISMA"
            },
            "documento_fiscal": {
                "id_documento_fiscal": 65793778,
                "id_filial_saida": 540,
                "id_filial_venda": 275,
                "id_cliente": "9795451",
                "nome": "MAGNO SILVA MENDONCA",
                "cpf_cnpj": "47607149368",
                "num_doc_fiscal": 787996,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-07-10T08:42:05.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 9795451,
                    "cnpj_cpf": "47607149368",
                    "nome": "MAGNO SILVA MENDONCA"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "111045",
                    "id_produto": "39377",
                    "produto": {
                        "id_produto": 39377,
                        "resumida": "G ROUPA CAPRI 4PT 3GAV CASTANHO WOOD PES",
                        "id_fornecedor": "470",
                        "fornecedores": [
                            {
                                "id_fornecedor": 470,
                                "enviado": "2",
                                "cli_forn_principal": "1",
                                "cliente": {
                                    "id_cliente": 367,
                                    "nome": "MOVAL-MOVEIS ARAPONGAS LTDA",
                                    "e_mail": "nfemoval@moval.com.br",
                                    "cnpj_cpf": "75400903000169"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 7001710,
                    "nome": "ANDERSON DANTAS LOPES"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "681319",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        },
        {
            "id_asteca": 681349,
            "tipo_asteca": 1,
            "id_filial_registro": 441,
            "observacao": "PEÇAS AMASSADAS",
            "defeito_estado_prod": "TROCAR 02 (DUAS) LATERAIS MACHO CRONOS - XXX (REF.FB. 6729); 02 (DUAS) LATERAIS FEMEA INFER. CRONOS - XXX (REF.FB. 6730)",
            "data_emissao": "2021-07-14T00:00:00.000000Z",
            "asteca_end_cliente": {
                "id_asteca_end_cli": 1036300,
                "logradouro": "1 RUA JUPITER NR.122 CJ ORLANDO LOBATO QD A NR 122",
                "localidade": "BELEM",
                "numero": 122,
                "complemento": "CJ ORLANDO LOBATO QD A NR 122",
                "bairro": "PARQUE VERDE",
                "uf": "PA",
                "cep": 66635135,
                "ponto_referencia_1": "CJ FICA AO LADO MERCADO NAZARE CASA FICA PROXIMO CAPELA",
                "ponto_referencia_2": null,
                "ddd": 91,
                "telefone": 983297137
            },
            "asteca_motivo": null,
            "documento_fiscal": {
                "id_documento_fiscal": 65736719,
                "id_filial_saida": 547,
                "id_filial_venda": 415,
                "id_cliente": "7594788",
                "nome": "MARIA ROSIANE DE OLIVEIRA REIS",
                "cpf_cnpj": "36896179287",
                "num_doc_fiscal": 720593,
                "serie_doc_fiscal": "10",
                "data_emissao": "2021-07-01T16:34:43.000000Z",
                "item_doc_fiscal": {
                    "id_ld": 0
                },
                "cliente": {
                    "id_cliente": 7594788,
                    "cnpj_cpf": "36896179287",
                    "nome": "MARIA ROSIANE DE OLIVEIRA REIS"
                }
            },
            "comp_est_prod": [
                {
                    "id_comp_est": "118830",
                    "id_produto": "57156",
                    "produto": {
                        "id_produto": 57156,
                        "resumida": "CJ SALA CRONOS 180X90 7PCS VDOCAST TC BE",
                        "id_fornecedor": "17530",
                        "fornecedores": [
                            {
                                "id_fornecedor": 17530,
                                "enviado": "2",
                                "cli_forn_principal": null,
                                "cliente": {
                                    "id_cliente": 4042411,
                                    "nome": "LJ MOVEIS LTDA",
                                    "e_mail": "vendas@ljmoveis.com.br",
                                    "cnpj_cpf": "01792254000152"
                                }
                            }
                        ]
                    }
                }
            ],
            "funcionario": [
                {
                    "id_funcionario": 7001262,
                    "nome": "GLEIDSON ANDRE LIMA PANTOJA"
                }
            ],
            "pendencia": [
                {
                    "id_tipo_pendencia": 3622,
                    "descricao": "PEDIDO DE PEÇAS AO PULMÃO",
                    "situacao": "1",
                    "usr_cria": "18000",
                    "data_cria": "2016-06-13 09:18:48",
                    "usr_alt": "18331",
                    "data_alt": "2019-09-09 10:36:50",
                    "tipo_registro": "1",
                    "pivot": {
                        "id_asteca": "681349",
                        "id_tipo_pendencia": "3622"
                    }
                }
            ]
        }
    ]
}''';

    test('teste de busca de astecas', () async {
      when(api.get(
        any,
      )).thenAnswer((realInvocation) async => Response(dataReceived, 200));
      final resposta = await repository.buscarAstecas(1);
      expect(resposta, isA<List<AstecaModel>>());
    });

    // test('Verifica se não foi possível encontrar as astecas', () async {
    //   when(api.get(any))
    //       .thenAnswer((realInvocation) async => Response('', 404));

    //   expect(() async => await repository.buscar(1), throwsA(isA<Exception>()));
    // });
  });
}
