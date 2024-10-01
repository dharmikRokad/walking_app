// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walk_step_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalkStepModelAdapter extends TypeAdapter<WalkStepModel> {
  @override
  final int typeId = 2;

  @override
  WalkStepModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalkStepModel(
      coordinates: (fields[0] as List).cast<double>(),
      heading: fields[1] as double,
      timeStamp: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WalkStepModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.coordinates)
      ..writeByte(1)
      ..write(obj.heading)
      ..writeByte(2)
      ..write(obj.timeStamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalkStepModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
