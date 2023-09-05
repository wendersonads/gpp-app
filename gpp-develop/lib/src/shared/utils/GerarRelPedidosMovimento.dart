import 'dart:typed_data';

import 'package:gpp/src/models/entrada/movimento_entrada_model.dart';
import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class GerarRelPedidosMovimento {
  MovimentoEntradaModel movimento;
  DateTime dataAtual = DateTime.now().toUtc();
  MaskFormatter maskFormatter = MaskFormatter();
  NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

  GerarRelPedidosMovimento({
    required this.movimento,
  });

  Future<void> imprimirPDF() async {
    Printing.layoutPdf(
      // [onLayout] will be called multiple times
      // when the user changes the printer or printer settings
      onLayout: (PdfPageFormat format) {
        // Any valid Pdf document can be returned here as a list of int
        return buildPdf(format);
      },
    );
  }

  Future<Uint8List> buildPdf(PdfPageFormat format) async {
    // Cria o documento PDF
    final pw.Document doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape.copyWith(marginLeft: 20, marginRight: 20, marginBottom: 20, marginTop: 20),
        footer: (pw.Context context) {
          return pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text(
                  'Documento gerado em ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())} - Página ${context.pageNumber}/${context.pagesCount}'),
            ],
          );
        },
        build: (pw.Context context) {
          return [
            pw.Container(
              // height: 500,
              child: pw.Column(
                children: [
                  pw.Column(
                    children: [
                      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                        pw.Row(
                          children: [
                            pw.Text(
                              'Empresa:',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
                            ),
                            pw.Text(
                              'Novo Mundo Moveis e Utilidades Ltda',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
                            )
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Text('Data de Emissão: '),
                            pw.Text('${DateFormat('dd/MM/yyyy').format(dataAtual)} ${DateFormat('HH:mm').format(dataAtual)}',
                                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                      ]),
                      pw.SizedBox(height: 12),
                      pw.Row(
                        children: [
                          pw.Text('Relatório de Conferência de Pedidos referente ao Movimento: '),
                          pw.Text('${movimento.id_movimento_entrada}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                      pw.SizedBox(height: 12),
                      pw.Row(
                        children: [
                          pw.Text('Total de Pedidos: '),
                          pw.Text('${movimento.pedidoEntrada?.length ?? 0}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                      pw.SizedBox(height: 12),
                    ],
                  ),
                ],
              ),
            ),
            pw.Wrap(
              children: List<pw.Widget>.generate(
                movimento.pedidoEntrada?.length ?? 1,
                (index) => pw.Column(
                  children: [
                    pw.Divider(thickness: 3),
                    pw.SizedBox(height: 5),
                    pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
                      pw.Expanded(
                        flex: 0,
                        child: pw.Container(
                          padding: pw.EdgeInsets.symmetric(horizontal: 2),
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(),
                          ),
                          child: pw.Text('Situação atendimento Asteca'),
                        ),
                      ),
                      pw.SizedBox(width: 8),
                      movimento.pedidoEntrada?[index].asteca == null
                          ? pw.Expanded(
                              flex: 0,
                              child: pw.Text('PEDIDO MANUAL'),
                            )
                          : movimento.pedidoEntrada?[index].asteca?.pedidoSaida?.pedidoSaidaEvento?.last.eventoStatus?.descricao
                                      ?.compareTo('Aguardando fornecedor') !=
                                  0
                              ? movimento.pedidoEntrada![index].asteca?.pedidoSaida?.pedidoSaidaEvento?.last.eventoStatus
                                          ?.descricao
                                          ?.compareTo('Concluído') ==
                                      0
                                  ? pw.Expanded(
                                      flex: 0,
                                      child: pw.Text('ASTECA ATENDIMENTO CONCLUÍDO'),
                                    )
                                  : pw.Expanded(
                                      flex: 0,
                                      child: pw.Text('ASTECA EM ATENDIMENTO'),
                                    )
                              : pw.Expanded(
                                  flex: 0,
                                  child: pw.Text('ASTECA AGUARDANDO ATENDIMENTO'),
                                )
                    ]),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(horizontal: 2),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(),
                            ),
                            child: pw.Text('Asteca'),
                          ),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(horizontal: 2),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(),
                            ),
                            child: pw.Text('Pedido'),
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(horizontal: 2),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(),
                            ),
                            child: pw.Text('Emissão'),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(horizontal: 2),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(),
                            ),
                            child: pw.Text('Dt. Dias'),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(horizontal: 2),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(),
                            ),
                            child: pw.Text('Filial'),
                          ),
                        ),
                        pw.Expanded(
                          flex: 4,
                          child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(horizontal: 2),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(),
                            ),
                            child: pw.Text('Nome Cliente'),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(horizontal: 2),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(),
                            ),
                            child: pw.Text('F.S '),
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(horizontal: 2),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(),
                            ),
                            child: pw.Text('Nota Fiscal'),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(horizontal: 2),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(),
                            ),
                            child: pw.Text('Série'),
                          ),
                        ),
                        // pw.Expanded(
                        //   child: pw.Container(
                        //     padding: pw.EdgeInsets.symmetric(horizontal: 2),
                        //     decoration: pw.BoxDecoration(
                        //       border: pw.Border.all(),
                        //     ),
                        //     child: pw.Text('Usuário'),
                        //   ),
                        // ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(horizontal: 2),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(),
                            ),
                            child: pw.Text('Dt. Indicação'),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                            padding: pw.EdgeInsets.symmetric(horizontal: 2),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(),
                            ),
                            child: pw.Text('Dt. Dias'),
                          ),
                        ),
                        // pw.Expanded(
                        //   child: pw.Container(
                        //     padding: pw.EdgeInsets.symmetric(horizontal: 2),
                        //     decoration: pw.BoxDecoration(
                        //       border: pw.Border.all(),
                        //     ),
                        //     child: pw.Text('Usu. '),
                        //   ),
                        // )
                      ],
                    ),
                    pw.SizedBox(height: 3),
                    pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Text('${movimento.pedidoEntrada?[index].asteca?.idAsteca ?? ''}'),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text('${movimento.pedidoEntrada?[index].idPedidoEntrada ?? ''}'),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(
                              '${movimento.pedidoEntrada?[index].dataEmissao != null ? DateFormat('dd/MM/yyyy').format(movimento.pedidoEntrada![index].dataEmissao!) : ''}'),
                        ),
                        pw.Expanded(
                          child: pw.Text('${dataAtual.toUtc().difference(movimento.pedidoEntrada![index].dataEmissao!).inDays}'),
                        ),
                        pw.Expanded(
                          child: pw.Text('${movimento.pedidoEntrada?[index].filial_registro ?? ''}'),
                        ),
                        pw.Expanded(
                          flex: 4,
                          child: pw.Text('${movimento.pedidoEntrada?[index].asteca?.documentoFiscal?.cliente?.nome ?? ''}'),
                        ),
                        pw.Expanded(
                          child: pw.Text('${movimento.pedidoEntrada?[index].asteca?.documentoFiscal?.idFilialSaida ?? ''}'),
                        ),
                        pw.Expanded(
                            flex: 2,
                            child: pw.Text('${movimento.pedidoEntrada?[index].asteca?.documentoFiscal?.numDocFiscal ?? ''}')),
                        pw.Expanded(
                          child: pw.Text('${movimento.pedidoEntrada?[index].asteca?.documentoFiscal?.serieDocFiscal ?? ''}'),
                        ),
                        // pw.Expanded(
                        //   child: pw.Text('4002'),
                        // ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(
                              '${movimento.pedidoEntrada?[index].asteca?.dataEmissao != null ? DateFormat('dd/MM/yyyy').format(movimento.pedidoEntrada![index].asteca!.dataEmissao!) : ''}'),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                              ' ${movimento.pedidoEntrada?[index].asteca?.dataEmissao != null ? dataAtual.toUtc().difference(movimento.pedidoEntrada![index].asteca!.dataEmissao!).inDays : ''}'),
                        ),
                        // pw.Expanded(
                        //   child: pw.Text('Usu. '),
                        // ),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Column(
                      children: [
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Container(
                                padding: pw.EdgeInsets.symmetric(horizontal: 2),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(),
                                ),
                                child: pw.Text('Cod. Prod'),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Container(
                                padding: pw.EdgeInsets.symmetric(horizontal: 2),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(),
                                ),
                                child: pw.Text('NR'),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Container(
                                padding: pw.EdgeInsets.symmetric(horizontal: 2),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(),
                                ),
                                child: pw.Text('Cod Fab'),
                              ),
                            ),
                            pw.Expanded(
                              flex: 5,
                              child: pw.Container(
                                padding: pw.EdgeInsets.symmetric(horizontal: 2),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(),
                                ),
                                child: pw.Text('Descrição Peça'),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Container(
                                padding: pw.EdgeInsets.symmetric(horizontal: 2),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(),
                                ),
                                child: pw.Text('Qtd'),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Container(
                                padding: pw.EdgeInsets.symmetric(horizontal: 2),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(),
                                ),
                                child: pw.Text('Rec'),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Container(
                                padding: pw.EdgeInsets.symmetric(horizontal: 2),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(),
                                ),
                                child: pw.Text('Fata'),
                              ),
                            ),
                            pw.Expanded(
                              child: pw.Container(
                                padding: pw.EdgeInsets.symmetric(horizontal: 2),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(),
                                ),
                                child: pw.Text('Passa'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    movimento.pedidoEntrada?[index].asteca != null
                        ? movimento.pedidoEntrada![index].asteca?.pedidoSaida != null
                            ? pw.Wrap(
                                children: List<pw.Widget>.generate(
                                  movimento.pedidoEntrada?[index].asteca?.pedidoSaida?.itemsPedidoSaida?.length ?? 0,
                                  (index2) => pw.Column(
                                    children: [
                                      pw.Container(
                                        color: (index2 % 2) == 0 ? PdfColor.fromHex('EEEEEE') : PdfColor.fromHex('FFF'),
                                        child: pw.Row(
                                          children: [
                                            pw.Expanded(
                                              child: pw.Text(
                                                  '${movimento.pedidoEntrada?[index].asteca?.compEstProd?.first.produto?.idProduto ?? ''}'),
                                            ),
                                            pw.Expanded(
                                              child: pw.Text(
                                                  '${movimento.pedidoEntrada?[index].asteca?.pedidoSaida?.itemsPedidoSaida?[index2].peca?.numero ?? ''}'),
                                            ),
                                            pw.Expanded(
                                              child: pw.Text(
                                                  '${movimento.pedidoEntrada?[index].asteca?.pedidoSaida?.itemsPedidoSaida?[index2].peca?.codigo_fabrica ?? ''}'),
                                            ),
                                            pw.Expanded(
                                              flex: 5,
                                              child: pw.Text(
                                                  '${movimento.pedidoEntrada?[index].asteca?.pedidoSaida?.itemsPedidoSaida?[index2].peca?.descricao ?? ''}'),
                                            ),
                                            pw.Expanded(
                                              child: pw.Text(
                                                  '${movimento.pedidoEntrada?[index].asteca?.pedidoSaida?.itemsPedidoSaida?[index2].quantidade ?? ''}'),
                                            ),
                                            pw.Expanded(
                                              child: pw.Container(
                                                margin: pw.EdgeInsets.only(top: 2, right: 2),
                                                decoration: pw.BoxDecoration(
                                                  border:
                                                      pw.Border(left: pw.BorderSide(width: 1), bottom: pw.BorderSide(width: 1)),
                                                ),
                                                child: pw.Text(
                                                  '0',
                                                  style: pw.TextStyle(
                                                      color: (index2 % 2) == 0
                                                          ? PdfColor.fromHex('EEEEEE')
                                                          : PdfColor.fromHex('FFF')),
                                                ),
                                              ),
                                            ),
                                            pw.Expanded(
                                              child: pw.Container(
                                                margin: pw.EdgeInsets.only(top: 2, right: 2),
                                                decoration: pw.BoxDecoration(
                                                  border:
                                                      pw.Border(left: pw.BorderSide(width: 1), bottom: pw.BorderSide(width: 1)),
                                                ),
                                                child: pw.Text(
                                                  '0',
                                                  style: pw.TextStyle(
                                                      color: (index2 % 2) == 0
                                                          ? PdfColor.fromHex('EEEEEE')
                                                          : PdfColor.fromHex('FFF')),
                                                ),
                                              ),
                                            ),
                                            pw.Expanded(
                                              child: pw.Container(
                                                margin: pw.EdgeInsets.only(top: 2, right: 2),
                                                decoration: pw.BoxDecoration(
                                                  border:
                                                      pw.Border(left: pw.BorderSide(width: 1), bottom: pw.BorderSide(width: 1)),
                                                ),
                                                child: pw.Text(
                                                  '0',
                                                  style: pw.TextStyle(
                                                      color: (index2 % 2) == 0
                                                          ? PdfColor.fromHex('EEEEEE')
                                                          : PdfColor.fromHex('FFF')),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  //'${movimento.pedidoEntrada?[index].asteca?.compEstProd?.first.produto?.idProduto ?? ''}'),
                                ),
                              )
                            : pw.Wrap(
                                children: List<pw.Widget>.generate(
                                  movimento.pedidoEntrada?[index].itensPedidoEntrada?.length ?? 0,
                                  (index3) => pw.Column(
                                    children: [
                                      pw.Container(
                                        color: (index3 % 2) == 0 ? PdfColor.fromHex('EEEEEE') : PdfColor.fromHex('FFF'),
                                        child: pw.Row(
                                          children: [
                                            pw.Expanded(
                                              child: pw.Text(
                                                  '${movimento.pedidoEntrada?[index].asteca?.compEstProd?.first.produto?.idProduto ?? ''}'),
                                            ),
                                            pw.Expanded(
                                              child: pw.Text(
                                                  '${movimento.pedidoEntrada?[index].itensPedidoEntrada?[index3].peca?.numero ?? ''}'),
                                            ),
                                            pw.Expanded(
                                              child: pw.Text(
                                                  '${movimento.pedidoEntrada?[index].itensPedidoEntrada?[index3].peca?.codigo_fabrica ?? ''}'),
                                            ),
                                            pw.Expanded(
                                              flex: 5,
                                              child: pw.Text(
                                                  '${movimento.pedidoEntrada?[index].itensPedidoEntrada?[index3].peca?.descricao ?? ''}'),
                                            ),
                                            pw.Expanded(
                                              child: pw.Text(
                                                  '${movimento.pedidoEntrada?[index].itensPedidoEntrada?[index3].quantidade ?? ''}'),
                                            ),
                                            pw.Expanded(
                                              child: pw.Container(
                                                margin: pw.EdgeInsets.only(top: 2, right: 2),
                                                decoration: pw.BoxDecoration(
                                                  border:
                                                      pw.Border(left: pw.BorderSide(width: 1), bottom: pw.BorderSide(width: 1)),
                                                ),
                                                child: pw.Text(
                                                  '0',
                                                  style: pw.TextStyle(
                                                      color: (index3 % 2) == 0
                                                          ? PdfColor.fromHex('EEEEEE')
                                                          : PdfColor.fromHex('FFF')),
                                                ),
                                              ),
                                            ),
                                            pw.Expanded(
                                              child: pw.Container(
                                                margin: pw.EdgeInsets.only(top: 2, right: 2),
                                                decoration: pw.BoxDecoration(
                                                  border:
                                                      pw.Border(left: pw.BorderSide(width: 1), bottom: pw.BorderSide(width: 1)),
                                                ),
                                                child: pw.Text(
                                                  '0',
                                                  style: pw.TextStyle(
                                                      color: (index3 % 2) == 0
                                                          ? PdfColor.fromHex('EEEEEE')
                                                          : PdfColor.fromHex('FFF')),
                                                ),
                                              ),
                                            ),
                                            pw.Expanded(
                                              child: pw.Container(
                                                margin: pw.EdgeInsets.only(top: 2, right: 2),
                                                decoration: pw.BoxDecoration(
                                                  border:
                                                      pw.Border(left: pw.BorderSide(width: 1), bottom: pw.BorderSide(width: 1)),
                                                ),
                                                child: pw.Text(
                                                  '0',
                                                  style: pw.TextStyle(
                                                      color: (index3 % 2) == 0
                                                          ? PdfColor.fromHex('EEEEEE')
                                                          : PdfColor.fromHex('FFF')),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  //'${movimento.pedidoEntrada?[index].asteca?.compEstProd?.first.produto?.idProduto ?? ''}'),
                                ),
                              )
                        : pw.Wrap(
                            children: List<pw.Widget>.generate(
                              movimento.pedidoEntrada?[index].itensPedidoEntrada?.length ?? 0,
                              (index4) => pw.Column(
                                children: [
                                  pw.Container(
                                    color: (index4 % 2) == 0 ? PdfColor.fromHex('EEEEEE') : PdfColor.fromHex('FFF'),
                                    child: pw.Row(
                                      children: [
                                        pw.Expanded(
                                          child: pw.Text(
                                              '${movimento.pedidoEntrada?[index].asteca?.compEstProd?.first.produto?.idProduto ?? ''}'),
                                        ),
                                        pw.Expanded(
                                          child: pw.Text(
                                              '${movimento.pedidoEntrada?[index].itensPedidoEntrada?[index4].peca?.numero ?? ''}'),
                                        ),
                                        pw.Expanded(
                                          child: pw.Text(
                                              '${movimento.pedidoEntrada?[index].itensPedidoEntrada?[index4].peca?.codigo_fabrica ?? ''}'),
                                        ),
                                        pw.Expanded(
                                          flex: 5,
                                          child: pw.Text(
                                              '${movimento.pedidoEntrada?[index].itensPedidoEntrada?[index4].peca?.descricao ?? ''}'),
                                        ),
                                        pw.Expanded(
                                          child: pw.Text(
                                              '${movimento.pedidoEntrada?[index].itensPedidoEntrada?[index4].quantidade ?? ''}'),
                                        ),
                                        pw.Expanded(
                                          child: pw.Container(
                                            margin: pw.EdgeInsets.only(top: 2, right: 2),
                                            decoration: pw.BoxDecoration(
                                              border: pw.Border(left: pw.BorderSide(width: 1), bottom: pw.BorderSide(width: 1)),
                                            ),
                                            child: pw.Text(
                                              '0',
                                              style: pw.TextStyle(
                                                  color:
                                                      (index4 % 2) == 0 ? PdfColor.fromHex('EEEEEE') : PdfColor.fromHex('FFF')),
                                            ),
                                          ),
                                        ),
                                        pw.Expanded(
                                          child: pw.Container(
                                            margin: pw.EdgeInsets.only(top: 2, right: 2),
                                            decoration: pw.BoxDecoration(
                                              border: pw.Border(left: pw.BorderSide(width: 1), bottom: pw.BorderSide(width: 1)),
                                            ),
                                            child: pw.Text(
                                              '0',
                                              style: pw.TextStyle(
                                                  color:
                                                      (index4 % 2) == 0 ? PdfColor.fromHex('EEEEEE') : PdfColor.fromHex('FFF')),
                                            ),
                                          ),
                                        ),
                                        pw.Expanded(
                                          child: pw.Container(
                                            margin: pw.EdgeInsets.only(top: 2, right: 2),
                                            decoration: pw.BoxDecoration(
                                              border: pw.Border(left: pw.BorderSide(width: 1), bottom: pw.BorderSide(width: 1)),
                                            ),
                                            child: pw.Text(
                                              '0',
                                              style: pw.TextStyle(
                                                  color:
                                                      (index4 % 2) == 0 ? PdfColor.fromHex('EEEEEE') : PdfColor.fromHex('FFF')),
                                            ),
                                          ),
                                        ),
                                        pw.SizedBox(
                                          height: 16,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                    pw.SizedBox(
                      height: 16,
                    ),
                    pw.Row(
                      children: [
                        pw.Row(
                          children: [
                            pw.Text(
                              'Nº Atendimento:.......................',
                            ),
                            pw.SizedBox(
                              width: 5,
                            ),
                            pw.Text(
                              'At. Emissão:......./......./..............',
                            ),
                            pw.SizedBox(
                              width: 5,
                            ),
                            pw.Text(
                              'N.F:.......................',
                            ),
                            pw.SizedBox(
                              width: 5,
                            ),
                            pw.Text(
                              'Série:.......',
                            ),
                            pw.SizedBox(
                              width: 5,
                            ),
                            pw.Text(
                              'N.F Emissão:......./......./..............',
                            ),
                            pw.SizedBox(
                              width: 5,
                            ),
                            pw.Text(
                              'Qtd Volume:.............',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
      ),
    );

    // Build and return the final Pdf file data
    return await doc.save();
  }
}
