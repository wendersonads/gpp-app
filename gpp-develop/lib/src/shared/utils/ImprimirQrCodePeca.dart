import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';

import 'package:gpp/src/models/pecas_model/peca_model.dart';
import 'package:gpp/src/shared/services/auth.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class ImprimirQrCodePeca {
  PecasModel? peca;

  ImprimirQrCodePeca({this.peca});

  Future<void> imprimirQrCode() async {
    Printing.layoutPdf(
      // [onLayout] will be called multiple times
      // when the user changes the printer or printer settings
      onLayout: (PdfPageFormat format) {
        // Any valid Pdf document can be returned here as a list of int

        return buildPdfPeca(format);
      },
    );
  }

  String validaUnidadeMedia(int? unidade) {
    switch (unidade) {
      case 0:
        return 'Milimetro';

      case 1:
        return 'Centímetro';

      case 2:
        return 'Metro';

      case 3:
        return 'Polegada';

      default:
        return '';
    }
  }

  // coment aqui

  Future<Uint8List> buildPdfPeca(PdfPageFormat format) async {
    final pw.Document doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: pw.EdgeInsets.only(left: 35, right: 0, bottom: 0, top: 2),
        orientation: pw.PageOrientation.landscape,
        build: (pw.Context context) {
          return pw.Container(
            //6 x 9.8 cm (1px = 0.28mm)
            height: 135,
            width: 255,
            constraints: pw.BoxConstraints(maxWidth: 370),
            padding: pw.EdgeInsets.all(10.0),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.Expanded(
                      child: pw.Container(
                          padding: pw.EdgeInsets.only(right: 5.0),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Row(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('${peca!.id_peca.toString()}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                  pw.Flexible(
                                    child: pw.Text(' - ${peca!.descricao}', maxLines: 2),
                                  )
                                ],
                              ),
                              pw.SizedBox(height: 4),
                              pw.Row(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('Fornecedor: ',
                                      style: pw.TextStyle(
                                        fontSize: 10,
                                      )),
                                  pw.Padding(padding: pw.EdgeInsets.only(right: 5)),
                                  pw.Flexible(
                                    child: pw.Text(
                                        '${peca!.produtoPeca?.first.produto?.fornecedores!.first.cliente?.nome.toString() ?? ''}',
                                        style: pw.TextStyle(
                                          fontSize: 10,
                                          fontWeight: pw.FontWeight.bold,
                                        ),
                                        maxLines: 1),
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 4),
                              pw.Wrap(
                                //tamanho maximo de cor antes de dar o wrap: 11
                                runSpacing: 4,
                                alignment: pw.WrapAlignment.start,
                                children: [
                                  pw.Text('Cod. Fab.: ',
                                      style: pw.TextStyle(
                                        fontSize: 10,
                                      )),
                                  pw.Padding(padding: pw.EdgeInsets.only(right: 2)),
                                  pw.Text('${peca?.codigo_fabrica ?? ''}',
                                      textDirection: pw.TextDirection.ltr,
                                      style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                                  pw.Padding(padding: pw.EdgeInsets.only(right: 3)),
                                  pw.Wrap(alignment: pw.WrapAlignment.start, children: [
                                    pw.Text('Cor: ',
                                        style: pw.TextStyle(
                                          fontSize: 10,
                                        )),
                                    pw.Padding(padding: pw.EdgeInsets.only(right: 1)),
                                    pw.Text('${peca?.cor ?? ''}',
                                        style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                                  ])
                                ],
                              ),
                              pw.SizedBox(height: 4),
                              pw.Row(
                                children: [
                                  pw.Text('Material: ',
                                      style: pw.TextStyle(
                                        fontSize: 10,
                                      )),
                                  pw.Text('${peca?.material ?? ''}',
                                      style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                                ],
                              ),
                              pw.SizedBox(height: 4),
                              pw.Row(
                                children: [
                                  pw.Text('Comprimento: ',
                                      style: pw.TextStyle(
                                        fontSize: 10,
                                      )),
                                  pw.Text('${peca?.profundidade ?? ''}',
                                      style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                                  pw.SizedBox(width: 10),
                                  pw.Text('Altura: ',
                                      style: pw.TextStyle(
                                        fontSize: 10,
                                      )),
                                  pw.Text('${peca?.altura ?? ''}',
                                      style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                                  pw.SizedBox(width: 10),
                                ],
                              ),
                              pw.SizedBox(height: 4),
                              //.
                              pw.Row(children: [
                                pw.Text('Largura: ',
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                    )),
                                pw.Text('${peca?.largura ?? ''}',
                                    style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                                pw.SizedBox(width: 10),
                                pw.Text('Und. Medida: ',
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                    )),
                                pw.Text(' ${validaUnidadeMedia(peca?.unidade_medida)}',
                                    style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                              ]),
                              pw.SizedBox(height: 4),

                              /* pw.SizedBox(height: 4),
                            pw.Row(children: [
                              pw.Text('Und. Medida: ',
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                  )),
                              pw.Text(' ${peca?.material ?? ''}',
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold))
                            ]) */
                            ],
                          ))),
                  pw.Column(
                    children: [
                      pw.BarcodeWidget(
                        barcode: Barcode.qrCode(),
                        data: peca!.id_peca.toString(),
                        width: 80,
                        height: 80,
                      ),
                    ],
                  )
                ]),
                pw.Expanded(
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                      pw.Text('Gerado por: ',
                          style: pw.TextStyle(
                            fontSize: 8,
                          )),
                      pw.Text(' ${getUsuario().nome ?? ''} - ${getUsuario().uid ?? ''}',
                          style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic))
                    ]))

                /* pw.SizedBox(height: 8), */
                /* pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            pw.Text('Codigo.............:'),
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Text('Descricao......:'),
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Text('Estante........:'),
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Text('Prateleira.....:'),
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Text('Box..............:'),
                          ],
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            pw.Padding(padding: pw.EdgeInsets.only(right: 5)),
                            pw.Text(
                                '${pecaEstoque?.endereco?.split('-')[0].trim() ?? ''}',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Padding(padding: pw.EdgeInsets.only(right: 5)),
                            pw.Text(
                                '${pecaEstoque?.endereco?.split('-')[1].trim() ?? ''}',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Padding(padding: pw.EdgeInsets.only(right: 5)),
                            pw.Text(
                                '${pecaEstoque?.endereco?.split('-')[2].trim() ?? ''}',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Padding(padding: pw.EdgeInsets.only(right: 5)),
                            pw.Text(
                                '${pecaEstoque?.endereco?.split('-')[3].trim() ?? ''}',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                        pw.Row(
                          children: [
                            pw.Padding(padding: pw.EdgeInsets.only(right: 5)),
                            pw.Text(
                                '${pecaEstoque?.endereco?.split('-')[4].trim() ?? ''}',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    pw.Padding(padding: pw.EdgeInsets.only(right: 20)),
                    pw.Column(
                      children: [
                        pw.BarcodeWidget(
                          barcode: Barcode.qrCode(),
                          data: 'uau',
                          width: 80,
                          height: 80,
                        ),
                      ],
                    ),
                  ],
                ),
                pw.Row(
                  children: [
                    pw.Text('Emissão: ', style: pw.TextStyle(fontSize: 8)),
                    pw.Text(
                        '${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                        style: pw.TextStyle(
                            fontSize: 8, fontWeight: pw.FontWeight.bold)),
                  ],
                ), */
              ],
            ),
          );
        },
      ),
    );

    return await doc.save();
  }
}
