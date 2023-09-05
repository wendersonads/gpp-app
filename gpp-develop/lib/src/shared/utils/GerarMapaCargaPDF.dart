import 'dart:typed_data';

import 'package:gpp/src/models/mapa_carga_model.dart';
import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';


class GerarMapaCargaPDF {
  static MaskFormatter maskFormatter = MaskFormatter();
  NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

  static Future<void> imprimirPDF(MapaCargaModel mapaCarga) async {
    Printing.layoutPdf(
      // [onLayout] Será chamado várias vezes
      // Quando o usuário altera a impressora ou as configurações da impressora
      onLayout: (PdfPageFormat format) {
        // Qualquer documento PDF válido pode ser retornado aqui como uma lista de int
        return buildPdf(format, mapaCarga);
      },
    );
  }

  static Future<Uint8List> buildPdf(
      PdfPageFormat format, MapaCargaModel mapaCarga) async {
    // Cria o documento PDF
    final pw.Document doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape.copyWith(
            marginLeft: 20, marginRight: 20, marginBottom: 20, marginTop: 20),
        build: (pw.Context context) {
          return pw.Container(
            child: pw.Column(
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      flex: 4,
                      child: pw.Container(
                        height: 80,
                        padding: pw.EdgeInsets.all(10.0),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Conhecimento de Transporte Rodoviario de Cargas',
                              style: pw.TextStyle(
                                  fontSize: 12, fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Padding(padding: pw.EdgeInsets.only(bottom: 10)),
                            pw.Text(
                              'GPP - Novomundo.com',
                              style: pw.TextStyle(
                                  fontSize: 24, fontWeight: pw.FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.Padding(padding: pw.EdgeInsets.only(right: 5)),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Container(
                        height: 80,
                        padding: pw.EdgeInsets.all(10.0),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Text('Número do Mapa: '),
                                pw.Text('${mapaCarga.idMapaCarga ?? ''}',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ],
                            ),
                            pw.Padding(padding: pw.EdgeInsets.only(top: 2)),
                            pw.Divider(
                              height: 1,
                            ),
                            pw.Padding(padding: pw.EdgeInsets.only(top: 2)),
                            pw.Row(
                              children: [
                                pw.Text(
                                    'Emissão: ${DateFormat('dd/MM/yyyy').format(mapaCarga.dataEmissao ?? DateTime.now())}'),
                              ],
                            ),
                            pw.Padding(padding: pw.EdgeInsets.only(top: 2)),
                            pw.Divider(
                              height: 1,
                            ),
                            pw.Padding(padding: pw.EdgeInsets.only(top: 2)),
                            pw.Row(
                              children: [
                                pw.Text(
                                    'Saída: ${'         /         /           '}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                pw.Padding(padding: pw.EdgeInsets.only(top: 5)),
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 4,
                      child: pw.Container(
                        height: 130,
                        padding: pw.EdgeInsets.all(10.0),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Remetente: ${mapaCarga.filialOrigem?.clienteFilial?.cliente?.nome ?? ''}',
                              style: pw.TextStyle(fontSize: 12),
                            ),
                            pw.Text(
                              'Filial: ${mapaCarga.filialOrigem?.id_filial ?? ''}',
                              style: pw.TextStyle(fontSize: 12),
                            ),
                            pw.Text(
                              'Endereço: ${mapaCarga.filialOrigem?.clienteFilial?.cliente?.end_cliente?.logradouro ?? ''}',
                              style: pw.TextStyle(fontSize: 12),
                            ),
                            pw.Text(
                              'Bairro: ${mapaCarga.filialOrigem?.clienteFilial?.cliente?.end_cliente?.bairro ?? ''}',
                              style: pw.TextStyle(fontSize: 12),
                            ),
                            pw.Text(
                              'Cidade: ${mapaCarga.filialOrigem?.clienteFilial?.cliente?.end_cliente?.localidade ?? ''}',
                              style: pw.TextStyle(fontSize: 12),
                            ),
                            pw.Text(
                              'CNPJ: ${maskFormatter.cnpjFormatter(value: mapaCarga.filialOrigem?.clienteFilial?.cliente?.cpfCnpj ?? '').getMaskedText()}',
                              style: pw.TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.Padding(padding: pw.EdgeInsets.only(right: 5)),
                    pw.Expanded(
                      flex: 4,
                      child: pw.Container(
                        height: 130,
                        padding: pw.EdgeInsets.all(10.0),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: mapaCarga.tipoEntrega == 1
                            ? pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.Text('Cliente',
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 16)),
                                ],
                              )
                            : pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    'Destinatário: ${mapaCarga.filialDestino?.clienteFilial?.cliente?.nome ?? ''}',
                                    style: pw.TextStyle(fontSize: 12),
                                  ),
                                  pw.Text(
                                    'Filial: ${mapaCarga.filialDestino?.id_filial ?? ''}',
                                    style: pw.TextStyle(fontSize: 12),
                                  ),
                                  pw.Text(
                                    'Endereço: ${mapaCarga.filialDestino?.clienteFilial?.cliente?.end_cliente?.logradouro ?? ''}',
                                    style: pw.TextStyle(fontSize: 12),
                                  ),
                                  pw.Text(
                                    'Bairro: ${mapaCarga.filialDestino?.clienteFilial?.cliente?.end_cliente?.bairro ?? ''}',
                                    style: pw.TextStyle(fontSize: 12),
                                  ),
                                  pw.Text(
                                    'Cidade: ${mapaCarga.filialDestino?.clienteFilial?.cliente?.end_cliente?.localidade ?? ''}',
                                    style: pw.TextStyle(fontSize: 12),
                                  ),
                                  pw.Text(
                                    'CNPJ: ${maskFormatter.cnpjFormatter(value: mapaCarga.filialDestino?.clienteFilial?.cliente?.cpfCnpj ?? '').getMaskedText()}',
                                    style: pw.TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
                pw.Padding(padding: pw.EdgeInsets.only(top: 5)),
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 4,
                      child: pw.Container(
                        height: 140,
                        padding: pw.EdgeInsets.all(10.0),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Text(
                                      'Quantidade: ',
                                      style: pw.TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 4,
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Text(
                                      '${mapaCarga.volume ?? ''}',
                                      style: pw.TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Text(
                                      'Espécie: ',
                                      style: pw.TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 4,
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Text(
                                      '${mapaCarga.especieVolume ?? ''}',
                                      style: pw.TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Text(
                                      'Empresa: ',
                                      style: pw.TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 4,
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Text(
                                      '${mapaCarga.transportadora?.contato ?? ''}',
                                      style: pw.TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Text(
                                      'CPF/CNPJ: ',
                                      style: pw.TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 4,
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Text(
                                      '${maskFormatter.cnpjFormatter(value: mapaCarga.transportadora?.clienteTransp?.cliente?.cpfCnpj ?? '').getMaskedText()}',
                                      style: pw.TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Text(
                                      'Placa: ',
                                      style: pw.TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 4,
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Text(
                                      '${mapaCarga.caminhao?.placa ?? ''} | ${mapaCarga.caminhao?.sigla_uf ?? ''}',
                                      style: pw.TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            pw.Row(
                              children: [
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Text(
                                      'Motorista: ',
                                      style: pw.TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 4,
                                  child: pw.Container(
                                    padding: pw.EdgeInsets.all(5),
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(),
                                    ),
                                    child: pw.Text(
                                      '${'Glaucio de Lima'}',
                                      style: pw.TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.Padding(padding: pw.EdgeInsets.only(right: 5)),
                    pw.Expanded(
                      flex: 4,
                      child: pw.Container(
                        height: 140,
                        padding: pw.EdgeInsets.all(10.0),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text(
                                  'Documentos',
                                  style: pw.TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            pw.Wrap(
                              direction: pw.Axis.horizontal,
                              children: [
                                pw.ListView.builder(
                                  direction: pw.Axis.horizontal,
                                  itemCount:
                                      mapaCarga.itemMapaCarga?.length ?? 1,
                                  itemBuilder: (context, index) {
                                    return pw.Row(
                                      children: [
                                        pw.Text(
                                          '${'${mapaCarga.itemMapaCarga?[index].pedidoSaida?.idPedidoSaida ?? ''}(${mapaCarga.itemMapaCarga?[index].pedidoSaida?.asteca?.idAsteca ?? ''})'}',
                                          style: pw.TextStyle(
                                              fontSize: 12,
                                              fontWeight: pw.FontWeight.bold),
                                        ),
                                        pw.Padding(
                                            padding:
                                                pw.EdgeInsets.only(right: 10)),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                pw.Padding(padding: pw.EdgeInsets.only(top: 5)),
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 4,
                      child: pw.Container(
                        height: 120,
                        padding: pw.EdgeInsets.all(10.0),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Text(
                                '--------------------------------------------'),
                            pw.Text('Responsável'),
                            pw.Padding(padding: pw.EdgeInsets.only(top: 10)),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.Text('(___) Motorista'),
                                pw.Padding(
                                    padding: pw.EdgeInsets.only(right: 20)),
                                pw.Text('(___) Ajudante'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.Padding(padding: pw.EdgeInsets.only(right: 5)),
                    pw.Expanded(
                      flex: 4,
                      child: pw.Container(
                        height: 120,
                        padding: pw.EdgeInsets.all(10.0),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(
                                'Conferimos e recebemos em perfeitas condições todas as mercadorias acima especificas'),
                            pw.Padding(padding: pw.EdgeInsets.only(top: 10)),
                            pw.Text('____/____/______',
                                style: pw.TextStyle(fontSize: 10)),
                            pw.Padding(padding: pw.EdgeInsets.only(top: 20)),
                            pw.Text(
                                '--------------------------------------------'),
                            pw.Text('Carimbo e Assinatura'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // pw.Padding(padding: pw.EdgeInsets.only(top: 20)),
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Container(
                        padding: pw.EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Row(
                          children: [
                            pw.Text('Versão: v001'),
                            pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                            pw.Text(
                                'Data/Hora: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    // Build and return the final Pdf file data
    return await doc.save();
  }
}
