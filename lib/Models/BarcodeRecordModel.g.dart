// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BarcodeRecordModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BarcodeRecordModelAdapter extends TypeAdapter<BarcodeRecordModel> {
  @override
  final int typeId = 0;

  @override
  BarcodeRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BarcodeRecordModel(
      event: fields[0] as EventModel?,
      competitor: fields[1] as EventModel?,
      actualTime: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BarcodeRecordModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.event)
      ..writeByte(1)
      ..write(obj.competitor)
      ..writeByte(2)
      ..write(obj.actualTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarcodeRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
