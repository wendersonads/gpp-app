// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpp/src/models/FuncionalidadeModel.dart';
import 'package:gpp/src/models/subfuncionalidade.dart';

import 'package:gpp/src/models/user_model.dart';
import 'package:gpp/src/repositories/usuario_repository.dart';
import 'package:gpp/src/shared/exceptions/user_exception.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_repository_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  dotenv.testLoad(fileInput: File("env").readAsStringSync());

  final api = MockApiService();
  final repository = UsuarioRepository();

  group('Usuários: ', () {
    String dataReceived = ''' [
    [
        {
            "id": "1",
            "uid": "9010000401",
            "name": "Marcelo Jose De Castro Neiva",
            "email": "9010000401@novomundo.com.br",
            "email_verified_at": null,
            "password": "Sm2bXQRXxAGOXH85ZXoZwRChvfk.HRy2TH7WAB95vM2",
            "remember_token": null,
            "created_at": "2021-12-21 19:49:09",
            "updated_at": "2021-12-21 19:49:09",
            "active": "0",
            "iddepto": null,
            "foto": null
        },
        {
            "id": "2",
            "uid": "9010000409",
            "name": "Fernando Henrique Ramos Mendes",
            "email": "mendesfnando@gmail.com",
            "email_verified_at": null,
            "password": "Qdrw31nUKCRiws4WMLYDZrVUeueCTLW",
            "remember_token": null,
            "created_at": "2021-12-21 19:49:49",
            "updated_at": "2021-12-21 19:49:49",
            "active": "0",
            "iddepto": null,
            "foto": null
        },
        {
            "id": "3",
            "uid": "1032445",
            "name": "Weverson Barbosa De Lima",
            "email": "weverson.lima@novomundo.com.br",
            "email_verified_at": null,
            "password": "Qdrw31nUKCRiws4WMLYDZrVUeueCTLW",
            "remember_token": null,
            "created_at": "2021-12-21 19:50:09",
            "updated_at": "2021-12-21 19:50:09",
            "active": "0",
            "iddepto": null,
            "foto": null
        }
    ]
]''';

    test('Valida a busca de usuários', () async {
      when(api.get(any))
          .thenAnswer((realInvocation) async => Response(dataReceived, 200));
      final users = await repository.buscarUsuario(1);
      expect(users, isA<List<UsuarioModel>>());
    });

    test('Valida se os usuáriso não foram encontrados', () async {
      when(api.get(any))
          .thenAnswer((realInvocation) async => Response('', 404));

      expect(() async => await repository.buscarUsuarios(1),
          throwsA(isA<UserException>()));
    });
  });

  group("Usuário e funcionalidades:", () {
    String dataReceived = '''[
    [
        {
            "id": "2",
            "name": "CADASTROSXXXXX",
            "icon": "account_balance_XXXXXX",
            "subFuncionalities": [
                {
                    "id": "9",
                    "name": "Endereços",
                    "icon": "add_business",
                    "route": "/enderecos"
                },
                {
                    "id": "5",
                    "name": "Funcionalidades",
                    "icon": "add_a_photo",
                    "route": "/funcionalidades"
                },
                {
                    "id": "8",
                    "name": "Peças",
                    "icon": "add_alarm_rounded",
                    "route": "/pecas"
                },
                {
                    "id": "14",
                    "name": "Departamentos",
                    "icon": "add_link_sharp",
                    "route": "/departamentos"
                }
            ]
        },
        {
            "id": "3",
            "name": "ASTECAS",
            "icon": "account_box",
            "subFuncionalities": [
                {
                    "id": "11",
                    "name": "Manutenção",
                    "icon": "add_circle_outline_outlined",
                    "route": "/manutencao"
                },
                {
                    "id": "10",
                    "name": "Movimentos",
                    "icon": "add_call",
                    "route": "/movimentos"
                }
            ]
        },
        {
            "id": "4",
            "name": "PEDIDOS",
            "icon": "account_tree",
            "subFuncionalities": [
                {
                    "id": "12",
                    "name": "Solicitados",
                    "icon": "add_location",
                    "route": "/solicitados"
                },
                {
                    "id": "13",
                    "name": "Cancelados",
                    "icon": "add_link_sharp",
                    "route": "/cancelados"
                }
            ]
        },
        {
            "id": "5",
            "name": "FUNCIONALIDADES",
            "icon": "account_tree",
            "subFuncionalities": [
                {
                    "id": "15",
                    "name": "Menus",
                    "icon": "add_link_sharp",
                    "route": "/menus"
                },
                {
                    "id": "16",
                    "name": "Itens do menu",
                    "icon": "add_link_sharp",
                    "route": "/itensmenu"
                }
            ]
        },
        {
            "id": "21",
            "name": "ADMINISTRAÇÃO",
            "icon": "settings",
            "subFuncionalities": [
                {
                    "id": "22",
                    "name": "Departamento",
                    "icon": "home_work",
                    "route": "/departaments"
                },
                {
                    "id": "21",
                    "name": "Usuários",
                    "icon": "person",
                    "route": "/users"
                }
            ]
        }
    ]
]''';

    test('Valida busca funcionalidades relacionadas ao usuário', () async {
      when(api.get(any))
          .thenAnswer((realInvocation) async => Response(dataReceived, 200));
      final response = await repository.buscarFuncionalidades(1);
      expect(response, isA<List<FuncionalidadeModel>>());
    });
  });

  group("Usuário e itens de funcionalidades: ", () {
    String dataReceived = ''' [
    [
        {
            "id": "5",
            "name": "Funcionalidades",
            "active": 1,
            "idregister": "55"
        },
        {
            "id": "8",
            "name": "Peças",
            "active": 1,
            "idregister": "27"
        },
        {
            "id": "8",
            "name": "Peças",
            "active": 1,
            "idregister": "49"
        },
        {
            "id": "9",
            "name": "Endereços",
            "active": 1,
            "idregister": "48"
        },
        {
            "id": "10",
            "name": "Movimentos",
            "active": 1,
            "idregister": "44"
        },
        {
            "id": "11",
            "name": "Manutenção",
            "active": 1,
            "idregister": "47"
        },
        {
            "id": "11",
            "name": "Manutenção",
            "active": 1,
            "idregister": "50"
        },
        {
            "id": "12",
            "name": "Solicitados",
            "active": 1,
            "idregister": "42"
        },
        {
            "id": "12",
            "name": "Solicitados",
            "active": 1,
            "idregister": "56"
        },
        {
            "id": "12",
            "name": "Solicitados",
            "active": 1,
            "idregister": "51"
        },
        {
            "id": "13",
            "name": "Cancelados",
            "active": 1,
            "idregister": "52"
        },
        {
            "id": "13",
            "name": "Cancelados",
            "active": 1,
            "idregister": "45"
        },
        {
            "id": "14",
            "name": "Departamentos",
            "active": 1,
            "idregister": "43"
        },
        {
            "id": "15",
            "name": "Menus",
            "active": 1,
            "idregister": "31"
        },
        {
            "id": "15",
            "name": "Menus",
            "active": 1,
            "idregister": "53"
        },
        {
            "id": "16",
            "name": "Itens do menu",
            "active": 1,
            "idregister": "54"
        },
        {
            "id": "16",
            "name": "Itens do menu",
            "active": 1,
            "idregister": "41"
        },
        {
            "id": "21",
            "name": "Usuários",
            "active": 1,
            "idregister": "57"
        },
        {
            "id": "22",
            "name": "Departamento",
            "active": 1,
            "idregister": "58"
        }
    ]
]''';

    test('Valida busca de itens de funcionalidades relacionadas ao usuário',
        () async {
      when(api.get(any))
          .thenAnswer((realInvocation) async => Response(dataReceived, 200));
      final response = await repository.fetchSubFuncionalities('1');
      expect(response, isA<List<SubFuncionalidadeModel>>());
    });

    test(
        'Valida se não foi encontrado itens de funcionalidades relacionadas ao usuário',
        () async {
      when(api.get(any))
          .thenAnswer((realInvocation) async => Response('', 404));

      expect(() async => await repository.fetchSubFuncionalities('1'),
          throwsA(isA<UserException>()));
    });
  });
}
