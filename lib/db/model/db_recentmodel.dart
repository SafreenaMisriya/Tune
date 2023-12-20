import 'package:hive/hive.dart';
part 'db_recentmodel.g.dart';

@HiveType(typeId: 4)
class Recentmodel extends HiveObject {
  @HiveField(0)
  int songid;
  
  Recentmodel({required this.songid,});
}