import 'dart:typed_data';

import 'package:gpp/src/shared/utils/MaskFormatter.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

import 'package:gpp/src/models/pedido_saida_model.dart';

class GerarPedidoSaidaPDF {
  PedidoSaidaModel pedido;
  MaskFormatter maskFormatter = MaskFormatter();
  NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

  GerarPedidoSaidaPDF({
    required this.pedido,
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
    const double FONTEBASE = 8;

    // Add one page with Flexibleed text "Hello World"
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape.copyWith(marginLeft: 20, marginRight: 20, marginBottom: 20, marginTop: 20),
        build: (pw.Context context) {
          return [
            pw.Container(
                child: pw.Column(children: [
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('GPP', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.Text('novomundo.com', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold))
              ]),
              pw.SizedBox(height: 12),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('Dados do pedido', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
              ]),
              pw.Divider(),
              pw.SizedBox(height: 8),
              pw.Column(children: [
                pw.Row(children: [
                  pw.Expanded(
                      child: pw.Container(
                          padding: pw.EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                          decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromHex('#000'))),
                          child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  ' Empresa: ${pedido.asteca?.documentoFiscal?.clienteFilial?.cliente?.nome ?? ''}',
                                  style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                    ' Endereço: ${pedido.asteca?.documentoFiscal?.clienteFilial?.cliente?.end_cliente?.logradouro ?? ''}',
                                    style: pw.TextStyle(
                                      fontSize: 12,
                                    )),
                                pw.Text(
                                    ' Bairro: ${pedido.asteca?.documentoFiscal?.clienteFilial?.cliente?.end_cliente?.bairro ?? ''}',
                                    style: pw.TextStyle(fontSize: 12),
                                    maxLines: 1),
                                pw.Text(
                                    ' Cidade: ${pedido.asteca?.documentoFiscal?.clienteFilial?.cliente?.end_cliente?.localidade ?? ''}' +
                                        ' UF: ${pedido.asteca?.documentoFiscal?.clienteFilial?.cliente?.end_cliente?.sigla_uf ?? ''}' +
                                        ' CEP: ${pedido.asteca?.documentoFiscal?.clienteFilial?.cliente?.end_cliente?.cep ?? ''}',
                                    style: pw.TextStyle(
                                      fontSize: 12,
                                    )),
                                pw.Text(' Email: ${pedido.asteca?.documentoFiscal?.clienteFilial?.cliente?.email ?? ''} ',
                                    style: pw.TextStyle(fontSize: 12))
                              ]))),
                  pw.Row(children: [
                    pw.Column(children: [
                      pw.Container(
                        padding: pw.EdgeInsets.symmetric(horizontal: 2, vertical: 11),
                        decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromHex('#000'))),
                        child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(' Tipo Movimento ', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                              pw.Container(
                                  padding: pw.EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                                  child: pw.Row(children: [pw.Text(' 1-SAÍDA', style: pw.TextStyle(fontSize: 12))])),
                            ]),
                      ),
                    ]),
                  ]),
                  pw.Row(children: [
                    pw.Column(children: [
                      pw.Container(
                        padding: pw.EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                        decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromHex('#000'))),
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Text(' Número Ordem de Saída ', style: pw.TextStyle(fontSize: 12)),
                              pw.Container(
                                  padding: pw.EdgeInsets.symmetric(vertical: 2, horizontal: 66),
                                  child: pw.Row(children: [
                                    pw.Text(pedido.idPedidoSaida.toString(),
                                        style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold))
                                  ])),
                              pw.Container(
                                  padding: pw.EdgeInsets.symmetric(horizontal: 38),
                                  child: pw.Row(children: [pw.Text('Data emissão', style: pw.TextStyle(fontSize: 12))])),
                              pw.Container(
                                  padding: pw.EdgeInsets.symmetric(horizontal: 42),
                                  child: pw.Row(children: [
                                    pw.Text(DateFormat('dd/MM/yyyy').format(DateTime.now()),
                                        style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold))
                                  ])),
                            ]),
                      )
                    ])
                  ]),
                ]),
                /* pw.Row(children: [
                pw.Expanded(
                    child: pw.Container(
                        decoration: pw.BoxDecoration(border: pw.Border.all()),
                        child: pw.Column(children: [
                          pw.Text('Natureza da Operação'),
                          pw.Text('ATENDER VENDA')
                        ]))),
                pw.Expanded(
                    child: pw.Container(
                        decoration: pw.BoxDecoration(border: pw.Border.all()),
                        child: pw.Column(children: [
                          pw.Text('Operador'),
                          pw.Text('${getUsuario().nome}')
                        ]))),
                pw.Expanded(
                    child: pw.Container(
                        decoration: pw.BoxDecoration(border: pw.Border.all()),
                        child: pw.Column(children: [
                          pw.Text('Protocolo Interno'),
                          pw.Text('ATENDER VENDA')
                        ])))
              ]), */
                pedido.itemMapaCarga != null
                    ? pw.Column(children: [
                        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                          pw.Container(
                              padding: pw.EdgeInsets.symmetric(vertical: 6, horizontal: 0), child: pw.Text('DESTINATÁRIO'))
                        ]),
                        pw.Row(children: [
                          pw.Expanded(
                              flex: 3,
                              child: pw.Container(
                                  padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                                  child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                                    pw.Text('Nome / Razão Social'),
                                    pw.Text('${pedido.asteca?.documentoFiscal?.clienteFilial?.cliente?.nome ?? ''}',
                                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                                  ]))),
                          pw.Expanded(
                              child: pw.Container(
                                  padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                                  child: pw.Column(
                                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                                      children: [pw.Text('Filial Estoque'), pw.Text('${pedido.filial_registro ?? ''}')]))),
                          pw.Expanded(
                              child: pw.Container(
                                  padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                                  child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                                    pw.Text('Regional'),
                                    pw.Text(
                                        '${pedido.itemMapaCarga?.mapaCarga?.filialOrigem?.clienteFilial?.filialRegional?.idRegional.toString() ?? ''}')
                                  ]))),
                          pw.Expanded(
                              child: pw.Container(
                                  padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                                  child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                                    pw.Text('Filial Venda'),
                                    pw.Text(
                                        '${pedido.itemMapaCarga?.mapaCarga?.filialOrigem?.id_filial ?? ''} - ${pedido.asteca?.documentoFiscal?.clienteFilial?.cliente?.end_cliente?.localidade ?? ''}')
                                  ]))),
                          pw.Expanded(
                              child: pw.Container(
                                  padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                                  child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                                    pw.Text('Data Saída'),
                                    pw.Text(
                                        '${pedido.itemMapaCarga?.mapaCarga?.dataEmissao != null ? DateFormat('dd/MM/yyyy').format(pedido.itemMapaCarga!.mapaCarga!.dataEmissao!) : ''}')
                                  ])))
