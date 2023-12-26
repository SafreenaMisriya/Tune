
import 'package:flutter/material.dart';
import 'package:tune/db/function/db_function.dart';
import 'package:tune/db/model/db_playlistmodel.dart';
import 'package:tune/reuse_code/color.dart';
import 'package:tune/reuse_code/fonts.dart';

 TextEditingController playlistcontroller =TextEditingController();
void showCreatePlaylistBottomSheet({required BuildContext context ,String? name,Listmodel? playlists}) {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      builder: (BuildContext context) {
         String  newPlaylistName=name?? "";
         playlistcontroller.text =newPlaylistName;
        return Container(
          height: 250,
          
          color: Colors.white54,
           
          child: Column(
            children: [
             SizedBox(  height: MediaQuery.of(context).size.height * 0.05, ),
               Text('Create  Playlist', style: TextStyle(fontSize: 20,color: voilet)),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller:  playlistcontroller,
                  onChanged: (value) {
              newPlaylistName = value;
           } ),
              ),
               SizedBox(  height: MediaQuery.of(context).size.height * 0.05, ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 51, 19, 88),
                    ),
                    child: const Text('Close'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                     if( name != null){
                      renameplaylist(playlist: playlists!, newname: newPlaylistName);
                     }else{
                      addtoplaylist(name: newPlaylistName, songid: []);
                     }             
                      // Perform the necessary actions on playlist creation
                     Navigator.pop(context);
                     playlistcontroller.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 51, 19, 88),
                    ),
                    child: Text(
                      name == null ?
                      'Create' : 'Update'),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
  playlistsheet({required BuildContext context ,String? name,Listmodel? playlists}){
   
   showDialog(context: context, builder:(BuildContext context) {
     String  newPlaylistName=name?? "";
      playlistcontroller.text =newPlaylistName;
     return AlertDialog(
      title: Center(child: Text('Create  Playlist', style: TextStyle(fontSize: 20,color: voilet))), 
      actions: [
        TextFormField(
           controller:  playlistcontroller,
                  onChanged: (value) {
              newPlaylistName = value;
           } 
        ),
           SizedBox(  height: MediaQuery.of(context).size.height * 0.05, ),
         Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 51, 19, 88),
                    ),
                    child: const Text('Close'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                     if( name != null){
                      renameplaylist(playlist: playlists!, newname: newPlaylistName);
                     }else{
                      addtoplaylist(name: newPlaylistName, songid: []);
                     }             
                      // Perform the necessary actions on playlist creation
                     Navigator.pop(context);
                     playlistcontroller.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 51, 19, 88),
                    ),
                    child: Text(
                      name == null ?
                      'Create' : 'Update'),
                  ),
                ],
              )
      ],
     );
   });
  }
  
bottomplaylistsheet({required BuildContext context, required int songId}) {
  showModalBottomSheet(
    backgroundColor: const Color.fromARGB(255, 51, 19, 88),
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(40),
      ),
    ),
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 51, 19, 88),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: FutureBuilder(
                      future: getfromplaylist(),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return const CircularProgressIndicator();
                        } else {
                          return ListView.separated(
                            itemCount: snapshot.data!.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider(
                                thickness: 1.0,
                              );
                            },
                            itemBuilder: (
                              BuildContext context,
                              int index,
                            ) {
                              return ListTile(
                                leading: const Icon(Icons.playlist_add,
                                    size: 30, color: Colors.white),
                                title: Text(snapshot.data![index].name,
                                    style:
                                        const TextStyle(color: Colors.white)),
                                onTap: () {
                                  addSongsToPlaylist(
                                      songid: songId,
                                      playlist: snapshot.data![index]);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          mytext2('Song added to Playlist'),
                                      backgroundColor: Colors.grey,
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                    title: mytext2('Create Playlist'),
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>const PlaylistScreen()));
                      playlistsheet(context: context);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      );
    },
  );
 
}
 



