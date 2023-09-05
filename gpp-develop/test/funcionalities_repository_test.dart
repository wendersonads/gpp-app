// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpp/src/models/FuncionalidadeModel.dart';

import 'package:gpp/src/repositories/funcionalidade_repository.dart';
import 'package:gpp/src/shared/exceptions/funcionalities_exception.dart';
import 'package:gpp/src/shared/services/gpp_api.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'funcionalities_repository_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  dotenv.testLoad(fileInput: File("env").readAsStringSync());

  final api = MockApiService();
  final repository = FuncionalidadeRepository();

  group('Funcionalidades - Buscar: ', () {
    String dataReceived = '''[
    [
        {
            "id": "2",
            "name": "CADASTROS",
            "active": "1",
            "icon": "account_balance",
            "iduserresp": "1"
        },
        {
            "id": "3",
            "name": "ASTECAS",
            "active": "1",
            "icon": "account_box",
            "iduserresp": "1"
        },
        {
            "id": "4",
            "name": "PEDIDOS",
            "active": "1",
            "icon": "account_tree",
            "iduserresp": "1"
        },
        {
            "id": "21",
            "name": "ADMINISTRAÇÃO",
            "active": "1",
            "icon": "settings",
            "iduserresp": "1"
        },
        {
            "id": "41",
            "name": "TESTE",
            "active": "1",
            "icon": "settings",
            "iduserresp": "1"
        },
        {
            "id": "5",
            "name": "FUNCIONALIDADES",
            "active": "1",
            "icon": "account_tree",
            "iduserresp": "1"
        }
    ]
]''';

    test('Valida a busca de funcionalidades', () async {
      when(api.get(any))
          .thenAnswer((realInvocation) async => Response(dataReceived, 200));
      final funcionalities = await repository.buscarFuncionalidades();
      expect(funcionalities, isA<List<FuncionalidadeModel>>());
    });

    test('Valida se as funcionalidades não foram encontradas', () async {
      when(api.get(any))
          .thenAnswer((realInvocation) async => Response('', 404));

      expect(() async => await repository.buscarFuncionalidades(),
          throwsA(isA<FuncionalitiesException>()));
    });
  });

  group('Funcionalidades - Criação: ', () {
    FuncionalidadeModel funcionalitie =
        FuncionalidadeModel(nome: "Teste", situacao: true, icone: "icon_teste");

    test('Valida a criação de funcionalidade', () async {
      when(api.post(any, any))
          .thenAnswer((realInvocation) async => Response('', 200));

      expect(await repository.create(funcionalitie), true);
    });

    test('Valida se a funcionalidade não foi cadastrada', () async {
      when(api.post(any, any))
          .thenAnswer((realInvocation) async => Response('', 404));

      expect(() async => await repository.create(funcionalitie),
          throwsA(isA<FuncionalitiesException>()));
    });
  });

  group('Funcionalidades - Atualização: ', () {
    FuncionalidadeModel funcionalitie =
        FuncionalidadeModel(nome: "Teste", situacao: true, icone: "icon_teste");

    test('Valida se a funcionalidade foi atualizada', () async {
      when(api.put(any, any))
          .thenAnswer((realInvocation) async => Response('', 200));

      expect(await repository.update(funcionalitie), true);
    });

    test('Valida se a funcionalidade não foi atualizada', () async {
      when(api.put(any, any))
          .thenAnswer((realInvocation) async => Response('', 404));

      expect(() async => await repository.update(funcionalitie),
          throwsA(isA<FuncionalitiesException>()));
    });
  });

  group('Funcionalidade - Exclusão: ', () {
    String dataSend = '''{
    "id": 1,
    "name": "TESTE a",
    "active": false,
    "icon": "settings",
    "iduserresp": 1
} ''';

    FuncionalidadeModel funcionalitie =
        FuncionalidadeModel.fromJson(json.decode(dataSend));

    test('Valida se a funcionalidade foi deletada', () async {
      when(api.delete(any))
          .thenAnswer((realInvocation) async => Response('', 200));

      expect(await repository.delete(funcionalitie), true);
    });

    test('Valida se a funcionalidade não foi deletada', () async {
      when(api.delete(any))
          .thenAnswer((realInvocation) async => Response('', 404));

      expect(() async => await repository.delete(funcionalitie),
          throwsA(isA<FuncionalitiesException>()));
    });
  });
}
