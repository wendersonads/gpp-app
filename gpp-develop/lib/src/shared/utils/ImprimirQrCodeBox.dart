import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';

import 'package:gpp/src/models/box_enderecamento_model.dart';
import 'package:gpp/src/models/pecas_model/pecas_estoque_model.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class ImprimirQrCodeBox {
  String? idBox;
  PecasEstoqueModel? pecaEstoque;
  BoxEnderecamentoModel? boxEnderecamento;

  ImprimirQrCodeBox({
    this.idBox,
    this.pecaEstoque,
    this.boxEnderecamento,
  });

  Future<void> imprimirQrCode() async {
    final Uint8List? pdfBytes;
    final String? filename;

    if (pecaEstoque != null) {
      filename =
          'etiqueta_${pecaEstoque!.id_box}_${pecaEstoque!.id_peca_estoque}.pdf';
      pdfBytes = await buildPdfEstoque();
    } else {
      if (boxEnderecamento != null && boxEnderecamento!.pecaEstoque != null) {
        filename =
            'etiqueta_${boxEnderecamento?.id_box}_${boxEnderecamento?.pecaEstoque?.id_peca_estoque}.pdf';
      } else {
        filename = 'etiqueta.pdf';
      }

      pdfBytes = await buildPdfBox();
    }

    Printing.sharePdf(
      filename: filename,
      bytes: pdfBytes,
    );
  }

  // coment aqui
  Future<Uint8List> buildPdfBox() async {
    final pw.Document doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: pw.EdgeInsets.only(left: 35, right: 0, bottom: 0, top: 2),
        orientation: pw.PageOrientation.landscape,
        build: (pw.Context context) {
          return pw.Container(
            height: 135,
            width: 255,
            constraints: pw.BoxConstraints(maxWidth: 340),
            padding: pw.EdgeInsets.all(10.0),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Text('Piso.............:'),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Text('Corredor......:'),
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
                                pw.Padding(
                                    padding: pw.EdgeInsets.only(right: 5)),
                                pw.Text(
                                    '${boxEnderecamento?.endereco?.split('-')[0].trim() ?? ''}',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Padding(
                                    padding: pw.EdgeInsets.only(right: 5)),
                                pw.Text(
                                    '${boxEnderecamento?.endereco?.split('-')[1].trim() ?? ''}',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Padding(
                                    padding: pw.EdgeInsets.only(right: 5)),
                                pw.Text(
                                    '${boxEnderecamento?.endereco?.split('-')[2].trim() ?? ''}',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Padding(
                                    padding: pw.EdgeInsets.only(right: 5)),
                                pw.Text(
                                    '${boxEnderecamento?.endereco?.split('-')[3].trim() ?? ''}',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Padding(
                                    padding: pw.EdgeInsets.only(right: 5)),
                                pw.Text(
                                    '${boxEnderecamento?.endereco?.split('-')[4].trim() ?? ''}',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    pw.Padding(padding: pw.EdgeInsets.only(right: 20)),
                    pw.Column(
                      children: [
                        pw.BarcodeWidget(
                          barcode: Barcode.qrCode(),
                          data: boxEnderecamento!.id_box.toString(),
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
                ),
              ],
            ),
          );
        },
      ),
    );

    return await doc.save();
  }

  Future<Uint8List> buildPdfEstoque() async {
    final pw.Document doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: pw.EdgeInsets.only(left: 35, right: 0, bottom: 0, top: 2),
        orientation: pw.PageOrientation.landscape,
        build: (pw.Context context) {
          return pw.Container(
            height: 135,
            width: 255,
            constraints: pw.BoxConstraints(maxWidth: 340),
            padding: pw.EdgeInsets.all(10.0),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Row(
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Text('Piso.............:'),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Text('Corredor......:'),
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
                                pw.Padding(
                                    padding: pw.EdgeInsets.only(right: 5)),
                                pw.Text(
                                    '${pecaEstoque?.endereco?.split('-')[0].trim() ?? ''}',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Padding(
                                    padding: pw.EdgeInsets.only(right: 5)),
                                pw.Text(
                                    '${pecaEstoque?.endereco?.split('-')[1].trim() ?? ''}',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Padding(
                                    padding: pw.EdgeInsets.only(right: 5)),
                                pw.Text(
                                    '${pecaEstoque?.endereco?.split('-')[2].trim() ?? ''}',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Padding(
                                    padding: pw.EdgeInsets.only(right: 5)),
                                pw.Text(
                                    '${pecaEstoque?.endereco?.split('-')[3].trim() ?? ''}',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Padding(
                                    padding: pw.EdgeInsets.only(right: 5)),
                                pw.Text(
                                    '${pecaEstoque?.endereco?.split('-')[4].trim() ?? ''}',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.Padding(padding: pw.EdgeInsets.only(right: 20)),
                    pw.Column(
                      children: [
                        pw.BarcodeWidget(
                          barcode: Barcode.qrCode(),
                          data: pecaEstoque!.box!.id_box.toString(),
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
                ),
              ],
            ),
          );
        },
      ),
    );

    return await doc.save();
  }
}
