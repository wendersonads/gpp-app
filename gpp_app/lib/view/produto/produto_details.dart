import 'package:flutter/material.dart';

class ProdutoDetails extends StatelessWidget {
  final String idProduto;
  final String nome;
  final String fornecedor;

  // Construtor que recebe os dados do produto
  const ProdutoDetails({
    Key? key,
    required this.idProduto,
    required this.nome,
    required this.fornecedor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID Produto: $idProduto'),
            const SizedBox(height: 8),
            Text('Nome: $nome'),
            const SizedBox(height: 8),
            Text('Fornecedor: $fornecedor'),
            // Adicione mais detalhes conforme necessário
          ],
        ),
      ),
    );
  }
}
