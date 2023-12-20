// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_favmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavmodelAdapter extends TypeAdapter<Favmodel> {
  @override
  final int typeId = 2;

  @override
  Favmodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Favmodel(
      songid: fields[0] as int,
      uri: fields[1] as String,
      name: fields[2] as String,
      artist: fields[3] as String,
      path: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Favmodel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.songid)
      ..writeByte(1)
      ..write(obj.uri)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.artist)
      ..writeByte(4)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavmodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
