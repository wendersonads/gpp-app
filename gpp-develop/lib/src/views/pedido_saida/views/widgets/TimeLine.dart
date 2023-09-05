// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gpp/src/enums/pedido_saida_status_enum.dart';
import 'package:gpp/src/models/pedido_saida_evento_model.dart';
import 'package:timelines/timelines.dart';
import 'package:get/get.dart';

// const kTileHeight = 50.0;

const inProgressColor = Color(0xff5e6172);
const completeColor = Color(0xff5ec792);
const todoColor = Color(0xffd1d2d7);
const cancelColor = Colors.red;

class ProcessTimelinePage extends StatefulWidget {
  List<PedidoSaidaEventoModel>? evento;
  ProcessTimelinePage({Key? key, this.evento}) : super(key: key);
  @override
  _ProcessTimelinePageState createState() => _ProcessTimelinePageState();
}

class _ProcessTimelinePageState extends State<ProcessTimelinePage> {
  late List<PedidoSaidaEventoModel> eventos = [];
  int _processIndex = 0;

  @override
  void initState() {
    eventos = widget.evento!;
    if (eventos.last.eventoStatus!.id_evento_status == PedidoSaidaStatusEnum.CONCLUIDO ||
        eventos.last.eventoStatus!.id_evento_status == PedidoSaidaStatusEnum.CANCELADO) {
      _processIndex = eventos.length;
    } else {
      _processIndex = eventos.length - 1;
    }

    super.initState();
  }

  Color getColor(int index) {
    if (index == _processIndex) {
      return inProgressColor;
    } else if (index < _processIndex) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: 200,
        width: context.width,
        child: Timeline.tileBuilder(
          theme: TimelineThemeData(
            direction: Axis.horizontal,
            connectorTheme: ConnectorThemeData(
              //space: 30.0,
              thickness: 5.0,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemExtentBuilder: (_, __) => Get.width <= 1190
                ? Get.width * 0.5
                : Get.width <= 1500
                    ? (Get.width / (eventos.length + 2.0))
                    : (Get.width / (eventos.length <= 5 ? 8 : eventos.length + 1.5)),
            oppositeContentsBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: icones(eventos[index].eventoStatus!.id_evento_status!), //_icons[index],
              );
            },
            contentsBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  "${eventos[index].eventoStatus!.descricao!.toString()} \n ${eventos[index].dataEvento.toString().split(' ').first.replaceAll('-', '/')} \n ${eventos[index].dataEvento.toString().split(' ').last.substring(0, 5)}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: eventos[index].eventoStatus!.id_evento_status == PedidoSaidaStatusEnum.CANCELADO
                        ? cancelColor
                        : getColor(index),
                  ),
                ),
              );
            },
            indicatorBuilder: (_, index) {
              var color;
              var child;
              if (index == _processIndex) {
                color = inProgressColor;
                child = Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                );
              } else if (index < _processIndex) {
                color = eventos[index].eventoStatus!.id_evento_status == PedidoSaidaStatusEnum.CANCELADO
                    ? cancelColor
                    : completeColor;
                child = Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 15.0,
                );
              } else {
                color = todoColor;
              }

              if (index <= _processIndex) {
                return Stack(
                  children: [
                    CustomPaint(
                      size: Size(30.0, 30.0),
                      painter: _BezierPainter(
                        color: eventos[index].eventoStatus!.id_evento_status == PedidoSaidaStatusEnum.CANCELADO
                            ? cancelColor
                            : color,
                        drawStart: index > 0,
                        drawEnd: index == (eventos.length - 2) && eventos.last.idEventoStatus == PedidoSaidaStatusEnum.CANCELADO
                            ? false
                            : ((eventos[index].eventoStatus!.id_evento_status != PedidoSaidaStatusEnum.CONCLUIDO
                                    ? true
                                    : false) &&
                                (eventos[index].eventoStatus!.id_evento_status != PedidoSaidaStatusEnum.CANCELADO
                                    ? true
                                    : false)),
                      ),
                    ),
                    DotIndicator(
                      size: 30.0,
                      color: color,
                      child: child,
                    ),
                  ],
                );
              } else {
                return Stack(
                  children: [
                    CustomPaint(
                      size: Size(15.0, 15.0),
                      painter: _BezierPainter(
                        color: color,
                        drawEnd: index < eventos.length - 1,
                      ),
                    ),
                    OutlinedDotIndicator(
                      borderWidth: 4.0,
                      color: color,
                    ),
                  ],
                );
              }
            },
            connectorBuilder: (_, index, type) {
              if (index > 0) {
                if (index == _processIndex) {
                  final prevColor = getColor(index - 1);
                  final color = getColor(index);
                  List<Color> gradientColors;
                  if (type == ConnectorType.start) {
                    gradientColors = [Color.lerp(prevColor, color, 0.5)!, color];
                  } else {
                    gradientColors = [prevColor, Color.lerp(prevColor, color, 0.5)!];
                  }
                  return DecoratedLineConnector(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                      ),
                    ),
                  );
                } else {
                  return SolidLineConnector(
                    color: eventos[index].eventoStatus!.id_evento_status == PedidoSaidaStatusEnum.CANCELADO
                        ? cancelColor
                        : getColor(index),
                  );
                }
              } else {
                return null;
              }
            },
            itemCount: eventos.length,
          ),
        ),
      ),
    );
  }
}

/// hardcoded bezier painter
class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    required this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    var angle;
    var offset1;
    var offset2;

    var path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius, radius)
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(size.width, size.height / 2, size.width + radius, radius) //
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.drawStart != drawStart || oldDelegate.drawEnd != drawEnd;
  }
}

// final _processes = [
//   'Em aberto',
//   'Aguardando separação',
//   'Em Separação',
//   'Separado',
//   'Concluído',
// ];

icones(int idEvento) {
  switch (idEvento) {
    case PedidoSaidaStatusEnum.EM_ABERTO:
      return Icon(
        Icons.start,
        size: 35.0,
        color: Color(0xff5e6172),
      );

    case PedidoSaidaStatusEnum.AGUARDANDO_FORNECEDOR:
      return Icon(
        Icons.schedule_sharp,
        size: 35.0,
        color: Color(0xff5e6172),
      );

    case PedidoSaidaStatusEnum.AGUARDANDO_SEPARACAO:
      return Icon(
        Icons.hourglass_empty,
        size: 35.0,
        color: Color(0xff5e6172),
      );

    case PedidoSaidaStatusEnum.EM_SEPARACAO:
      return Icon(
        Icons.pending_actions,
        size: 35.0,
        color: Color(0xff5e6172),
      );

    case PedidoSaidaStatusEnum.SEPARADO:
      return Icon(
        Icons.inventory_outlined,
        size: 35.0,
        color: Color(0xff5e6172),
      );

    case PedidoSaidaStatusEnum.CANCELADO:
      return Icon(
        Icons.cancel,
        size: 35.0,
        color: Colors.red,
      );

    case PedidoSaidaStatusEnum.CONCLUIDO:
      return Icon(
        Icons.check_circle_outline_outlined,
        size: 35.0,
        color: Color(0xff5e6172),
      );

    case PedidoSaidaStatusEnum.EM_TRANSITO:
      return Icon(
        Icons.local_shipping,
        color: Color(0xff5e6172),
        size: 35.0,
      );

    default:
      return Icon(Icons.abc);
  }
}
