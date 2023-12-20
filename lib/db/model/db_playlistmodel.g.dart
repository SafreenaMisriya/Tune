// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_playlistmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListmodelAdapter extends TypeAdapter<Listmodel> {
  @override
  final int typeId = 3;

  @override
  Listmodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Listmodel(
      songid: (fields[1] as List).cast<int>(),
      name: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Listmodel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.songid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListmodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
