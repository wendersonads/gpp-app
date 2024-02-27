import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/model/fornecedor_model.dart';
import '../../domain/service/fornecedor_service.dart';
import '../../shared/components/ButtonComponent.dart';
import '../../shared/components/TextComponent.dart';
import '../../shared/widgets/NavBarWidget.dart';
import '../../widgets/sidebar_widget.dart';
import 'fornecedor_list.dart';

class FornecedorEditar extends StatefulWidget {
  final Fornecedor fornecedor;

  const FornecedorEditar({Key? key, required this.fornecedor})
      : super(key: key);

  @override
  _EditarFornecedorFormState createState() => _EditarFornecedorFormState();
}

class _EditarFornecedorFormState extends State<FornecedorEditar> {
  final FornecedorService fornecedorService = FornecedorService();

  final TextEditingController idFornecedorController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cnpjController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Preencha os controladores com os dados do fornecedor a ser editado
    idFornecedorController.text = widget.fornecedor.idFornecedor.toString();
    nomeController.text = widget.fornecedor.nomeFornecedor ?? '';
    emailController.text = widget.fornecedor.email ?? '';
    cnpjController.text = widget.fornecedor.cnpj ?? '';
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
                    const TextComponent('Editar Fornecedor'),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _fornecedorForm(context),
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

  Widget _fornecedorForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: nomeController,
            decoration: InputDecoration(labelText: 'Nome do Fornecedor'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'E-mail do Fornecedor'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: cnpjController,
            decoration: InputDecoration(labelText: 'CNPJ do Fornecedor'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              editarFornecedor(context);
              // Após editar, navegar para a tela de listagem de fornecedores
              Get.offAll(() => FornecedorList());
            },
            child: Text('Salvar Alterações'),
          ),
        ],
      ),
    );
  }

  void editarFornecedor(BuildContext context) async {
    final fornecedorEditado = Fornecedor(
      idFornecedor: idFornecedorController.text.toInt(),
      nomeFornecedor: nomeController.text,
      email: emailController.text,
      cnpj: cnpjController.text,
    );

    await fornecedorService.editarFornecedor(fornecedorEditado);

    // Limpar os controladores após editar o fornecedor
    idFornecedorController.clear();
    nomeController.clear();
    emailController.clear();
    cnpjController.clear();

    // Navegar para a tela anterior ou realizar alguma outra ação desejada
    Get.back();
  }
}
