// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpp/src/controllers/pecas_controller/peca_consultar_mobile_controller.dart';
import 'package:gpp/src/models/pecas_model/peca_model.dart';

class PecaDetalheFormView extends StatefulWidget {
  PecasModel? pecasModel;

  PecaDetalheFormView({this.pecasModel, Key? key}) : super(key: key);

  @override
  State<PecaDetalheFormView> createState() => _PecaDetalheFormViewState();
}

class _PecaDetalheFormViewState extends State<PecaDetalheFormView> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PecaConsultarMobileController());

    var contaEnd;
    (widget.pecasModel?.estoque?.length ?? 0) > 1 ? contaEnd = true : contaEnd = false;
    final double FONTEBASE = 18;
    return Container(
      width: 330,
      child: Form(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CloseButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          controller.carregando(true);
                          await Future.delayed(Duration(milliseconds: 400));
                          controller.dialog(true);
                          controller.carregando(false);
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Informações da peça',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 11),
                (widget.pecasModel?.descricao?.length ?? 0) >= 19
                    ?
                    //maximo de caracteres no nome da peca e 23
                    Wrap(
                        runSpacing: 6,
                        alignment: WrapAlignment.start,
                        children: [
                          Text(
                            'Código: ${widget.pecasModel?.id_peca ?? ''}',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                          ),
                          Text('${widget.pecasModel?.descricao ?? ''}', style: TextStyle(fontSize: 26))
                        ],
                      )
                    : Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${widget.pecasModel?.id_peca ?? ' '} - ',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                            ),
                            Text('${widget.pecasModel?.descricao ?? ''}', style: TextStyle(fontSize: 26))
                          ],
                        ),
                      ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(height: 8),
                Wrap(
                  runSpacing: 4,
                  alignment: WrapAlignment.start,
                  children: [
                    Text(
                      'Fornecedor: ',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                      textAlign: TextAlign.start,
                    ),
                    (widget.pecasModel!.id_fornecedor) != null
                        ? Text(
                            '${widget.pecasModel?.produtoPeca?.first.produto?.fornecedores?.first.cliente?.nome.toString().capitalize ?? ''} ',
                            style: TextStyle(fontSize: FONTEBASE))
                        : Text('-')
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Material: ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                      ),
                      Text('${widget.pecasModel?.material ?? ''}', style: TextStyle(fontSize: FONTEBASE))
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Cor: ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                      ),
                      Text('${widget.pecasModel?.cor ?? ''}', style: TextStyle(fontSize: FONTEBASE))
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Altura: ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                        ),
                        Text('${widget.pecasModel?.altura ?? ''}', style: TextStyle(fontSize: FONTEBASE))
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Largura: ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                        ),
                        Text('${widget.pecasModel?.largura ?? ''}', style: TextStyle(fontSize: FONTEBASE))
                      ],
                    ),
                  ],
                )),
                SizedBox(height: 8),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Comprimento: ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                      ),
                      Text('${widget.pecasModel?.profundidade ?? ''}', style: TextStyle(fontSize: FONTEBASE))
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  runSpacing: 4,
                  alignment: WrapAlignment.start,
                  children: [
                    contaEnd
                        ? Text(
                            'Endereços: ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                          )
                        : Text(
                            'Endereço: ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: FONTEBASE),
                          ),
                    SizedBox(height: 35),
                    Container(
                      //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                      height: contaEnd ? 136 : 68,
                      width: double.maxFinite,
                      child: ListView.separated(
                          itemCount: widget.pecasModel?.estoque?.length ?? 0,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            int saldoTotal = (widget.pecasModel?.estoque?[index].saldoDisponivel ?? 0) +
                                (widget.pecasModel?.estoque?[index].saldoReservado ?? 0);
                            return Card(
                              color: Color.fromRGBO(229, 229, 229, 1),
                              elevation: 3,
                              child: Container(
                                height: 55,
                                padding: EdgeInsets.symmetric(horizontal: 7),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${widget.pecasModel?.estoque?[index].endereco ?? ''}',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Row(
                                      children: [
                                        Text('Saldo: ', style: TextStyle(fontSize: 20)),
                                        Text(
                                          '${saldoTotal}',
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                                height: 5,
                              )),
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
