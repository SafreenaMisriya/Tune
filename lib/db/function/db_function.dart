import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tune/db/model/db_favmodel.dart';
import 'package:tune/db/model/db_model.dart';
import 'package:tune/db/model/db_playlistmodel.dart';
import 'package:tune/db/model/db_recentmodel.dart';

Future<void> addSong({required List<SongModel> s}) async {
  final songDB = await Hive.openBox<MusicSong>('Song_db');
  if (songDB.isEmpty) {
    for (SongModel song in s) {
      songDB.add(MusicSong(
        songid: song.id,
        uri: song.uri.toString(),
        name: song.title.toString(),
        artist: song.artist.toString(),
        path: song.data,
      ));
    }
    music();
  } else {
    for (SongModel song in s) {
      if (!songDB.values.any((element) => element.songid == song.id.toInt())) {
        songDB.add(MusicSong(
          songid: song.id,
          uri: song.uri.toString(),
          name: song.title.toString(),
          artist: song.artist.toString(),
          path: song.data,
         
        ));
      }
    }
    music();
  }
}
Future<List<MusicSong>> music() async {
  List<MusicSong> songs = [];
  final songDB = await Hive.openBox<MusicSong>('Song_db');
  for (int i = 0; i < songDB.length; i++) {
    MusicSong a = songDB.get(i)!;
    songs.add(a);
    
  }
  return songs;
}
Future<void> addFavSong({required List<Favmodel> favsongs}) async {
  final favsongDB = await Hive.openBox<Favmodel>('fav_song_db');
  if (favsongDB.isEmpty) {
    for (Favmodel favsong in favsongs) {
      favsongDB.add(favsong);
    }
  } else {
  
    for (Favmodel favsong in favsongs) {
      if (!favsongDB.values
          .any((element) => element.songid == favsong.songid)) {
        favsongDB.add(favsong);
      }
    }
  }
}
Future<void> removeFromFavourite(int songid) async {
  final favsongs = await favMusic();
  final issonginfavourite = favsongs.any((favsong) => favsong.songid == songid);
  if (issonginfavourite) {
    final updatefavourite =
        favsongs.where((favsong) => favsong.songid != songid).toList();
    await Hive.box<Favmodel>('fav_song_db').clear();
    await addFavSong(favsongs: updatefavourite);
  }
}
Future<List<Favmodel>> favMusic() async {
  List<Favmodel> songs = [];
  final favsongDB = await Hive.openBox<Favmodel>('fav_song_db');
  for (int i = 0; i < favsongDB.length; i++) {
    Favmodel a = favsongDB.get(i)!;
    songs.add(a);
   
  }
  debugPrint("${favsongDB.length}");
  return songs;
}
addtoplaylist({required String name, required List<int> songid}) async {
  final playlistDB = await Hive.openBox<Listmodel>('list_db');
  playlistDB.add(Listmodel(songid: songid, name: name));
}

Future<List<Listmodel>> getfromplaylist() async {
  List<Listmodel> pldb = [];
  final playlistDB = await Hive.openBox<Listmodel>('list_db');
  pldb = playlistDB.values.toList();
  return pldb;
}
deletePlayList(int index) async {
  final playListDb = await Hive.openBox<Listmodel>('list_db');
  if (index >= 0 && index < playListDb.length) {
    playListDb.deleteAt(index);
  } else {
    debugPrint("Invalid index for playlist deletion");
  }
}
renameplaylist({required Listmodel playlist, required String newname}) async {
  final playListDb = await Hive.openBox<Listmodel>('list_db');
  final storedplaylist = playListDb.get(playlist.key);
  if (storedplaylist != null) {
    storedplaylist.name = newname;
    playListDb.put(playlist.key, storedplaylist);
  }
}
addSongsToPlaylist({required int songid, required Listmodel playlist}) async {
  final playListDb = await Hive.openBox<Listmodel>('list_db');
  final pl = playListDb.get(playlist.key);
  pl!.songid.add(songid);
  playListDb.put(playlist.key, pl);
 
}
List<int> plyids = [];
checkSongOnPlaylist({required Listmodel playlist}) async {
  final playListDb = await Hive.openBox<Listmodel>('list_db');
  final pl = playListDb.get(playlist.key);
  plyids = pl!.songid; 
}
removeSongsFromPlaylist(
  {required int songid, required Listmodel playlist}) async {
  final playListDb = await Hive.openBox<Listmodel>('list_db');
  final pl = playListDb.get(playlist.key);
  pl!.songid.remove(songid);
  playListDb.put(playlist.key, pl);
}
Future<List<MusicSong>> playlistSongs({required Listmodel playslist}) async {
  final playListDb = await Hive.openBox<Listmodel>('list_db');
  final s = playListDb.get(playslist.key);
  List<int> plSongs = s!.songid;
  List<MusicSong> allSongs = await music();
  List<MusicSong> result = [];
  for (int i = 0; i < allSongs.length; i++) {
    for (int j = 0; j < plSongs.length; j++) {
      if (allSongs[i].songid == plSongs[j]) {
        result.add(MusicSong(
            name: allSongs[i].name,
            songid: allSongs[i].songid,
            uri: allSongs[i].uri,
            path: allSongs[i].path,
            artist: allSongs[i].artist));
      }
    }
  }
  return result;
}
void addSongToRecentlyPlayed(int songId) async {
  final recentlyPlayedBox = await Hive.openBox<Recentmodel>('recent_db');
  List<Recentmodel> songs = recentlyPlayedBox.values.toList();
  for (int i = 0; i < songs.length; i++) {
    if (songs[i].songid == songId) {
      recentlyPlayedBox.delete(songs[i].key);
      break;
    }
  }
  recentlyPlayedBox.add(Recentmodel(songid: songId));
 
}
Future<List<MusicSong>> recentlyPlayedSongs() async {
  final recentlyPlayedBox = await Hive.openBox<Recentmodel>('recent_db');
  List<Recentmodel> songs = recentlyPlayedBox.values.toList();
  List<MusicSong> allSongs = await music();
  List<MusicSong> recents = [];
  for (int i = 0; i < songs.length; i++) {
    for (int j = 0; j < allSongs.length; j++) {
      if (songs[i].songid == allSongs[j].songid) {
        recents.add(allSongs[j]);
      }
    }
  }
  return recents.reversed.toList();
}