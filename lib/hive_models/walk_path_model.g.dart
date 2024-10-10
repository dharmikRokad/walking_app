// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walk_path_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalkPathModelAdapter extends TypeAdapter<WalkPathModel> {
  @override
  final int typeId = 1;

  @override
  WalkPathModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalkPathModel(
      steps: (fields[0] as List).cast<WalkStepModel>(),
      stepDistance: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, WalkPathModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.steps)
      ..writeByte(1)
      ..write(obj.stepDistance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalkPathModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
