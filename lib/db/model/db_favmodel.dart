import 'package:hive/hive.dart';
part 'db_favmodel.g.dart';
@HiveType(typeId: 2)
class Favmodel {
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
 
 Favmodel ({
    required this.songid,
    required this.uri,
    required this.name,
    required this.artist,
    required this.path,
    
    });
}