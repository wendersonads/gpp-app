import 'dart:typed_data';

import 'package:gpp/src/models/mapa_carga_model.dart';
import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';


class GerarRomaneioPDF {
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
      pw.MultiPage(
        orientation: pw.PageOrientation.portrait,
        pageFormat: PdfPageFormat.a4.copyWith(marginLeft: 20, marginRight: 20),
        // header: (pw.Context context) {
        //   return pw.Column(
        //     children: [
        //       pw.Text(
        //         'GPP - Novomundo.com',
        //         style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        //       ),
        //     ],
        //   );
        // },
        footer: (pw.Context context) {
          return pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('GPP - Novomundo.com', style: pw.TextStyle(fontSize: 10)),
              pw.Text('Página ${context.pageNumber}/${context.pagesCount}',
                  style: pw.TextStyle(fontSize: 10)),
            ],
          );
        },
        build: (pw.Context context) {
          return [
            pw.Container(
              child: pw.Column(
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text('ROMANEIO DE CARGA',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  pw.Padding(padding: pw.EdgeInsets.only(top: 10)),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Número da carga: ${mapaCarga.idMapaCarga ?? ''}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                          'Emissão: ${DateFormat('dd/MM/yyyy HH:mm').format(mapaCarga.dataEmissao ?? DateTime.now())}'),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                          'Responsável: ${mapaCarga.funcionario?.idFuncionario ?? ''} - ${mapaCarga.funcionario?.clienteFunc?.cliente?.nome ?? ''}'),
                      pw.Text('Data Saída: ${'       /       /           '}'),
                    ],
                  ),
                  pw.Padding(padding: pw.EdgeInsets.only(top: 10)),
                  pw.Column(
                    // mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Text('Remetente: ',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Text(
                                  'Nome/Razão Social: ${mapaCarga.filialOrigem?.clienteFilial?.cliente?.nome ?? ''}'),
                            ],
                          ),
                          pw.Row(
                            children: [
                              pw.Text(
                                  'Endereço: ${mapaCarga.filialOrigem?.clienteFilial?.cliente?.end_cliente?.logradouro ?? ''}'),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                  'Cidade: ${mapaCarga.filialOrigem?.clienteFilial?.cliente?.end_cliente?.localidade ?? ''}'),
                              pw.Text(
                                  'Bairro: ${mapaCarga.filialOrigem?.clienteFilial?.cliente?.end_cliente?.bairro ?? ''}'),
                              pw.Text(
                                  'Cep: ${mapaCarga.filialOrigem?.clienteFilial?.cliente?.end_cliente?.cep ?? ''}'),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Text(
                                  'Filial: ${mapaCarga.filialOrigem?.id_filial ?? ''}'),
                            ],
                          ),
                        ],
                      ),
                      pw.Padding(padding: pw.EdgeInsets.only(top: 5)),
                      mapaCarga.tipoEntrega == 1
                          ? pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Text('Destinatário: Cliente',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ],
                            )
                          : pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.Text('Destinatário: ',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold)),
                                  ],
                                ),
                                pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                        'Nome/Razão Social: ${mapaCarga.filialDestino?.clienteFilial?.cliente?.nome ?? ''}'),
                                  ],
                                ),
                                pw.Row(
                                  children: [
                                    pw.Text(
                                        'Endereço: ${mapaCarga.filialDestino?.clienteFilial?.cliente?.end_cliente?.logradouro ?? ''}'),
                                  ],
                                ),
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text(
                                        'Cidade: ${mapaCarga.filialDestino?.clienteFilial?.cliente?.end_cliente?.localidade ?? ''}'),
                                    pw.Text(
                                        'Bairro: ${mapaCarga.filialDestino?.clienteFilial?.cliente?.end_cliente?.bairro ?? ''}'),
                                    pw.Text(
                                        'Cep: ${mapaCarga.filialDestino?.clienteFilial?.cliente?.end_cliente?.cep ?? ''}'),
                                  ],
                                ),
                                pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                        'Filial: ${mapaCarga.filialDestino?.id_filial ?? ''}'),
                                  ],
                                ),
                              ],
                            ),
                      pw.Padding(padding: pw.EdgeInsets.only(top: 5)),
                      pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Text('Transportador: ',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Text(
                                  'Empresa: ${mapaCarga.transportadora?.contato ?? ''}'),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                  'CPF/CNPJ: ${maskFormatter.cnpjFormatter(value: mapaCarga.transportadora?.clienteTransp?.cliente?.cpfCnpj ?? '').getMaskedText()}'),
                              pw.Text(
                                  'Especie: ${mapaCarga.especieVolume ?? ''}'),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                  'Placa: ${mapaCarga.caminhao?.placa ?? ''}/${mapaCarga.caminhao?.sigla_uf ?? ''}'),
                              pw.Text('Volume(s): ${mapaCarga.volume ?? ''}'),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Text(
                                  'Motorista: ${mapaCarga.motorista?.funcMotorista?.funcionario?.clienteFunc?.cliente?.nome ?? ''}'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.ListView.builder(
              itemCount: mapaCarga.itemMapaCarga?.length ?? 1,
              itemBuilder: (context, index) {
                return pw.Column(
                  children: [
                    pw.Divider(),
                    pw.Row(
                      children: [
                        pw.Text(
                            'Nº Saída: ${mapaCarga.itemMapaCarga?[index].pedidoSaida?.idPedidoSaida ?? ''}',
                            style: pw.TextStyle(fontSize: 10)),
                        pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                        pw.Text(
                            'Emissão: ${DateFormat('dd/MM/yyyy HH:mm').format(mapaCarga.itemMapaCarga?[index].pedidoSaida?.dataEmissao ?? DateTime.now())}',
                            style: pw.TextStyle(fontSize: 10)),
                        pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                        pw.Text(
                            'Nº Entrada: ${mapaCarga.itemMapaCarga?[index].pedidoSaida?.asteca?.pedidoEntrada?.idPedidoEntrada ?? ''}',
                            style: pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                    pw.Padding(padding: pw.EdgeInsets.only(top: 5)),
                    pw.Row(
                      children: [
                        pw.Text(
                            'Nº Asteca: ${mapaCarga.itemMapaCarga?[index].pedidoSaida?.asteca?.idAsteca ?? ''}',
                            style: pw.TextStyle(fontSize: 10)),
                        pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                        pw.Text(
                            'Cliente: ${mapaCarga.itemMapaCarga?[index].pedidoSaida?.cliente?.nome ?? ''}',
                            style: pw.TextStyle(fontSize: 10)),
                        pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                        pw.Text(
                            'NF: ${mapaCarga.itemMapaCarga?[index].pedidoSaida?.numDocFiscal ?? ''}-${mapaCarga.itemMapaCarga?[index].pedidoSaida?.serieDocFiscal ?? ''}',
                            style: pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                    pw.Padding(padding: pw.EdgeInsets.only(top: 5)),
                    pw.Row(
                      children: [
                        pw.Expanded(
                            flex: 1,
                            child: pw.Text('ID For',
                                style: pw.TextStyle(fontSize: 8))),
                        pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                        pw.Expanded(
                            flex: 1,
                            child: pw.Text('Fornecedor',
                                style: pw.TextStyle(fontSize: 8))),
                        pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                        pw.Expanded(
                            flex: 1,
                            child: pw.Text('ID Peça',
                                style: pw.TextStyle(fontSize: 8))),
                        pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                        pw.Expanded(
                            flex: 1,
                            child: pw.Text('Número',
                                style: pw.TextStyle(fontSize: 8))),
                        pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                        pw.Expanded(
                            flex: 2,
                            child: pw.Text('Descrição',
                                style: pw.TextStyle(fontSize: 8))),
                        pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                        pw.Expanded(
                            flex: 1,
                            child: pw.Text('Quantidade',
                                style: pw.TextStyle(fontSize: 8))),
                      ],
                    ),
                    pw.ListView.builder(
                      itemCount: mapaCarga.itemMapaCarga?[index].pedidoSaida
                              ?.itemsPedidoSaida?.length ??
                          1,
                      itemBuilder: (context, index2) {
                        return pw.Row(
                          children: [
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(
                                    '${mapaCarga.itemMapaCarga?[index].pedidoSaida?.asteca?.compEstProd?.first.produto?.codFornecedor?.id_fornecedor ?? ''}',
                                    style: pw.TextStyle(fontSize: 8))),
                            pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(
                                    '${mapaCarga.itemMapaCarga?[index].pedidoSaida?.asteca?.compEstProd?.first.produto?.codFornecedor?.denominacao ?? ''}',
                                    style: pw.TextStyle(fontSize: 8))),
                            pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(
                                    '${mapaCarga.itemMapaCarga?[index].pedidoSaida?.itemsPedidoSaida?[index2].peca?.id_peca ?? ''}',
                                    style: pw.TextStyle(fontSize: 8))),
                            pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(
                                    '${mapaCarga.itemMapaCarga?[index].pedidoSaida?.itemsPedidoSaida?[index2].peca?.numero ?? ''}',
                                    style: pw.TextStyle(fontSize: 8))),
                            pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                            pw.Expanded(
                                flex: 2,
                                child: pw.Text(
                                    '${mapaCarga.itemMapaCarga?[index].pedidoSaida?.itemsPedidoSaida?[index2].peca?.descricao ?? ''}',
                                    style: pw.TextStyle(fontSize: 8))),
                            pw.Padding(padding: pw.EdgeInsets.only(right: 10)),
                            pw.Expanded(
                                flex: 1,
                                child: pw.Text(
                                    '${mapaCarga.itemMapaCarga?[index].pedidoSaida?.itemsPedidoSaida?[index2].quantidade ?? ''}',
                                    style: pw.TextStyle(fontSize: 8))),
                          ],
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ];
        },
      ),
    );

    // Build and return the final Pdf file data
    return await doc.save();
  }
}
