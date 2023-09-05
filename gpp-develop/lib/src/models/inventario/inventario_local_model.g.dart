// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventario_local_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InventarioLocalModelAdapter extends TypeAdapter<InventarioLocalModel> {
  @override
  final int typeId = 2;

  @override
  InventarioLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InventarioLocalModel(
      idInventario: fields[0] as int,
      pecas: (fields[1] as List).cast<InventarioLocalPecaModel>(),
      evento: fields[2] as InventarioLocalEventoModel,
    );
  }

  @override
  void write(BinaryWriter writer, InventarioLocalModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.idInventario)
      ..writeByte(1)
      ..write(obj.pecas)
      ..writeByte(2)
      ..write(obj.evento);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventarioLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
