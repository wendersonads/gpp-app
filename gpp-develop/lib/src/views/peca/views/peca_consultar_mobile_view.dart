import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpp/src/controllers/pecas_controller/peca_consultar_mobile_controller.dart';
import 'package:gpp/src/models/pecas_model/peca_model.dart';
import 'package:gpp/src/shared/components/loading_view.dart';
import 'package:gpp/src/utils/notificacao.dart';
import 'package:get/get.dart';
import 'package:gpp/src/shared/components/ButtonComponent.dart';
import 'package:gpp/src/shared/components/InputComponent.dart';
import 'package:gpp/src/views/peca/views/peca_detalhe_form_view.dart';
import 'package:gpp/src/views/widgets/appbar_widget.dart';
import 'package:gpp/src/views/widgets/sidebar_widget.dart';

class PecaConsultarMobileView extends StatelessWidget {
  PecaConsultarMobileView({Key? key}) : super(key: key);

  final _controller = Get.put(PecaConsultarMobileController());

  exibirPecaForm({PecasModel? pecasModel, required BuildContext context}) {
    Get.dialog(AlertDialog(
      title: PecaDetalheFormView(pecasModel: pecasModel),
      insetPadding: EdgeInsets.all(16),
    ));
  }

  consultaPeca(BuildContext context) async {
    // ignore: unnecessary_null_comparison
    if (_controller.idPeca != null) {
      await _controller.buscarPeca();
      if (_controller.pecaModel != null) {
        await exibirPecaForm(context: context, pecasModel: _controller.pecaModel);
        _controller.idPeca = 0;
      }
    } else {
      _controller.carregando(false);
      Notificacao.snackBar('Informe um código válido!', tipoNotificacao: TipoNotificacaoEnum.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    double FONTECARDBASE = 20;
    int MAXLENGTH = 26;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: NavbarWidget(),
        drawer: Sidebar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              context.width > 576 ? Sidebar() : Container(),
              Obx(
                () => !_controller.carregando.value
                    ? Container(
                        width: context.width > 576 ? context.width * 0.8 : context.width,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(16),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  runSpacing: 10,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Container(
                                          width: 380,
                                          child: Text(
                                            'Consultar peças',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 27,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Container(
                                              child: Obx(
                                                () => !_controller.carregando.value
                                                    ? InputComponent(
                                                        keyboardType: TextInputType.number,
                                                        hintText: 'Informe o código da peça',
                                                        inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                                                        autofocus: _controller.dialog.value,
                                                        onChanged: (value) {
                                                          if (int.parse(value) != 0) {
                                                            _controller.idPeca = int.parse(value.toString());
                                                          } else {
                                                            _controller.idPeca = 0;
                                                          }
                                                        },
                                                        onFieldSubmitted: (value) async {
                                                          _controller.dialog(false);
                                                          await consultaPeca(context);
                                                        })
                                                    : LoadingComponent(),
                                              ),
                                            )),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              height: 48.2,
                                              width: 140,
                                              child: ButtonComponent(
                                                  text: 'Buscar',
                                                  onPressed: () async {
                                                    _controller.dialog(false);
                                                    await consultaPeca(context);
                                                  }),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 3),
                              Container(
                                width: 380,
                                child: Text(
                                  'Historico de peças',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                ),
                              ),
                              SizedBox(height: 10),
                              ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _controller.pecas.length < 4 ? _controller.pecas.length : 4,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Obx(
                                      () => !_controller.carregando.value
                                          ? Container(
                                              height: 101,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  _controller.dialog(false);
                                                  _controller.pecaModel = _controller.pecas[index];
                                                  _controller.idPeca = _controller.pecas[index].id_peca ?? 0;
                                                  await consultaPeca(context);
                                                },
                                                child: _controller.pecas[index].descricao!.length > MAXLENGTH
                                                    ? Card(
                                                        color: Color.fromARGB(255, 255, 255, 255),
                                                        elevation: 3,
                                                        child: Container(
                                                          padding: EdgeInsets.symmetric(vertical: 9, horizontal: 6),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Wrap(
                                                                children: [
                                                                  Text(
                                                                    'Descrição: ',
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.bold, fontSize: FONTECARDBASE),
                                                                  ),
                                                                  Text(
                                                                    '${_controller.pecas[index].descricao}',
                                                                    style: TextStyle(fontSize: FONTECARDBASE),
                                                                    maxLines: 1,
                                                                  ),
                                                                ],
                                                              ),
                                                              Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      'Código: ',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.bold, fontSize: FONTECARDBASE),
                                                                    ),
                                                                    Text('${_controller.pecas[index].id_peca}',
                                                                        style: TextStyle(fontSize: FONTECARDBASE)),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ))
                                                    : Card(
                                                        color: Color.fromARGB(255, 255, 255, 255),
                                                        elevation: 3,
                                                        child: Container(
                                                          padding: EdgeInsets.symmetric(vertical: 9, horizontal: 6),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Wrap(
                                                                children: [
                                                                  Text(
                                                                    'Descrição: ',
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.bold, fontSize: FONTECARDBASE),
                                                                  ),
                                                                  Text(
                                                                    '${_controller.pecas[index].descricao}',
                                                                    style: TextStyle(fontSize: FONTECARDBASE),
                                                                    maxLines: 1,
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(height: 25),
                                                              Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      'Código: ',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight.bold, fontSize: FONTECARDBASE),
                                                                    ),
                                                                    Text('${_controller.pecas[index].id_peca}',
                                                                        style: TextStyle(fontSize: FONTECARDBASE)),
                                                                  ],
                                                                ),
                                                              ) /* ,
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Cor: ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize:
                                                                FONTECARDBASE),
                                                      ),
                                                      Text(
                                                          '${_controller.pecas[index].cor ?? '-'}',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  FONTECARDBASE)),
                                                    ],
                                                  ) */
                                                            ],
                                                          ),
                                                        )),
                                              ),
                                            )
                                          : LoadingComponent(),
                                    );
                                  },
                                  separatorBuilder: (context, index) => SizedBox(
                                        height: 18,
                                      )),
                            ],
                          ),
                        ),
                      )
                    : Container(height: Get.height * 0.85, child: Center(child: LoadingComponent())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
