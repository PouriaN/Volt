// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BarcodeDataModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BarcodeDataModelAdapter extends TypeAdapter<BarcodeDataModel> {
  @override
  final int typeId = 0;

  @override
  BarcodeDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BarcodeDataModel(
      competitorId: fields[0] as int?,
      eventId: fields[1] as int?,
      userId: fields[2] as int?,
      date: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BarcodeDataModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.competitorId)
      ..writeByte(1)
      ..write(obj.eventId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarcodeDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
