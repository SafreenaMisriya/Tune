// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tune/db/function/db_function.dart';
import 'package:tune/db/model/db_playlistmodel.dart';
import 'package:tune/reuse_code/color.dart';
import 'package:tune/reuse_code/fonts.dart';

class Playlistall extends StatefulWidget {
   Listmodel playlistmodel;
   Playlistall({required this.playlistmodel,Key? key}):super(key: key);

  @override
  State<Playlistall> createState() => _PlaylistallState();
}

class _PlaylistallState extends State<Playlistall> {
 @override
  void initState() {
    super.initState();
    checkSongOnPlaylist(playlist: widget.playlistmodel);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: bgTheme(),
        ),
        child: Column(
          children: [
             SizedBox(  height: MediaQuery.of(context).size.height * 0.05, ),
            Row(
              children: [
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon:const  Icon(Icons.arrow_back,color: Colors.white,size: 30,)),
                SizedBox(  width: MediaQuery.of(context).size.width * 0.3, ),
                mytext('Add Songs', 20, Colors.white),
              ],
            ),
             Expanded(
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: FutureBuilder(
                   future: music(),
                    builder: (context, item) {
                    if (item.data == null) {
                     return const CircularProgressIndicator();
                    } else if (item.connectionState == ConnectionState.waiting) {
                     return const CircularProgressIndicator();
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
                          title: Text(
                            // ignore: unnecessary_string_interpolations
                            '${item.data![index].name}',
                             overflow: TextOverflow.ellipsis,
                          ),
                          // ignore: unnecessary_string_interpolations
                          subtitle: Text('${item.data![index].artist}',
                          overflow:TextOverflow.ellipsis,
                          ),
                          trailing: plyids.contains(item.data![index].songid)
                            ? IconButton(onPressed: (){
                              removeSongsFromPlaylist(
                                songid: item.data![index].songid,
                                 playlist: widget.playlistmodel);
                                 checkSongOnPlaylist(
                                  playlist: widget.playlistmodel);
                                  setState(() {
                                    
                                  });
                            }, icon: const Icon(Icons.check,color: Colors.green,))
                            : IconButton(onPressed: (){
                              addSongsToPlaylist(
                                songid: item.data![index].songid,
                                 playlist: widget.playlistmodel);
                                 checkSongOnPlaylist(
                                  playlist: widget.playlistmodel);
                                  setState(() {
                                    
                                  });
                            }, icon: const  Icon(Icons.add,color: Colors.red,)),
                        ),
                      );
                    });
                   }
                 }),
               ),
             ), 
          ],),
      ),
    );
  }
}