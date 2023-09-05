// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventario_local_evento_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InventarioLocalEventoModelAdapter
    extends TypeAdapter<InventarioLocalEventoModel> {
  @override
  final int typeId = 3;

  @override
  InventarioLocalEventoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InventarioLocalEventoModel(
      idInventarioEvento: fields[0] as int,
      idEventoStatus: fields[1] as int,
      dataEvento: fields[2] as String,
      descricao: fields[3] as String,
      mensagemPadrao: fields[4] as String,
      statusCor: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, InventarioLocalEventoModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.idInventarioEvento)
      ..writeByte(1)
      ..write(obj.idEventoStatus)
      ..writeByte(2)
      ..write(obj.dataEvento)
      ..writeByte(3)
      ..write(obj.descricao)
      ..writeByte(4)
      ..write(obj.mensagemPadrao)
      ..writeByte(5)
      ..write(obj.statusCor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventarioLocalEventoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
