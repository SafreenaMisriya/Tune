
// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:tune/Povider/image_provider.dart';
import 'package:tune/Screens/favorite_screen.dart';
import 'package:tune/Screens/navbar.dart';
import 'package:tune/Screens/nowplay_screen.dart';
import 'package:tune/Screens/playlist_screen.dart';
import 'package:tune/Screens/search_screen.dart';
import 'package:tune/db/function/db_function.dart';
import 'package:tune/db/model/db_favmodel.dart';
import 'package:tune/db/model/db_model.dart';
import 'package:tune/reuse_code/bottom.dart';
import 'package:tune/reuse_code/color.dart';
import 'package:tune/reuse_code/fonts.dart';
import 'package:tune/settings/share.dart';
 final audioPlayer = AudioPlayer();
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  // ignore: prefer_final_fields
  PageController _pageController = PageController();
 
  final List<Widget> _pages = [
    const HomeContent(),
    const SearchScreen(),
   FavoriteScreen(visible: false,),
    const PlaylistScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavScreen(),
      appBar: _currentIndex == 0
          ? AppBar(
              backgroundColor:const  Color.fromARGB(255, 141, 177, 247),
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('T U N E',
                      style: GoogleFonts.emblemaOne(
                          color: const Color.fromARGB(255, 8, 0, 0), fontSize: 30)),
                  Text(
                    ' @',
                    style: GoogleFonts.kohSantepheap(
                        color:const Color.fromARGB(255, 111, 19, 223),
                        fontSize: 25,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
              centerTitle: true,
            )
          : null,
      body: Container(
        decoration: BoxDecoration(
          gradient: bgTheme(),
        ),
        child: SafeArea(
            child: Column(
          children: [
            Expanded(
                child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return _pages[index];
                    })
                    ),
          ],
        )),
      ),
      bottomNavigationBar: BottomNavigationBar(
       currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            _pageController.jumpToPage(index);
          },
          items:  [
            BottomNavigationBarItem(
                backgroundColor:voilet,
                icon: const Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
               backgroundColor: voilet,
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                label: 'Search'),
            BottomNavigationBarItem(
               backgroundColor:voilet,
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                label: 'Favorite'),
            BottomNavigationBarItem(
               backgroundColor: voilet,
                icon: const Icon(
                  Icons.playlist_play_rounded,
                  color: Colors.white,
                ),
                label: 'Playlist'),
          ]),
    );
  }
}
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});
  @override
  State<HomeContent> createState() => _HomeContentState();
}
class _HomeContentState extends State<HomeContent> {
  
  List<SongModel> songs = [];
  final _audioQuery = OnAudioQuery();
  
  bool islike=false;
  late Future<List<MusicSong>> s;
  // ignore: non_constant_identifier_names
  PlaySong(String? uri) {
    try {
        audioPlayer.setAudioSource(
        AudioSource.uri(
        Uri.parse(uri!.toString()),
        ),
      );
      audioPlayer.play();
    } on Exception {
      debugPrint('ERROR IS PASSING');
    }
  }
  @override
  void initState() {
    super.initState();
    s = music();
  }
  Future<List<SongModel>> getaudio() async {
    List<SongModel> s = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    songs = s;
    addSong(s: s);
    return s;
  }
late Widget  leadingWidget;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
            future: s,
            builder: (context, item) {
              if (item.data == null) {
                getaudio();
                return  const Center(child: CircularProgressIndicator());
              } else if (item.connectionState == ConnectionState.waiting) {
                return  const Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                    itemCount: item.data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                           borderRadius:BorderRadius.circular(20) ,
                            color: Colors.white38),
                        child: ListTile(
                      leading:  QueryArtworkWidget(
                        artworkQuality: FilterQuality.high,
                          id: item.data![index].songid,
                         type: ArtworkType.AUDIO,
                         size: 50,       
                         nullArtworkWidget:const  Icon(Icons.music_note_rounded,color: Colors.black,size: 30,),
                         ),
                          title: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Text(
                              // ignore: unnecessary_string_interpolations
                              '${item.data![index].name
                              // .substring(0,13)
                              }',
                               overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // ignore: unnecessary_string_interpolations
                          subtitle: Text('${item.data![index].artist}',
                          overflow:TextOverflow.ellipsis,
                          ),
                          trailing: PopupMenuButton(
                              color:voilet,
                            icon:const Icon( FontAwesomeIcons.ellipsisVertical,color: Colors.black,),
                            itemBuilder: (BuildContext context) {
                              return[
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                     const Icon(Icons.favorite,color: Colors.white,),
                                        SizedBox(  width: MediaQuery.of(context).size.width * 0.03,
                                   ),
                                    mytext2('Add to Favourite'),
                                    ],
                                  ),
                                  onTap: ()async {
                                    final song = item.data![index];
                                              final favSongs = await favMusic();
                                              final favSong = Favmodel(
                                                name: song.name,
                                                songid: song.songid.toInt(),
                                                uri: song.uri,
                                                artist: song.artist.toString(),
                                                path: song.path,
                                                
                                              );
                                              await addFavSong(favsongs: [...favSongs, favSong]);
                                               ScaffoldMessenger.of(context).showSnackBar(
                                             SnackBar(
                                             content: mytext2('Song added to favorites'),
                                             backgroundColor: Colors.grey,
                                            ),
                                               );
                                  },
                                  ),
                               PopupMenuItem(
                                  child:  Row(
                                    children: [
                                     const  Icon(Icons.playlist_add,color: Colors.white,),
                                      SizedBox(  width: MediaQuery.of(context).size.width * 0.03,
                                   ),
                                     mytext2('Add to Playlist'),
                                    ],
                                  ),
                                 onTap: (){ bottomplaylistsheet(context: context, songId:item.data![index].songid); },
                                  ),
                                   PopupMenuItem(
                                  child:  Row(
                                    children: [
                                     const  Icon(Icons.share,color: Colors.white,),
                                    SizedBox(  width: MediaQuery.of(context).size.width * 0.03,
                                   ),
                                      mytext2('Share'),
                                    ],
                                  ),onTap: () {
                                    sharemusic(item.data![index]);
                                    },
                                  ),
                              ];
                            }),
                          onTap: () {
                            context.read<songModelProvider>().setId(item.data![index].songid);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlayScreen(
                                    songModel: item.data!,
                                    audioPlayer: audioPlayer,
                                    index: index,
                    
                                  ),
                                ));
                          },
                        ),
                      );
                    });
              }
            }),
    );
    
  }
}
