
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:tune/Povider/image_provider.dart';
import 'package:tune/db/function/db_function.dart';
import 'package:tune/db/model/db_favmodel.dart';
import 'package:tune/db/model/db_model.dart';
import 'package:tune/reuse_code/bottom.dart';
import 'package:tune/reuse_code/color.dart';
import 'package:tune/screens/home_screen.dart';
import 'package:tune/screens/lyric_screen.dart';
import 'package:tune/settings/share.dart';


// ignore: must_be_immutable
class PlayScreen extends StatefulWidget {
  PlayScreen({
    Key? key,
    this.songModel,
    
    required this.index,
    // ignore: non_constant_identifier_names
    this.FavSongModel,
  }) : super(key: key);

  final List<MusicSong>? songModel;


  
  int index;
  // ignore: non_constant_identifier_names
  List<Favmodel>? FavSongModel;

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool _isPlaying = true;
  bool _isLooping = false;
  bool _isShuffling = false;
  bool islike = false;

  @override
  void initState() {
    super.initState();
    checkIsFavorite();
    playSong();
    audioPlayers.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        // Song finished, play the next one
        _playNext();
        context.read<songModelProvider>().setId(widget.FavSongModel != null
            ? widget.FavSongModel![widget.index].songid
            : widget.songModel![widget.index].songid);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: Container(
          decoration: BoxDecoration(
            gradient: bgTheme2(),
          ),
          child: Column(
            children: [
               SizedBox(  height: MediaQuery.of(context).size.height * .05,
                  ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                   SizedBox(width: MediaQuery.of(context).size.width * 0.5,),
                  IconButton(
                    onPressed: () {
                        sharemusic(widget.songModel![widget.index]);
                    },
                    icon: const Icon(
                      Icons.share,
                      size: 30,
                    ),
                    color: Colors.white,
                  )
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(49),
                    ),
                    child: const ArtWorkWidget(),
                  ),
                ),
              ),
             Padding(
               padding: const EdgeInsets.only(left: 290),
               child: IconButton(onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>LyricsPage(
                  songName: widget.songModel![widget.index].name,
                  artistName: widget.songModel![widget.index].artist,
    
                )));
               }, icon: const Icon(Icons.arrow_forward_ios_rounded,size: 30,color: Colors.white,)),
             ),
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Center(
                      child: Text(
                          widget.FavSongModel != null
                              ? widget.FavSongModel![widget.index].name
                              : widget.songModel![widget.index].name,
                               overflow:TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 17)),
                    ),
                  ),
                  SizedBox(  height: MediaQuery.of(context).size.height * .04,),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.5,
                    child: Center(
                      child: Text(
                          widget.FavSongModel != null
                              ? widget.FavSongModel![widget.index].artist.toString()
                              : widget.songModel![widget.index].artist.toString() ==
                                      "<unknown>"
                                  ? "<unknown>"
                                  : widget.FavSongModel != null
                                      ? widget.FavSongModel![widget.index].artist.toString() 
                                      : widget.songModel![widget.index].artist.toString(),
                                           overflow:TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 15)),
                    ),
                  ),
                ],
              ),
              SizedBox(  height: MediaQuery.of(context).size.height * 0.03, ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: toggleFavorite,
                      icon: Icon(
                        islike ? Icons.favorite : Icons.favorite_border_outlined,
                        color: Colors.white,
                        size: 25,
                      )),
                  IconButton(
                      onPressed: () {   
                        
                       bottomplaylistsheet(context: context,
                         songId:   widget.FavSongModel != null
                              ? widget.FavSongModel![widget.index].songid
                              : widget.songModel![widget.index].songid);
                        
                      },
                      icon: const Icon(
                        Icons.playlist_add,
                        color: Colors.white,
                        size: 25,
                      )
                      ),
                ],
              ),
               SizedBox(  height: MediaQuery.of(context).size.height * .01,),
              Slider(
                min: const Duration(microseconds: 0).inSeconds.toDouble(),
                value: _position.inSeconds.toDouble(),
                max: _duration.inSeconds.toDouble(),
                onChanged: (value) {
                  ChangeToSeconds(value.toInt());
                },
                activeColor: Colors.white,
                inactiveColor: Colors.black,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(_position.toString().split(".")[0],
                      style: const TextStyle(color: Colors.white)),
                  SizedBox(  width: MediaQuery.of(context).size.width * 0.7,
                  ),
                  Text(_duration.toString().split(".")[0],
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
               SizedBox(  height: MediaQuery.of(context).size.height * .03,
                  ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isShuffling = !_isShuffling; 
                      });
                    },
                    icon: Icon(Icons.shuffle_sharp,
                        size: 30,
                        color: _isShuffling ?const Color.fromARGB(255, 153, 81, 215) : Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      _playPrevious();
                      playSong();
                      context.read<songModelProvider>().setId(
                          widget.FavSongModel != null
                              ? widget.FavSongModel![widget.index].songid
                              : widget.songModel![widget.index].songid);
                    },
                    icon: const Icon(Icons.skip_previous_sharp,
                        size: 45, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_isPlaying) {
                          audioPlayers.pause();
                        } else {
                          audioPlayers.play();
                        }
                        _isPlaying = !_isPlaying;
                      });
                    },
                    icon: Icon(
                        _isPlaying
                            ? Icons.pause_circle_outlined
                            : Icons.play_circle_outline,
                        size: 45,
                        color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _playNext();
                        playSong();
                        context.read<songModelProvider>().setId(
                            widget.FavSongModel != null
                                ? widget.FavSongModel![widget.index].songid
                                : widget.songModel![widget.index].songid);
                      });
                    },
                    icon: const Icon(Icons.skip_next_sharp,
                        size: 45, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isLooping = !_isLooping;
                        audioPlayers.setLoopMode(
                            _isLooping ? LoopMode.one : LoopMode.off);
                      });
                    },
                    icon: Icon(
                      Icons.loop_outlined,
                      size: 30,
                      color: _isLooping ? const Color.fromARGB(255, 153, 81, 215): Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
    );
    
  }

  // ignore: non_constant_identifier_names
  void ChangeToSeconds(seconds) {
    Duration duration = Duration(seconds: seconds);
   audioPlayers.seek(duration);
  }

