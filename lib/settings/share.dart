

import 'dart:io';

import 'package:share/share.dart';
import 'package:tune/db/model/db_model.dart';

void sharemusic(MusicSong sh) async {
  final vh = sh;
  final file = File(vh.path);
  await Share.shareFiles([vh.path]);
}
