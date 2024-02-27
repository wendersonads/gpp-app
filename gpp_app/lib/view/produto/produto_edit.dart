import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/model/produto_model.dart';
import '../../domain/service/produto_service.dart';
import '../../shared/components/ButtonComponent.dart';
import '../../shared/components/TextComponent.dart';
import '../../shared/widgets/NavBarWidget.dart';
import '../../widgets/sidebar_widget.dart';
import 'produto_list.dart';

class ProdutoEditar extends StatefulWidget {
  final Produto produto;

  const ProdutoEditar({Key? key, required this.produto})
      : super(key: key);

  @override
  _EditarProdutoFormState createState() => _EditarProdutoFormState();
}

class _EditarProdutoFormState extends State<ProdutoEditar> {
  final ProdutoService produtoService = ProdutoService();

  final TextEditingController idProdutoController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cnpjController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Preencha os controladores com os dados do produto a ser editado
    idProdutoController.text = widget.produto.idProduto.toString();
    nomeController.text = widget.produto.idProduto.toString() ?? '';
    emailController.text = widget.produto.idProduto.toString() ?? '';
    cnpjController.text = widget.produto.idProduto.toString() ?? '';
  }

  Widget _buildBotaoPrincipal(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 64,
          child: ButtonComponent(
            color: Colors.red,
            onPressed: () {
              Get.offAllNamed('/home');
            },
            text: 'Fechar',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavbarWidget(),
      drawer: const Sidebar(),
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    const TextComponent('Editar Produto'),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _produtoForm(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildBotaoPrincipal(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _produtoForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: nomeController,
            decoration: InputDecoration(labelText: 'Nome do Produto'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'E-mail do Produto'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: cnpjController,
            decoration: InputDecoration(labelText: 'CNPJ do Produto'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              editarProduto(context);
              // Após editar, navegar para a tela de listagem de produtoes
              Get.offAll(() => ProdutoList());
            },
            child: Text('Salvar Alterações'),
          ),
        ],
      ),
    );
  }

  void editarProduto(BuildContext context) async {
    final produtoEditado = Produto(
      idProduto: idProdutoController.text.toInt(),
      descricao: nomeController.text
    );

    await produtoService.editarProduto(produtoEditado);

    // Limpar os controladores após editar o produto
    idProdutoController.clear();
    nomeController.clear();
    emailController.clear();
    cnpjController.clear();

    // Navegar para a tela anterior ou realizar alguma outra ação desejada
    Get.back();
  }
}