/*                             ${pedido.itemMapaCarga?.mapaCarga?.dataEmissao != null ? DateFormat('dd/MM/yyyy').format(pedido.itemMapaCarga.mapaCarga!.dataEmissao!.toString()) : ''}
 */
                        ])
                      ])
                    : pw.SizedBox.shrink(),
                /* 
              pw.Row(children: [
                pw.Container(
                  height: 55,
                  decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColor.fromHex('#000'))),
                  child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Nº do pedido: ${pedido.idPedidoSaida}',
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Nome do cliente: ${pedido.cliente!.nome}',
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Filial de venda: ${pedido.filial_registro}',
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      ]),
                )
              ]) */
                pw.SizedBox(height: 8),
                pw.Row(children: [
                  pw.Expanded(
                      flex: 6,
                      child: pw.Container(
                          padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          decoration: pw.BoxDecoration(border: pw.Border.all()),
                          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                            pw.Text('CLIENTE'),
                            pw.Text('${pedido.cliente?.nome.toString() ?? ''}',
                                style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                          ]))),
                  pw.Expanded(
                      flex: 3,
                      child: pw.Container(
                          padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          decoration: pw.BoxDecoration(border: pw.Border.all()),
                          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                            pw.Text('FS - NF - SR'),
                            pw.Text(
                                '${pedido.asteca?.documentoFiscal?.idFilialSaida ?? ''} - ${pedido.numDocFiscal.toString()} - ${pedido.serieDocFiscal.toString()}')
                          ]))),
                  pw.Expanded(
                      flex: 2,
                      child: pw.Container(
                          padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          decoration: pw.BoxDecoration(border: pw.Border.all()),
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [pw.Text('Nº Asteca'), pw.Text('${pedido.asteca?.idAsteca.toString() ?? ''}')]))),
                  pw.Expanded(
                      flex: 2,
                      child: pw.Container(
                          padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          decoration: pw.BoxDecoration(border: pw.Border.all()),
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [pw.Text('Nº Pedido'), pw.Text('${'-'}')]))),
                  pw.Expanded(
                      flex: 2,
                      child: pw.Container(
                          padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          decoration: pw.BoxDecoration(border: pw.Border.all()),
                          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                            pw.Text('Horário Saída'),
                            pw.Text('${pedido.dataEmissao != null ? DateFormat('HH:mm:ss').format(pedido.dataEmissao!) : ''}')
                          ])))
                ]),
                pw.Row(children: [
                  pw.Expanded(
                      flex: 8,
                      child: pw.Container(
                          padding: pw.EdgeInsets.symmetric(vertical: 10.9, horizontal: 4),
                          decoration: pw.BoxDecoration(border: pw.Border.all()),
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [pw.Text('Endereço - ${pedido.asteca?.astecaEndCliente?.logradouro ?? ''}', maxLines: 1)]))),
                  pw.Expanded(
                      flex: 5,
                      child: pw.Container(
                          padding: pw.EdgeInsets.symmetric(vertical: 10.9, horizontal: 4),
                          decoration: pw.BoxDecoration(border: pw.Border.all()),
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [pw.Text('Bairro - ${pedido.asteca?.astecaEndCliente?.bairro ?? ''}', maxLines: 1)]))),
                  pw.Expanded(
                      flex: 4,
                      child: pw.Container(
                          padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          decoration: pw.BoxDecoration(border: pw.Border.all()),
                          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                            pw.Text('Cidade'),
                            pw.Text('${pedido.asteca?.astecaEndCliente?.localidade.toString() ?? '-'}')
                          ]))),
                  pw.Expanded(
                      flex: 1,
                      child: pw.Container(
                          padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          decoration: pw.BoxDecoration(border: pw.Border.all()),
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [pw.Text('UF'), pw.Text('${pedido.asteca?.astecaEndCliente?.uf ?? '-'}')])))
                ])
              ]),
              pw.SizedBox(height: 12),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('Itens do pedido',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    )),
              ]),
              pw.Divider(),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: pw.Container(
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: pw.Row(children: [
                      pw.Expanded(
                          flex: 3,
                          child: pw.Container(
                              /* alignment: pw.Alignment(0, 0), */
                              padding: pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                              decoration: pw.BoxDecoration(border: pw.Border.all()),
                              child:
                                  pw.Flexible(child: pw.Text('Produto Referência', style: pw.TextStyle(fontSize: FONTEBASE))))),
                      pw.Expanded(
                          child: pw.Container(
                              padding: pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                              decoration: pw.BoxDecoration(border: pw.Border.all()),
                              child: pw.Flexible(child: pw.Text('Código', style: pw.TextStyle(fontSize: FONTEBASE))))),
                      pw.Expanded(
                          child: pw.Container(
                              padding: pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                              decoration: pw.BoxDecoration(border: pw.Border.all()),
                              child: pw.Flexible(child: pw.Text('Número', style: pw.TextStyle(fontSize: FONTEBASE))))),
                      pw.Expanded(
                          child: pw.Container(
                              padding: pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                              decoration: pw.BoxDecoration(border: pw.Border.all()),
                              child: pw.Flexible(child: pw.Text('Cód. Fabrica', style: pw.TextStyle(fontSize: FONTEBASE))))),
                      pw.Expanded(
                          flex: 3,
                          child: pw.Container(
                              padding: pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                              decoration: pw.BoxDecoration(
                                  border: pw.Border(
                                      top: pw.BorderSide(color: PdfColors.black),
                                      bottom: pw.BorderSide(color: PdfColors.black),
                                      left: pw.BorderSide(color: PdfColors.black),
                                      right: pw.BorderSide.none)),
                              child: pw.Flexible(child: pw.Text('Descrição', style: pw.TextStyle(fontSize: FONTEBASE))))),
                      pw.SizedBox(width: 8),
                      pw.Expanded(
                          child: pw.Container(
                              padding: pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                              decoration: pw.BoxDecoration(border: pw.Border.all()),
                              child: pw.Flexible(child: pw.Text('Qtde', style: pw.TextStyle(fontSize: FONTEBASE))))),
                      pw.Expanded(
                          child: pw.Container(
                              padding: pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                              decoration: pw.BoxDecoration(border: pw.Border.all()),
                              child: pw.Flexible(child: pw.Text('Valor R\$', style: pw.TextStyle(fontSize: FONTEBASE))))),
                      pw.Expanded(
                          child: pw.Container(
                              padding: pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                              decoration: pw.BoxDecoration(border: pw.Border.all()),
                              child: pw.Flexible(child: pw.Text('Endereço', style: pw.TextStyle(fontSize: FONTEBASE))))),
                    ])),
              ),
              pw.Wrap(children: [
                pw.ListView.builder(
                  itemCount: pedido.itemsPedidoSaida!.length,
                  itemBuilder: (context, index) {
                    return pw.Container(
                      color: (index % 2) == 0 ? PdfColor(1, 1, 1) : PdfColor(0.95, 0.95, 0.95),
                      child: pw.Padding(
                        padding: pw.EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                        child: pw.Container(
                            decoration: pw.BoxDecoration(border: pw.Border.all()),
                            child: pw.Row(
                              children: [
                                pw.Expanded(
                                    flex: 3,
                                    child: pw.Container(
                                        /* decoration: pw.BoxDecoration(
                                        border: pw.Border.all()), */
                                        padding: pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                        child: pw.Flexible(
                                            child: pw.Row(children: [
                                          pw.Flexible(
                                              child: pw.Text(
                                                  '${pedido.asteca?.compEstProd?.first.produto?.idProduto.toString() ?? ''}' +
                                                      ' - ' +
                                                      '${pedido.asteca?.compEstProd?.first.produto?.resumida.toString() ?? ''}',
                                                  style: pw.TextStyle(fontSize: FONTEBASE),
                                                  maxLines: 1)),
                                          /* pw.SizedBox(width: 5),
                                      pw.Container(
                                          child: pw.Flexible(
                                              child: pw.Text(
                                        pedido.asteca?.compEstProd?.first
                                                .produto?.resumida
                                                .toString() ??
                                            '',
                                        style:
                                            pw.TextStyle(fontSize: FONTEBASE),
                                      ))) */
                                        ])))),
                                pw.Expanded(
                                    child: pw.Container(
                                        padding: pw.EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                                        decoration: pw.BoxDecoration(
                                            border: pw.Border(
                                                top: pw.BorderSide.none,
                                                bottom: pw.BorderSide.none,
                                                left: pw.BorderSide(color: PdfColors.black),
                                                right: pw.BorderSide(color: PdfColors.black))),
                                        child: pw.Flexible(
                                            child: pw.Text(pedido.itemsPedidoSaida?[index].peca?.id_peca.toString() ?? '',
                                                style: pw.TextStyle(fontSize: FONTEBASE))))),
                                pw.Expanded(
                                    child: pw.Container(
                                        padding: pw.EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                                        decoration: pw.BoxDecoration(
                                            border: pw.Border(
                                                top: pw.BorderSide.none,
                                                bottom: pw.BorderSide.none,
                                                left: pw.BorderSide(color: PdfColors.black),
                                                right: pw.BorderSide(color: PdfColors.black))),
                                        child: pw.Flexible(
                                            child: pw.Text(pedido.itemsPedidoSaida?[index].peca?.numero.toString() ?? '',
                                                style: pw.TextStyle(fontSize: FONTEBASE))))),
                                pw.Expanded(
                                    child: pw.Container(
                                        padding: pw.EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                                        decoration: pw.BoxDecoration(
                                            border: pw.Border(
                                                top: pw.BorderSide.none,
                                                bottom: pw.BorderSide.none,
                                                left: pw.BorderSide(color: PdfColors.black),
                                                right: pw.BorderSide(color: PdfColors.black))),
                                        child: pw.Flexible(
                                            child: pw.Text(pedido.itemsPedidoSaida?[index].peca?.codigo_fabrica ?? '-',
                                                style: pw.TextStyle(fontSize: FONTEBASE))))),
                                pw.Expanded(
                                    flex: 3,
                                    child: pw.Container(
                                        padding: pw.EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                        child: pw.Flexible(
                                            child: pw.Text(pedido.itemsPedidoSaida?[index].peca?.descricao.toString() ?? '',
                                                style: pw.TextStyle(fontSize: FONTEBASE))))),
                                pw.SizedBox(width: 8),
                                pw.Expanded(
                                    child: pw.Container(
                                        padding: pw.EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                                        decoration: pw.BoxDecoration(
                                            border: pw.Border(
                                                top: pw.BorderSide.none,
                                                bottom: pw.BorderSide.none,
                                                left: pw.BorderSide(color: PdfColors.black),
                                                right: pw.BorderSide(color: PdfColors.black))),
                                        child: pw.Flexible(
                                            child: pw.Text(pedido.itemsPedidoSaida?[index].quantidade.toString() ?? '',
                                                style: pw.TextStyle(fontSize: FONTEBASE))))),
                                pw.Expanded(
                                    child: pw.Container(
                                        padding: pw.EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                                        decoration: pw.BoxDecoration(
                                            border: pw.Border(
                                                top: pw.BorderSide.none,
                                                bottom: pw.BorderSide.none,
                                                left: pw.BorderSide(color: PdfColors.black),
                                                right: pw.BorderSide(color: PdfColors.black))),
                                        child: pw.Flexible(
                                            child: pw.Text(formatter.format(pedido.itemsPedidoSaida?[index].valor ?? ''),
                                                style: pw.TextStyle(fontSize: FONTEBASE))))),
                                pw.Expanded(
                                    child: pw.Container(
                                        padding: pw.EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                                        decoration: pw.BoxDecoration(
                                            border: pw.Border(
                                                top: pw.BorderSide.none,
                                                bottom: pw.BorderSide.none,
                                                left: pw.BorderSide(color: PdfColors.black),
                                                right: pw.BorderSide(color: PdfColors.black))),
                                        child: pw.Flexible(
                                            child: pw.Text(pedido.itemsPedidoSaida?[index].pecaEstoque?.endereco ?? '',
                                                style: pw.TextStyle(fontSize: FONTEBASE))))),
                              ],
                            )),
                      ),
                    );
                  },
                )
              ]),
              pw.SizedBox(height: 6),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [pw.Text('OBS: ${pedido.asteca?.observacao.toString() ?? ''}')]),
              pw.Container(
                padding: pw.EdgeInsets.symmetric(vertical: 8),
                child: pw.Divider(borderStyle: pw.BorderStyle.dotted),
              ),
              pw.Row(children: [
                pw.Expanded(
                    flex: 4,
                    child: pw.Container(
                      padding: pw.EdgeInsets.fromLTRB(10, 4, 10, 0),
                      height: 70,
                      decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromHex('#000'))),
                      child: pw.Column(children: [
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Text(' RECEBEMOS O(S) ITEN(S) CONSTANTE(S) NESTA ORDEM DE SAÍDA INDICADO ACIMA'),
                              pw.SizedBox(height: 32),
                              pw.Container(
                                  padding: pw.EdgeInsets.fromLTRB(10, 4, 10, 0),
                                  decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.black)))),
                            ]),
                        pw.Column(children: [
                          pw.Container(padding: pw.EdgeInsets.symmetric(vertical: 1), child: pw.Text('Assinatura e Carimbo'))
                        ])
                      ]),
                    )),
                pw.Expanded(
                    child: pw.Container(
                        padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                        height: 70,
                        decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromHex('#000'))),
                        child: pw.Column(children: [pw.Text(' DATA E HORA ')]))),
                pw.Expanded(
                    child: pw.Container(
                        padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                        height: 70,
                        decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColor.fromHex('#000'))),
                        child: pw.Column(children: [
                          pw.Text('ORDEM DE SAÍDA'),
                          pw.SizedBox(
                            height: 17,
                          ),
                          pw.Text(pedido.idPedidoSaida.toString(),
                              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                        ])))
              ]),
              /* pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                      'Total de itens: ${pedido.itemsPedidoSaida!.length.toString()}'),
                  pw.Text(
                      'Total R\$: ${formatter.format((pedido.valorTotal))}'),
                ]), */
            ]))
          ];
        },
      ),
    );

    // Build and return the final Pdf file data
    return await doc.save();
  }
}
