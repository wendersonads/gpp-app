import 'dart:typed_data';

import 'package:gpp/src/models/pedido_entrada_model.dart';
import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class GerarPedidoEntradaPDF {
  PedidoEntradaModel pedidoEntrada;
  MaskFormatter maskFormatter = MaskFormatter();
  NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

  GerarPedidoEntradaPDF({
    required this.pedidoEntrada,
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
    // Create the Pdf document
    final pw.Document doc = pw.Document();

    // Add one page with centered text "Hello World"
    doc.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Container(
              child: pw.Column(children: [
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Text('GPP', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text('Novomundo.com', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold))
            ]),
            pw.SizedBox(height: 12),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Text('Dados do pedido', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            ]),
            pw.Divider(),
            pw.SizedBox(height: 8),
            pw.Row(
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Nº do pedido: ${pedidoEntrada.idPedidoEntrada}',
                        style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                        'Nome do fornecedor: ${pedidoEntrada.itensPedidoEntrada?.first.peca?.produtoPeca?.first.produto?.fornecedores?.first.cliente?.nome.toString() ?? ''}',
                        style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 12),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Itens do pedido', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.Divider(),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: pw.Row(children: [
                pw.Expanded(child: pw.Center(child: pw.Text('ID'))),
                pw.Expanded(child: pw.Center(child: pw.Text('Descrição'))),
                pw.Expanded(child: pw.Center(child: pw.Text('Quantidade'))),
                pw.Expanded(child: pw.Center(child: pw.Text('Valor R\$'))),
                pw.Expanded(child: pw.Center(child: pw.Text('Subtotal R\$'))),
              ]),
            ),
            pw.Divider(),
            pw.Expanded(
                child: pw.ListView.builder(
              itemCount: pedidoEntrada.itensPedidoEntrada!.length,
              itemBuilder: (context, index) {
                return pw.Container(
                  color: (index % 2) == 0 ? PdfColor(1, 1, 1) : PdfColor(0.95, 0.95, 0.95),
                  child: pw.Padding(
                    padding: pw.EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                    child: pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Center(
                            child: pw.Text(
                              pedidoEntrada.itensPedidoEntrada?[index].peca?.id_peca.toString() ?? '',
                            ),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Center(
                            child: pw.Text(pedidoEntrada.itensPedidoEntrada?[index].peca?.descricao ?? ''),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Center(
                            child: pw.Text(
                              pedidoEntrada.itensPedidoEntrada?[index].quantidade.toString() ?? '',
                            ),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Center(
                            child: pw.Text(
                              formatter.format(pedidoEntrada.itensPedidoEntrada?[index].custo ?? ''),
                            ),
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Center(
                            child: pw.Text(
                              formatter.format(
                                (pedidoEntrada.itensPedidoEntrada![index].quantidade! *
                                    pedidoEntrada.itensPedidoEntrada![index].custo!),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Text('Total de itens: ${pedidoEntrada.itensPedidoEntrada!.length.toString()}'),
              pw.Text('Total R\$: ${formatter.format((pedidoEntrada.valorTotal))}'),
            ]),
          ]));
        },
      ),
    );

    // Build and return the final Pdf file data
    return await doc.save();
  }
}
