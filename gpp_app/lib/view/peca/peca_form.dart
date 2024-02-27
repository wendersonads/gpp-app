import 'package:auth_migration/view/peca/peca_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/model/peca_model.dart';
import '../../domain/model/produto_model.dart';
import '../../domain/service/peca_service.dart';
import '../../shared/components/ButtonComponent.dart';
import '../../shared/components/TextComponent.dart';
import '../../shared/widgets/NavBarWidget.dart';
import '../../widgets/sidebar_widget.dart';

class PecaForm extends StatelessWidget {
  final PecaService pecaService = PecaService();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController codigoFabricaController = TextEditingController();
  final TextEditingController unidadeController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController larguraController = TextEditingController();
  final TextEditingController profundidadeController = TextEditingController();
  final TextEditingController unidadeMedidaController = TextEditingController();
  final TextEditingController volumesController = TextEditingController();
  final TextEditingController activeController = TextEditingController();
  final TextEditingController custoController = TextEditingController();
  final TextEditingController corController = TextEditingController();
  final TextEditingController materialController = TextEditingController();
  final TextEditingController idFornecedorController = TextEditingController();
  final TextEditingController materialFabricacaoController =
      TextEditingController();
  final TextEditingController produtoController = TextEditingController();

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
                    const TextComponent('Criar Peça'),
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
            controller: numeroController,
            decoration: InputDecoration(labelText: 'Número da Peça'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: codigoFabricaController,
            decoration: InputDecoration(labelText: 'Código de Fábrica'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: unidadeController,
            decoration: InputDecoration(labelText: 'Unidade'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: descricaoController,
            decoration: InputDecoration(labelText: 'Descrição da Peça'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: alturaController,
            decoration: InputDecoration(labelText: 'Altura da Peça'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: larguraController,
            decoration: InputDecoration(labelText: 'Largura da Peça'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: profundidadeController,
            decoration: InputDecoration(labelText: 'Profundidade da Peça'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: unidadeMedidaController,
            decoration: InputDecoration(labelText: 'Unidade de Medida'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: volumesController,
            decoration: InputDecoration(labelText: 'Volumes'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: activeController,
            decoration: InputDecoration(labelText: 'Ativo'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: custoController,
            decoration: InputDecoration(labelText: 'Custo'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: corController,
            decoration: InputDecoration(labelText: 'Cor'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: materialController,
            decoration: InputDecoration(labelText: 'Material'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: idFornecedorController,
            decoration: InputDecoration(labelText: 'ID do Fornecedor'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: materialFabricacaoController,
            decoration: InputDecoration(labelText: 'Material de Fabricação'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: produtoController,
            decoration: InputDecoration(labelText: 'Produto'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              criarNovaPeca(context);
            },
            child: Text('Adicionar Peça'),
          ),
        ],
      ),
    );
  }

  void criarNovaPeca(BuildContext context) async {
    final novaPeca = Peca(
        numero: numeroController.text,
        codigoFabrica: codigoFabricaController.text,
        unidade: int.parse(unidadeController.text),
        descricao: descricaoController.text,
        altura: int.parse(alturaController.text),
        largura: int.parse(larguraController.text),
        profundidade: int.parse(profundidadeController.text),
        unidadeMedida: int.parse(unidadeMedidaController.text),
        volumes: volumesController.text,
        active: activeController.text.toLowerCase() == 'true',
        custo: double.parse(custoController.text),
        cor: corController.text,
        material: materialController.text,
        idFornecedor: int.parse(idFornecedorController.text),
        materialFabricacao: materialFabricacaoController.text);
    // produto: Produto.parse(produtoController.text));

    await pecaService.adicionarPeca(novaPeca);

    // Limpar os controladores após adicionar a peça
    numeroController.clear();
    codigoFabricaController.clear();
    unidadeController.clear();
    descricaoController.clear();
    alturaController.clear();
    larguraController.clear();
    profundidadeController.clear();
    unidadeMedidaController.clear();
    volumesController.clear();
    activeController.clear();
    custoController.clear();
    corController.clear();
    materialController.clear();
    idFornecedorController.clear();
    materialFabricacaoController.clear();
    produtoController.clear();

    // Navegar para a tela PecaList após adicionar a peça
    Get.to(() => const PecaList());
  }
}
