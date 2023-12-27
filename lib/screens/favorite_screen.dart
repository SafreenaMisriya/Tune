// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:tune/Povider/image_provider.dart';
import 'package:tune/Screens/nowplay_screen.dart';
import 'package:tune/db/function/db_function.dart';
import 'package:tune/db/model/db_favmodel.dart';
import 'package:tune/reuse_code/color.dart';
import 'package:tune/reuse_code/fonts.dart';

class FavoriteScreen extends StatefulWidget {
  final bool visible;
  // ignore: prefer_const_constructors_in_immutables
  FavoriteScreen({
    Key? key,
    required this.visible,
  }) : super(key: key);
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<Favmodel>> dbfavsong;

  bool islike = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      dbfavsong = favMusic();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(252, 120, 178, 226),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: bgTheme(),
          ),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                widget.visible
                    ? IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ))
                    : Container(),
              ]),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: mytext('Favorite', 20, Colors.white),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: FutureBuilder(
                      future: dbfavsong,
                      builder: (context, item) {
                        if (item.data == null) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (item.data!.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/heart.gif'),
                                Text(
                                  'NO FAVORITE SONGS',
                                  style: GoogleFonts.merienda(
                                      color: Colors.white, letterSpacing: 5),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return ListView.builder(
                              itemCount: item.data!.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white38),
                                  child: ListTile(
                                    leading: QueryArtworkWidget(
                                     quality: 100,
                                      id: item.data![index].songid,
                                      type: ArtworkType.AUDIO,
                                      size: 50,
                                      nullArtworkWidget: const Icon(
                                        Icons.music_note_rounded,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                    ),
                                    title: Text(
                                      item.data![index].name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      item.data![index].artist,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: IconButton(
                                        onPressed: () async {
                                          int songId = item.data![index].songid;
                                          await removeFromFavourite(songId);
                                          setState(() {
                                            dbfavsong = favMusic();
                                          });
                                          // ignore: use_build_context_synchronously
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: mytext2(
                                                  'Song removed from favorites'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                          size: 25,
                                        )),
                                    onTap: () {
                                      context
                                          .read<songModelProvider>()
                                          .setId(item.data![index].songid);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PlayScreen(
                                              FavSongModel: item.data!,                                          
                                              index: index,
                                            ),
                                          )).then((value) {
                                        setState(() {
                                          dbfavsong = favMusic();
                                        });
                                      });
                                    },
                                  ),
                                );
                              });
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
