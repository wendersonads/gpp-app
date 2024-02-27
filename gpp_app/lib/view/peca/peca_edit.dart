import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/model/peca_model.dart';
import '../../domain/service/peca_service.dart';
import '../../shared/components/ButtonComponent.dart';
import '../../shared/components/TextComponent.dart';
import '../../shared/widgets/NavBarWidget.dart';
import '../../widgets/sidebar_widget.dart';
import 'peca_list.dart';

class PecaEditar extends StatefulWidget {
  final Peca peca;

  const PecaEditar({Key? key, required this.peca}) : super(key: key);

  @override
  _EditarPecaFormState createState() => _EditarPecaFormState();
}

class _EditarPecaFormState extends State<PecaEditar> {
  final PecaService pecaService = PecaService();

  final TextEditingController idPecaController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cnpjController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Preencha os controladores com os dados do peca a ser editado
    idPecaController.text = widget.peca.idPeca.toString();
    descricaoController.text = widget.peca.descricao ?? '';
    emailController.text = widget.peca.descricao ?? '';
    cnpjController.text = widget.peca.descricao ?? '';
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
                    const TextComponent('Editar Peca'),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _pecaForm(context),
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

  Widget _pecaForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: descricaoController,
            decoration: InputDecoration(labelText: 'Nome do Peca'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'E-mail do Peca'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: cnpjController,
            decoration: InputDecoration(labelText: 'CNPJ do Peca'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              editarPeca(context);
              // Após editar, navegar para a tela de listagem de pecaes
              Get.offAll(() => PecaList());
            },
            child: Text('Salvar Alterações'),
          ),
        ],
      ),
    );
  }

  void editarPeca(BuildContext context) async {
    final pecaEditado = Peca(
      idPeca: idPecaController.text.toInt(),
      material: descricaoController.text,
      cor: emailController.text,
      materialFabricacao: cnpjController.text,
    );

    await pecaService.adicionarPeca(pecaEditado);

    // Limpar os controladores após editar o peca
    idPecaController.clear();
    descricaoController.clear();
    emailController.clear();
    cnpjController.clear();

    // Navegar para a tela anterior ou realizar alguma outra ação desejada
    Get.back();
  }
}
