import 'package:flutter/material.dart';

import '../../domain/model/peca_model.dart';

class PecaDetails extends StatelessWidget {
  final Peca peca;

  // Construtor que recebe a instância da entidade Peca
  const PecaDetails({
    Key? key,
    required this.peca,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('ID Peça: ${peca.idPeca}');
    print('Número: ${peca.numero}');
    print('Código de Fábrica: ${peca.codigoFabrica}');
    print('Unidade: ${peca.unidade}');
    print('Descrição: ${peca.descricao}');
    print('Altura: ${peca.altura}');
    print('Largura: ${peca.largura}');
    print('Profundidade: ${peca.profundidade}');
    print('Unidade de Medida: ${peca.unidadeMedida}');
    print('Volumes: ${peca.volumes}');
    print('Ativa: ${peca.active}');
    print('Custo: ${peca.custo}');
    print('Cor: ${peca.cor}');
    print('Material: ${peca.material}');
    print('ID Fornecedor: ${peca.idFornecedor}');
    print('Material de Fabricação: ${peca.materialFabricacao}');
    print('Produto: ${peca.produto}');

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Peça'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID Peça: ${peca.idPeca}'),
            const SizedBox(height: 8),
            Text('Número: ${peca.numero}'),
            const SizedBox(height: 8),
            Text('Código de Fábrica: ${peca.codigoFabrica}'),
            const SizedBox(height: 8),
            Text('Unidade: ${peca.unidade}'),
            const SizedBox(height: 8),
            Text('Descrição: ${peca.descricao}'),
            const SizedBox(height: 8),
            Text('Altura: ${peca.altura}'),
            const SizedBox(height: 8),
            Text('Largura: ${peca.largura}'),
            const SizedBox(height: 8),
            Text('Profundidade: ${peca.profundidade}'),
            const SizedBox(height: 8),
            Text('Unidade de Medida: ${peca.unidadeMedida}'),
            const SizedBox(height: 8),
            Text('Volumes: ${peca.volumes}'),
            const SizedBox(height: 8),
            Text('Ativa: ${peca.active}'),
            const SizedBox(height: 8),
            Text('Custo: ${peca.custo}'),
            const SizedBox(height: 8),
            Text('Cor: ${peca.cor}'),
            const SizedBox(height: 8),
            Text('Material: ${peca.material}'),
            const SizedBox(height: 8),
            Text('ID Fornecedor: ${peca.idFornecedor}'),
            const SizedBox(height: 8),
            Text('Material de Fabricação: ${peca.materialFabricacao}'),
            const SizedBox(height: 8),
            Text('Produto: ${peca.produto?.descricao}'),
            // Adicione mais detalhes conforme necessário
          ],
        ),
      ),
    );
  }
}
