// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventario_local_peca_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InventarioLocalPecaModelAdapter
    extends TypeAdapter<InventarioLocalPecaModel> {
  @override
  final int typeId = 1;

  @override
  InventarioLocalPecaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InventarioLocalPecaModel(
      idInventario: fields[0] as int,
      idPeca: fields[1] as int,
      idInventarioPeca: fields[2] as int,
      descricaoPeca: fields[3] as String,
      endereco: fields[4] as String,
      quantidadeDisponivel: fields[5] as int,
      quantidadeReservada: fields[6] as int,
      quantidadeContada: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, InventarioLocalPecaModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.idInventario)
      ..writeByte(1)
      ..write(obj.idPeca)
      ..writeByte(2)
      ..write(obj.idInventarioPeca)
      ..writeByte(3)
      ..write(obj.descricaoPeca)
      ..writeByte(4)
      ..write(obj.endereco)
      ..writeByte(5)
      ..write(obj.quantidadeDisponivel)
      ..writeByte(6)
      ..write(obj.quantidadeReservada)
      ..writeByte(7)
      ..write(obj.quantidadeContada);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventarioLocalPecaModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
