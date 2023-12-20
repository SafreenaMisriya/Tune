import 'package:hive/hive.dart';
 part 'db_playlistmodel.g.dart';

@HiveType(typeId: 3)
class Listmodel extends HiveObject{
   @HiveField(0)
   String  name;
   @HiveField(1)
   List<int >songid;
   
  Listmodel({required this.songid,required this.name});
}


