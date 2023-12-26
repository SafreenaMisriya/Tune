// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:tune/Povider/image_provider.dart';
import 'package:tune/db/function/db_function.dart';
import 'package:tune/db/model/db_favmodel.dart';
import 'package:tune/db/model/db_playlistmodel.dart';
import 'package:tune/reuse_code/color.dart';
import 'package:tune/reuse_code/fonts.dart';
import 'package:tune/screens/home_screen.dart';
import 'package:tune/screens/nowplay_screen.dart';
import 'package:tune/screens/select_screen.dart';

// ignore: must_be_immutable
class Trackplaylist extends StatefulWidget {
  String playlistname;
  Listmodel playlistmodel;
   Trackplaylist({required this.playlistname,required this.playlistmodel,Key? key}):super (key: key);

  @override
  State<Trackplaylist> createState() => _TrackplaylistState();
}
class _TrackplaylistState extends State<Trackplaylist> {
  TextEditingController playlistcontroller =TextEditingController();
  
 @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
           decoration: BoxDecoration(
          gradient: bgTheme2(),
          ),  
          child: Column(
            children: [
             SizedBox(  height: MediaQuery.of(context).size.height * 0.05, ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                      }, icon:const Icon(Icons.arrow_back,color: Colors.white,size: 30,)),
                    // SizedBox(  width: MediaQuery.of(context).size.width * 0.3   ),
                   Text(widget.playlistname, style:const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                   ),
                    ),
                   IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      Playlistall(
                        playlistmodel: widget.playlistmodel,
                      ))
                      ).then((value) {
                        setState(() {   
                        });
                      });
                    }, icon: const Icon(Icons.add,size: 40,color: Colors.white,)), 
                  ],
                ),
            ),    
              Flexible( 
                fit: FlexFit.loose,
                child: FutureBuilder(
                      future: playlistSongs(playslist: widget.playlistmodel),
                      builder: (context, item) {
                        if (item.data == null) {       
                return  const Center(child: CircularProgressIndicator());
                        }  else if(item.data!.isEmpty){
                              return Center(   
                                 child:mytext('No songs', 25, Colors.white)   
                              );
                             }
                         else {
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
                          title: Text(
                            // ignore: unnecessary_string_interpolations
                            '${item.data![index].name}',
                             overflow: TextOverflow.ellipsis,
                          ),
                          // ignore: unnecessary_string_interpolations
                          subtitle: Text('${item.data![index].artist}',
                          overflow:TextOverflow.ellipsis,
                          ),
                          trailing:  PopupMenuButton(
                              color:voilet,        
                            icon:const Icon( FontAwesomeIcons.ellipsisVertical,color: Colors.black,),
                            itemBuilder: (BuildContext context) {
                              return[
                               PopupMenuItem(
                                  child: Row(
                                    children: [
                                     const  Icon(Icons.favorite,color: Colors.white,),
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
                                           content:mytext2('Song added to favorites'),
                                           backgroundColor: Colors.grey,
                                          ),
                                             );
                                         },
                                         ),
                                  PopupMenuItem(
                                  child:  Row(
                                    children: [
                                      const Icon(Icons.delete,color: Colors.white,),
                                      SizedBox(  width: MediaQuery.of(context).size.width * 0.03,),
                                    mytext2('Remove song'),
                                    ],
                                  ),
                                  onTap:(){
                                    removeSongsFromPlaylist(songid: item.data![index].songid, playlist: widget.playlistmodel);
                                    setState(() {    
                                    });
                                  } ,
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
            ],
          ),
        ),
      ),
    );
  } 
}