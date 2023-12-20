import 'package:hive/hive.dart';
part 'db_model.g.dart';
@HiveType(typeId: 1)
class MusicSong {
  @HiveField(0)
  int songid;
  @HiveField(1)
  String uri;
  @HiveField(2)
  String  name;
  @HiveField(3)
  String artist;
  @HiveField(4)
  String path;
  
  MusicSong({
    required this.songid,
    required this.uri,
    required this.name,
    required this.artist,
    required this.path,
   
    });
}