import 'package:auth_migration/view/produto/produto_edit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/service/produto_service.dart';
import '../../shared/components/ButtonComponent.dart';
import '../../shared/components/InputComponent.dart';
import '../../shared/components/LoadingComponent.dart';
import '../../shared/components/PaginacaoComponent.dart';
import '../../shared/components/TextComponent.dart';
import '../../shared/widgets/CardWidget.dart';
import '../../shared/widgets/NavBarWidget.dart';
import '../../widgets/sidebar_widget.dart';
import 'produto_details.dart';

class ProdutoList extends StatelessWidget {
  const ProdutoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = Get.put<ProdutoService>(ProdutoService());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const NavbarWidget(),
      drawer: const Sidebar(),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                TextComponent(
                  'Produtos',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: Get.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Get.width / 2,
                    child: InputComponent(
                      hintText: 'Buscar',
                      onChanged: (value) {
                        service.pesquisar = value;
                      },
                      onFieldSubmitted: (value) async {
                        service.pesquisar = value;
                        await service.listaProdutos();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 2,
                    child: ButtonComponent(
                      onPressed: () async {
                        await service.listaProdutos();
                      },
                      text: 'Buscar',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Obx(() => !service.carregando.value
                  ? ListView.builder(
                      itemCount: service.produtos.length,
                      itemBuilder: (context, index) {
                        final produto = service.produtos[index];
                        return InkWell(
                          onTap: () {
                            // Navegar para a tela de detalhes ao clicar no produto
                            Get.to(
                              ProdutoDetails(
                                idProduto: produto.idProduto.toString(),
                                nome: produto.descricao?.capitalize ?? '',
                                fornecedor: produto.fornecedor?.nomeFornecedor
                                        .toString() ??
                                    '',
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: CardWidget(
                              widget: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Expanded(
                                          flex: 2,
                                          child: TextComponent(
                                            'ID Produto',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SelectableText(
                                          produto.idProduto.toString(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Expanded(
                                          flex: 2,
                                          child: TextComponent(
                                            'Nome',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Flexible(
                                          // Adiciona o Flexible para permitir que o texto quebre
                                          child: SelectableText(
                                            produto.descricao?.capitalize ?? '',
                                            maxLines:
                                                2, // Define o número máximo de linhas
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            print(
                                                'Fornecedor selecionado: ${service.produtos[index]}');
                                            Get.to(
                                              () => ProdutoEditar(
                                                  produto:
                                                      service.produtos[index]),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            Get.defaultDialog(
                                              title: 'Confirmar Exclusão',
                                              content: Text(
                                                'Deseja realmente excluir o fornecedor?',
                                                textAlign: TextAlign.center,
                                              ),
                                              confirm: ElevatedButton(
                                                onPressed: () async {
                                                  Get.back();
                                                  service.deletarProduto(
                                                    service.produtos[index]
                                                        .idProduto!,
                                                  );
                                                  service.produtos
                                                      .removeAt(index);

                                                  // Atualiza a UI
                                                  Get.forceAppUpdate();

                                                  // Recarrega a lista após a exclusão
                                                  await service.listaProdutos();
                                                },
                                                child: Text('Confirmar'),
                                              ),
                                              cancel: ElevatedButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text('Cancelar'),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const LoadingComponent()),
            ),
            GetBuilder<ProdutoService>(
              builder: (_) => PaginacaoComponent(
                total: service.pagina.getTotal(),
                atual: service.pagina.getAtual(),
                primeiraPagina: () {
                  service.pagina.primeira();
                  service.listaProdutos();
                },
                anteriorPagina: () {
                  service.pagina.anterior();
                  service.listaProdutos();
                },
                proximaPagina: () {
                  service.pagina.proxima();
                  service.listaProdutos();
                },
                ultimaPagina: () {
                  service.pagina.ultima();
                  service.listaProdutos();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
