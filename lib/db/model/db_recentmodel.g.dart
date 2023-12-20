// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_recentmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentmodelAdapter extends TypeAdapter<Recentmodel> {
  @override
  final int typeId = 4;

  @override
  Recentmodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recentmodel(
      songid: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Recentmodel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.songid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentmodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
