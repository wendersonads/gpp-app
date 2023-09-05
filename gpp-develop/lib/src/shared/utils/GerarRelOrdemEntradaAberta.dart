import 'dart:typed_data';

import 'package:gpp/src/models/pedido_entrada_model.dart';
import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class GerarRelOrdemEntradaAberta {
  List<PedidoEntradaModel> pedidos;
  String? periodoDataInicio;
  String? periodoDataFim;
  DateTime dataAtual = DateTime.now().toUtc();
  MaskFormatter maskFormatter = MaskFormatter();
  NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

  GerarRelOrdemEntradaAberta({
    required this.pedidos,
    this.periodoDataInicio,
    this.periodoDataFim,
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
                      pw.Row(
                        children: [
                          pw.Text('Remetente do Pedido: ${pedidos.first.clienteFilial?.cliente?.nome ?? ''}'),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text('Endereço: '),
                          pw.Text('${pedidos.first.clienteFilial?.cliente?.end_cliente?.logradouro ?? ''}',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Row(
                            children: [
                              pw.Text('Bairro: '),
                              pw.Text('${pedidos.first.clienteFilial?.cliente?.end_cliente?.bairro ?? ''}',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                          pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                          pw.Row(
                            children: [
                              pw.Text('Cidade: '),
                              pw.Text('${pedidos.first.clienteFilial?.cliente?.end_cliente?.localidade ?? ''}',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                          pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                          pw.Row(
                            children: [
                              pw.Text('UF: '),
                              pw.Text('${pedidos.first.clienteFilial?.cliente?.end_cliente?.uf ?? ''}',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                          pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                          pw.Row(
                            children: [
                              pw.Text('Cep: '),
                              pw.Text('${pedidos.first.clienteFilial?.cliente?.end_cliente?.cep ?? ''}',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text('Fone: ${''}'),
                        ],
                      ),
                    ],
                  ),
                  pw.Padding(padding: pw.EdgeInsets.only(bottom: 5)),
                  pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          pw.Text(
                              'Destinário: ${pedidos.first.asteca?.compEstProd?.first.produto?.fornecedores?.first.cliente?.nome ?? ''}'),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text('Endereço: '),
                          pw.Text(
                              '${pedidos.first.asteca?.compEstProd?.first.produto?.fornecedores?.first.cliente?.end_cliente?.logradouro ?? ''}',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Row(
                            children: [
                              pw.Text('Bairro: '),
                              pw.Text(
                                  '${pedidos.first.asteca?.compEstProd?.first.produto?.fornecedores?.first.cliente?.end_cliente?.bairro ?? ''}',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                          pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                          pw.Row(
                            children: [
                              pw.Text('Cidade: '),
                              pw.Text(
                                  '${pedidos.first.asteca?.compEstProd?.first.produto?.fornecedores?.first.cliente?.end_cliente?.localidade ?? ''}',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                          pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                          pw.Row(
                            children: [
                              pw.Text('UF: '),
                              pw.Text(
                                  '${pedidos.first.asteca?.compEstProd?.first.produto?.fornecedores?.first.cliente?.end_cliente?.uf ?? ''}',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                          pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                          pw.Row(
                            children: [
                              pw.Text('Cep: '),
                              pw.Text(
                                  '${pedidos.first.asteca?.compEstProd?.first.produto?.fornecedores?.first.cliente?.end_cliente?.cep ?? ''}',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text('Fone: ${''}'),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text('E-mail: '),
                          pw.Text('${'estoquemoveis500@novomundo.com.br'} ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  pw.Padding(padding: pw.EdgeInsets.only(bottom: 30)),
                  pw.Center(
                    child: pw.Column(
                      children: [
                        pw.Text(
                          'Relatório de Ordens de Entrada Abertas',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20),
                        ),
                        pw.Padding(padding: pw.EdgeInsets.only(bottom: 10)),
                        pw.Text(
                          '${pedidos.first.asteca?.compEstProd?.first.produto?.codFornecedor?.denominacao ?? ''}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20),
                        ),
                        pw.Padding(padding: pw.EdgeInsets.only(bottom: 10)),
                        pw.Text(
                          'Quantidade de ordens de entrada: ${pedidos.length}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20),
                        ),
                        pw.Padding(padding: pw.EdgeInsets.only(bottom: 10)),
                        pw.Text(
                          'Período: ${periodoDataInicio ?? ''} até ${periodoDataFim ?? ''}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  pw.Container(
                    height: 250,
                  ),
                ],
              ),
            ),
            pw.Wrap(
              children: List<pw.Widget>.generate(
                pedidos.length,
                (index) => pw.Column(
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.all(2.0),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(),
                      ),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Text('Nº Ped: '),
                              pw.Text('${pedidos[index].idPedidoEntrada}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.Padding(padding: pw.EdgeInsets.only(right: 30)),
                              pw.Text('Cli: '),
                              pw.Text('${pedidos[index].asteca?.documentoFiscal?.cliente?.nome ?? ''}',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Text('FS: '),
                              pw.Text('${pedidos[index].asteca?.documentoFiscal?.idFilialSaida ?? ''}',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                              pw.Text('NF: '),
                              pw.Text('${pedidos[index].asteca?.documentoFiscal?.numDocFiscal ?? ''}',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                              pw.Text('Sr: '),
                              pw.Text('${pedidos[index].asteca?.documentoFiscal?.serieDocFiscal ?? ''}',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                              pw.Text('F. Orig: '),
                              pw.Text('${pedidos[index].asteca?.idFilialRegistro}',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                              pw.Text('F. Vend: '),
                              pw.Text('${pedidos[index].asteca?.documentoFiscal?.idFilialVenda ?? ''}',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                              pw.Text('Dias: '),
                              pw.Text(
                                  '${pedidos[index].asteca == null ? dataAtual.toUtc().difference(pedidos[index].dataEmissao!).inDays : dataAtual.toUtc().difference(pedidos[index].asteca!.dataEmissao!).inDays}',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    pw.Container(
                      child: pw.Row(
                        // mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Flexible(
                            flex: 1,
                            child: pw.Row(
                              children: [pw.Text('Cod Prod')],
                            ),
                          ),
                          pw.Padding(padding: pw.EdgeInsets.only(right: 20)),
                          pw.Flexible(
                            flex: 4,
                            child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [pw.Text('Descrição')],
                            ),
                          ),
                          pw.Padding(padding: pw.EdgeInsets.only(right: 100)),
                          pw.Flexible(
                            flex: 1,
                            child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [pw.Text('Motivo')],
                            ),
                          ),
                          pw.Padding(padding: pw.EdgeInsets.only(right: 20)),
                          pw.Flexible(
                            flex: 1,
                            child: pw.Row(
                              children: [pw.Text('Qtde')],
                            ),
                          ),
                        ],
                      ),
                    ),
                    pedidos[index].asteca == null
                        ? pw.Wrap(
                            children: List<pw.Widget>.generate(
                            pedidos[index].itensPedidoEntrada?.length ?? 1,
                            (index2) => pw.Column(
                              children: [
                                pw.Container(
                                  child: pw.Row(
                                    children: [
                                      pw.Flexible(
                                        flex: 1,
                                        child: pw.Row(
                                          children: [
                                            pw.Text(
                                              '${pedidos[index].asteca?.compEstProd?.first.produto?.idProduto ?? ''}',
                                            )
                                          ],
                                        ),
                                      ),
                                      pw.Padding(padding: pw.EdgeInsets.only(right: 20)),
                                      pw.Flexible(
                                        flex: 4,
                                        child: pw.Row(
                                          children: [
                                            pw.Row(
                                              children: [
                                                pw.Text('${pedidos[index].itensPedidoEntrada?[index2].peca?.numero ?? ''}'),
                                              ],
                                            ),
                                            pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                                            pw.Row(
                                              children: [
                                                pw.Text('${pedidos[index].itensPedidoEntrada?[index2].peca?.id_peca ?? ''}'),
                                              ],
                                            ),
                                            pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                                            pw.Row(
                                              children: [
                                                pw.Text(
                                                    '${pedidos[index].itensPedidoEntrada?[index2].peca?.codigo_fabrica ?? ''}'),
                                              ],
                                            ),
                                            pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                                            pw.Row(
                                              children: [
                                                pw.Text('${pedidos[index].itensPedidoEntrada?[index2].peca?.descricao ?? ''}'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      pw.Padding(padding: pw.EdgeInsets.only(right: 100)),
                                      pw.Flexible(
                                        flex: 1,
                                        child: pw.Row(
                                          children: [
                                            pw.Text('Motivo'),
                                          ],
                                        ),
                                      ),
                                      pw.Padding(padding: pw.EdgeInsets.only(right: 20)),
                                      pw.Flexible(
                                        flex: 1,
                                        child: pw.Row(
                                          children: [
                                            pw.Text('Qtde'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ))
                        : pw.Wrap(
                            children: List<pw.Widget>.generate(
                              pedidos[index].asteca?.pedidoSaida?.itemsPedidoSaida?.length ?? 1,
                              (index2) => pw.Column(
                                children: [
                                  pw.Container(
                                    child: pw.Row(
                                      children: [
                                        pw.Flexible(
                                          flex: 1,
                                          child: pw.Row(
                                            children: [
                                              pw.Text(
                                                '${pedidos[index].asteca?.compEstProd?.first.produto?.idProduto ?? ''}',
                                              )
                                            ],
                                          ),
                                        ),
                                        pw.Padding(padding: pw.EdgeInsets.only(right: 20)),
                                        pw.Flexible(
                                          flex: 4,
                                          child: pw.Row(
                                            children: [
                                              pw.Row(
                                                children: [
                                                  pw.Text(
                                                      '${pedidos[index].asteca?.pedidoSaida?.itemsPedidoSaida?[index2].peca?.numero ?? ''}'),
                                                ],
                                              ),
                                              pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                                              pw.Row(
                                                children: [
                                                  pw.Text(
                                                      '${pedidos[index].asteca?.pedidoSaida?.itemsPedidoSaida?[index2].peca?.id_peca ?? ''}'),
                                                ],
                                              ),
                                              pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                                              pw.Row(
                                                children: [
                                                  pw.Text(
                                                      '${pedidos[index].asteca?.pedidoSaida?.itemsPedidoSaida?[index2].peca?.codigo_fabrica ?? ''}'),
                                                ],
                                              ),
                                              pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                                              pw.Row(
                                                children: [
                                                  pw.Text(
                                                      '${pedidos[index].asteca?.pedidoSaida?.itemsPedidoSaida?[index2].peca?.descricao ?? ''}'),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        pw.Padding(padding: pw.EdgeInsets.only(right: 100)),
                                        pw.Flexible(
                                          flex: 1,
                                          child: pw.Row(
                                            children: [
                                              pw.Text(
                                                  '${pedidos[index].asteca?.pedidoSaida?.itemsPedidoSaida?[index2].motivoTrocaPeca?.nome ?? ''}'),
                                            ],
                                          ),
                                        ),
                                        pw.Padding(padding: pw.EdgeInsets.only(right: 20)),
                                        pw.Flexible(
                                          flex: 1,
                                          child: pw.Row(
                                            children: [
                                              pw.Text(
                                                  '${pedidos[index].asteca?.pedidoSaida?.itemsPedidoSaida?[index2].quantidade ?? ''}'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            // pw.Container(
            //   child: pw.Column(
            //     children: [
            //       pw.Row(
            //         mainAxisAlignment: pw.MainAxisAlignment.start,
            //         children: [
            //           pw.Text('Pedidos ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
            //         ],
            //       ),
            //       pw.Padding(padding: pw.EdgeInsets.only(bottom: 20)),
            //       pw.Row(
            //         mainAxisAlignment: pw.MainAxisAlignment.start,
            //         children: [
            //           pw.Text('Total Aberto: '),
            //           pw.Text('${pedidos.length}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            //         ],
            //       ),

            //     ],
            //   ),
            // ),
          ];
        },
      ),
    );

    // Build and return the final Pdf file data
    return await doc.save();
  }
}
