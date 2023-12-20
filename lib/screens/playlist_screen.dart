
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tune/Screens/favorite_screen.dart';
import 'package:tune/Screens/recently_played.dart';
import 'package:tune/db/function/db_function.dart';
import 'package:tune/db/model/db_playlistmodel.dart';
import 'package:tune/reuse_code/color.dart';
import 'package:tune/reuse_code/fonts.dart';
import 'package:tune/screens/track_screen.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List<String>playlists =[];
  TextEditingController playlistcontroller =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(  
        decoration: BoxDecoration(
          gradient: bgTheme(),
        ),
        child: Column(
          children: [ 
                      Center(
                        child: mytext('Playlist', 20, Colors.white)
                      ),           
               SizedBox(  height: MediaQuery.of(context).size.height * 0.05, ),
                    ListTile(
                      leading: IconButton(onPressed: (){}, icon: const  Icon(Icons.favorite,color: Color.fromARGB(255, 167, 11, 11),size: 40)), 
                      title:mytext('Favorite',20,Colors.black),
                      trailing: IconButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const FavoriteScreen()));
                      }, icon:const Icon(Icons.arrow_forward_ios,color: Colors.white,)),  
                    ),
                    ListTile(
                      leading: IconButton(onPressed: (){}, icon: const  Icon(Icons.timer_outlined,color: Color.fromARGB(255, 0, 85, 3),size: 40,)), 
                      title:mytext('Recently Played',20,Colors.black),
                      trailing: IconButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const  RecentlyPlayed()));
                      }, icon:const Icon(Icons.arrow_forward_ios,color: Colors.white,)),
                    ),
                 SizedBox(  height: MediaQuery.of(context).size.height * .03,
                  ),
                    ListTile(
                      leading: mytext('CREATE PLAYLIST',20,Colors.white),
                      trailing:  IconButton(onPressed: (){
                             showCreatePlaylistBottomSheet(context: context);    
                            }, icon: const Icon(Icons.add,size: 40,color: Colors.white,)),
                    ),
                  SizedBox(  height: MediaQuery.of(context).size.height * .03, ),    
            Expanded(
      child: FutureBuilder(
      future: getfromplaylist(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const CircularProgressIndicator();
        } else {
          return ListView.separated(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                thickness: 1.0,
              );
            },
            itemBuilder: (BuildContext context, int index,) {
              return ListTile(
                leading: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white30,
                  ),
                  child:  Icon(Icons.music_note_outlined, size: 30, color: Colors.orange[800]),
                ),
                title: Text(snapshot.data![index].name, style: const TextStyle(color: Colors.white)),
                trailing: PopupMenuButton(
                  color: voilet,
                  icon: const Icon(FontAwesomeIcons.ellipsisVertical, color: Colors.white),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        child: mytext2('Rename Playlist'),
                        onTap: () {
                         showCreatePlaylistBottomSheet(context: context,name: snapshot.data![index].name,playlists: snapshot.data![index]);
                          setState(() {
                            
                          });
                        },
                      ),
                        PopupMenuItem(
                        child:mytext2('Delete Playlist'),
                        onTap: (){
                          showDialog(context: context, 
                          builder: (BuildContext context) {
                            return   AlertDialog(
                              title:const Text('Do you want to delete the playlist ?'),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                 ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor:const Color.fromARGB(255, 51, 19, 88), ),
                                  onPressed: (){
                               deletePlayList(index);
                               setState(() {});
                                 Navigator.pop(context);
                                }, child:const Text('Yes')),
                                ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor:const Color.fromARGB(255, 51, 19, 88), ), 
                                onPressed: (){
                                Navigator.pop(context);
                                }, child:const Text('No')),
                                  ],
                                )
                              ],
                            );
                          });
                         },
                      ),
                    ];},
                ),
                onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder:(context)=> Trackplaylist(
                  playlistmodel: snapshot.data![index],
                  playlistname: snapshot.data![index].name,
    
                 ))) ;
                },
              );
            },
          );
        }
      },
      ),
    ),
              ],
            ),
        ),
    );
     }
     void showCreatePlaylistBottomSheet({required BuildContext context ,String? name,Listmodel? playlists}) {
    showBottomSheet(
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
              const Text('Create  Playlist', style: TextStyle(fontSize: 20)),
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
                      backgroundColor: voilet,
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
                     setState(() {
                       
                     });
                     
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:voilet,
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
 
}
         
                  
                
              
             
                
                
              
