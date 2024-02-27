import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/model/fornecedor_model.dart';

class FornecedorDetails extends StatelessWidget {
  final Fornecedor fornecedor;

  const FornecedorDetails({
    Key? key,
    required this.fornecedor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Fornecedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID Fornecedor: ${fornecedor.idFornecedor}'),
            const SizedBox(height: 8),
            Text('Nome: ${fornecedor.nomeFornecedor}'),
            const SizedBox(height: 8),
            Text('Email: ${fornecedor.email}'),
            const SizedBox(height: 8),
            Text('CNPJ: ${fornecedor.cnpj}'),
            // Adicione mais detalhes conforme necessário
          ],
        ),
      ),
    );
  }
}
