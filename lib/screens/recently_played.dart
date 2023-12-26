// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:tune/db/function/db_function.dart';
import 'package:tune/db/model/db_favmodel.dart';
import 'package:tune/reuse_code/bottom.dart';
import 'package:tune/reuse_code/color.dart';
import 'package:tune/reuse_code/fonts.dart';
import 'package:tune/screens/home_screen.dart';
import 'package:tune/screens/nowplay_screen.dart';
import 'package:tune/settings/share.dart';
import '../Povider/image_provider.dart';

class RecentlyPlayed extends StatefulWidget {
  const RecentlyPlayed({super.key});
  @override
  State<RecentlyPlayed> createState() => _RecentlyPlayedState();
}
class _RecentlyPlayedState extends State<RecentlyPlayed> {

@override
  void dispose() {
   audioPlayer.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
        gradient: bgTheme(),
        ),  
        child:Column(
          children: [
              SizedBox(  height: MediaQuery.of(context).size.height * 0.05, ),
            Row(
              children: [
                IconButton(onPressed: (){
                  Navigator.pop(context);
                  }, icon:const Icon(Icons.arrow_back,color: Colors.white,)),
               SizedBox(  width: MediaQuery.of(context).size.width * 0.2,),
               mytext('Recently Played', 20, Colors.white)
              ],
            ), 
            Expanded(
              child: FutureBuilder(
                    future: recentlyPlayedSongs(),
                    builder: (context, item) {
                      if (item.data == null) { 
                      return const CircularProgressIndicator();
                      } else if (item.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                      }else if(item.data!.isEmpty){
                            return Center(
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/sad.gif'),
                                  mytext('NO SONG', 20, Colors.white),
                                ],
                              ) ,
                            );
                           }
                   else {
                 return ListView.builder(
                  itemCount: (item.data?.length ?? 0) < 10 ? item.data!.length : 10,
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
                        title: Text(
                          // ignore: unnecessary_string_interpolations
                          '${item.data![index].name}',
                           overflow: TextOverflow.ellipsis,
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
                                 mytext2('Add to Favourite') , 
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
                                         content: mytext2( 'Song added to favorites'),
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
                               onTap: (){
                                 bottomplaylistsheet(context: context,
                                 songId:  item.data![index].songid,
                                 
                                 );},
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
            ),
            
          ],)
      ),
    );
  }
}