void _playNext() {
  if (_isShuffling) {
    List<MusicSong> shuffledSongs;
    if (widget.FavSongModel != null) {
      shuffledSongs = List.from(widget.FavSongModel!);
      shuffledSongs.shuffle();
    } else {
      shuffledSongs = List.from(widget.songModel!);
      shuffledSongs.shuffle();
    }

    int currentIndex = shuffledSongs.indexWhere((song) =>
        song.songid ==
        (widget.FavSongModel != null
            ? widget.FavSongModel![widget.index].songid
            : widget.songModel![widget.index].songid));

    int nextIndex = (currentIndex + 1) % shuffledSongs.length;

    audioPlayers.stop();
    audioPlayers.setAudioSource(
      AudioSource.uri(Uri.parse(shuffledSongs[nextIndex].uri)),
    );
    audioPlayers.play();

    setState(() {
      _isPlaying = true;
      widget.index = widget.songModel!.indexOf(shuffledSongs[nextIndex]);
    });

    audioPlayers.durationStream.first.then((d) {
      setState(() {
        _duration = d!;
      });
    });

   audioPlayers.positionStream.first.then((p) {
      setState(() {
        _position = p;
      });
    });

    checkIsFavorite();
  } else {
    if (widget.FavSongModel != null) {
      int nextIndex = (widget.index + 1) % widget.FavSongModel!.length;
      audioPlayers.stop();
      audioPlayers.setAudioSource(
        AudioSource.uri(Uri.parse(widget.FavSongModel![nextIndex].uri)),
      );
      audioPlayers.play();
      setState(() {
        _isPlaying = true;
        widget.index = nextIndex;
      });
      audioPlayers.durationStream.first.then((d) {
        setState(() {
          _duration = d!;
        });
      });

      audioPlayers.positionStream.first.then((p) {
        setState(() {
          _position = p;
        });
      });
      checkIsFavorite();
    } else {
      int nextIndex = (widget.index + 1) % widget.songModel!.length;
      audioPlayers.stop();
      audioPlayers.setAudioSource(
        AudioSource.uri(Uri.parse(widget.songModel![nextIndex].uri)),
      );

      audioPlayers.play();
      setState(() {
        _isPlaying = true;
        widget.index = nextIndex;
      });
      audioPlayers.durationStream.first.then((d) {
        setState(() {
          _duration = d!;
        });
      });

      audioPlayers.positionStream.first.then((p) {
        setState(() {
          _position = p;
        });
      });
      checkIsFavorite();
    }
  }
}


  void _playPrevious() {
    if (widget.FavSongModel != null) {
      int previousIndex = (widget.index - 1 + widget.FavSongModel!.length) %
          widget.FavSongModel!.length;
      audioPlayers.stop();
      audioPlayers.setAudioSource(
        AudioSource.uri(Uri.parse(widget.FavSongModel![previousIndex].uri)),
      );
      audioPlayers.play();
      setState(() {
        _isPlaying = true;
        widget.index = previousIndex;
      });
      checkIsFavorite();
    } else {
      int previousIndex = (widget.index - 1 + widget.songModel!.length) %
          widget.songModel!.length;
      audioPlayers.stop();
      audioPlayers.setAudioSource(
        AudioSource.uri(Uri.parse(widget.songModel![previousIndex].uri)),
      );
      audioPlayers.play();
      setState(() {
        _isPlaying = true;
        widget.index = previousIndex;
      });
      checkIsFavorite();
    }
  }
  void checkIsFavorite() async {
    final dynamic sn;
    if (widget.FavSongModel != null) {
      sn = widget.FavSongModel![widget.index];
    } else {
      sn = widget.songModel![widget.index];
    }
    final song = sn;
    final favSongs = await favMusic();
    final isSongInFavorites =
        favSongs.any((favSong) => favSong.songid == song.songid.toInt());

    setState(() {
      islike = isSongInFavorites;
    });
  }

  void toggleFavorite() async {
    final dynamic sn;
    if (widget.FavSongModel != null) {
      sn = widget.FavSongModel![widget.index];
    } else {
      sn = widget.songModel![widget.index];
    }
    final song = sn;
    final favSongs = await favMusic();

    if (islike) {
      await removeFromFavourite(song.songid.toInt());
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Song removed from favorites',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      final favSong = Favmodel(
        name: song.name,
        songid: song.songid.toInt(),
        uri: song.uri,
        artist: song.artist.toString(),
        path: song.toString(),
      );
      await addFavSong(favsongs: [...favSongs, favSong]);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Song added to favorites',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.grey,
        ),
      );
    }
    checkIsFavorite();
  }
  void playSong() async {
    addSongToRecentlyPlayed(widget.songModel!=null? widget.songModel![widget.index].songid:widget.FavSongModel![widget.index].songid);
    try {
      String uri;
      if (widget.FavSongModel != null) {
        uri = widget.FavSongModel![widget.index].uri;
      } else {
        uri = widget.songModel![widget.index].uri;
      }
      await audioPlayers.setAudioSource(
        AudioSource.uri(Uri.parse(uri),
        tag:MediaItem(     
    id: ' ${widget.songModel![widget.index].songid}',
    title: ' ${widget.songModel![widget.index].name}',
    artist:' ${widget.songModel![widget.index].artist}',
  ),
        ),
        
      );
   audioPlayers.play();
      audioPlayers.setLoopMode(_isLooping ? LoopMode.one : LoopMode.off);
      _isPlaying = true;
      audioPlayers.durationStream.listen((d) {
        if(mounted){
           setState(() {
          _duration = d!;
        });
        }
      });
      audioPlayers.positionStream.listen((p) {
        if(mounted){
           setState(() {
          _position = p;
        });
        } 
      });
    } on Exception {
      debugPrint('Cannot Parse song');
    }
  }
  
}

class ArtWorkWidget extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const ArtWorkWidget({
    Key? key,
  });

  @override
  Widget build(BuildContext context) {      
    return QueryArtworkWidget(
      id: context.watch<songModelProvider>().id,
      type: ArtworkType.AUDIO,
      artworkHeight: 250,
      artworkWidth: 250,
      artworkQuality: FilterQuality.high,
      nullArtworkWidget: const Icon(
        Icons.music_note_rounded,
        color: Colors.white,
        size: 40,
      ),
    );
  }
   
}
