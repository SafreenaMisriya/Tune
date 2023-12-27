
// ignore_for_file: file_names, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:tune/Povider/image_provider.dart';
import 'package:tune/Screens/nowplay_screen.dart';
import 'package:tune/db/function/db_function.dart';
import 'package:tune/db/model/db_favmodel.dart';
import 'package:tune/db/model/db_model.dart';
import 'package:tune/reuse_code/bottom.dart';
import 'package:tune/reuse_code/color.dart';
import 'package:tune/reuse_code/fonts.dart';
import 'package:tune/settings/share.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<MusicSong> findsong = [];
  List<MusicSong> songlist = [];
  
  @override
  void initState() {
    super.initState();
    getsongs();
  }
  
  
  void getsongs() async {
    songlist = await music();
    setState(() {
      findsong = songlist;
    });
  }
  void searchFunction() {
    if (searchController.text.isEmpty) {
      setState(() {
        findsong = songlist;
      });
    } else {
      
       setState(() {
          findsong = songlist
            .where((song) =>
                song.name.toLowerCase().contains(searchController.text.toLowerCase()) ||
                song.artist.toLowerCase().contains(searchController.text.toLowerCase()))
            .toList();
       });
      
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        searchFunction();
                        setState(() {
                          
                        });
                      },
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Search Songs,Artist name',
                        hintStyle: const TextStyle(
                        color: Colors.grey,
                        ),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                            onPressed: () {
                              searchController.clear();
                              searchFunction();
                              setState(() {
                                
                              });
                            },
                            icon:const Icon(Icons.clear)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: findsong.isEmpty
            ? Image.asset('assets/images/data.png')
           : Padding(
             padding: const EdgeInsets.all(8.0),
             child: ListView.builder(
                itemCount: findsong.length,
                itemBuilder: (ctx, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                       borderRadius:BorderRadius.circular(20) ,
                        color: Colors.white38),
                    child: ListTile(
                      leading:  QueryArtworkWidget(
                         artworkQuality: FilterQuality.high,
                      id: findsong[index].songid,
                     type: ArtworkType.AUDIO,
                     size: 50,
                     nullArtworkWidget: const Icon(Icons.music_note_rounded,color: Colors.black,size: 30,),
                     ),
                      
                      title: Text(
                        findsong[index].name
                        // .substring(0,13)
                         ,
                         overflow:TextOverflow.ellipsis,
                      ),
                      subtitle: Text(findsong[index].artist,
                       overflow:TextOverflow.ellipsis,
                      ),
                      trailing: 
                      PopupMenuButton(
                          color: voilet,
                        icon:const Icon( FontAwesomeIcons.ellipsisVertical,color: Colors.black,),
                        itemBuilder: (BuildContext context) {
                          return[
                            PopupMenuItem(
                              child:  Row(
                                children: [
                                 const Icon(Icons.favorite,color: Colors.white,),
                                  SizedBox(  width: MediaQuery.of(context).size.width * 0.03,
                                 ),
                                mytext2('Add to Favourite'),
                                ],
                              ),
                              onTap: ()async {
                                  final song = findsong[index];
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
                              },),
                           PopupMenuItem(
                              child: Row(
                                children: [
                                const  Icon(Icons.playlist_add,color: Colors.white),
                                 SizedBox(  width: MediaQuery.of(context).size.width * 0.03,
                                 ),
                                 mytext2('Add to Playlist'),
                                ],
                              ),
                             onTap: () {
                               bottomplaylistsheet(context: context, songId: findsong[index].songid);
                             },
                              ),
                              PopupMenuItem(
                              child: Row(
                                children: [
                                  const Icon(Icons.share,color: Colors.white),
                                   SizedBox(  width: MediaQuery.of(context).size.width * 0.03,
                                 ),
                                 mytext2('Share'),
                                ],
                              ),
                              onTap: () {
                                    sharemusic(findsong[index]);
                                  },
                              ),
                          ];
                        }),
                      onTap: ()async {
                          FocusScope.of(context).unfocus();
                          await Future.delayed(const Duration(milliseconds: 300));
                        context.read<songModelProvider>().setId(findsong[index].songid);
                         WidgetsBinding.instance.addPostFrameCallback((_) { 
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>PlayScreen(
                                index: index,
                                songModel:findsong,
                                )
                            ));
                            });
                      },
                    ),
                  );
                
                },
              ),
           ),
          ),
        ],
      ),
    );
  }
      
}
