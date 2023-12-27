// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tune/reuse_code/color.dart';
import 'package:tune/reuse_code/fonts.dart';

class LyricsPage extends StatefulWidget {
  final String songName;
  final String artistName;

  LyricsPage({super.key, required this.songName, required this.artistName});

  @override
  LyricsPageState createState() => LyricsPageState();
}

class LyricsPageState extends State<LyricsPage> {
  String lyrics = '';

  @override
  void initState() {
    super.initState();
    getLyrics(widget.songName, widget.artistName);
  }


Future<void> getLyrics(String songName, String artistName) async {
  String apiKey = '91f05c3f6c6bc9295e5e3833db8183b3';

  String searchUrl =
      'https://api.musixmatch.com/ws/1.1/track.search?apikey=$apiKey&q_track=$songName&q_artist=$artistName';

  try {
    http.Response response = await http.get(Uri.parse(searchUrl));
    Map<String, dynamic> data = json.decode(response.body);

    if (response.statusCode == 200 && data['message']['header']['status_code'] == 200) {
      List<dynamic> trackList = data['message']['body']['track_list'];

      if (trackList.isNotEmpty) {
        int trackId = trackList[0]['track']['track_id'];

        String lyricsUrl = 'https://api.musixmatch.com/ws/1.1/track.lyrics.get?apikey=$apiKey&track_id=$trackId';
        http.Response lyricsResponse = await http.get(Uri.parse(lyricsUrl));
        Map<String, dynamic> lyricsData = json.decode(lyricsResponse.body);

        if (lyricsResponse.statusCode == 200 && lyricsData['message']['header']['status_code'] == 200) {
          String trackLyrics = lyricsData['message']['body']['lyrics']['lyrics_body'];

          trackLyrics = trackLyrics.split('\n').where((line) => !line.contains('This Lyrics is NOT for Commercial use ')).join('\n').trim();

          setState(() {
            lyrics = trackLyrics;
          });
        } else {
          setState(() {
            lyrics = 'Error getting lyrics: ${lyricsData['message']['header']['status_code']}';
          });
        }
      } else {
        setState(() {
          lyrics = 'No tracks found for the specified song and artist.';
        });
      }
    } else {
      setState(() {
        lyrics = 'Error searching for the track: ${data['message']['header']['status_code']}';
      });
    }
  } catch (e) {
    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
           content: mytext2('No Internet connection'),
            backgroundColor:const Color.fromARGB(255, 218, 12, 12),
                ),
              );
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: bgTheme2(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
              SizedBox(  height: MediaQuery.of(context).size.height * 0.05, ), 
             Row(
              mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 IconButton(onPressed: (){
                      Navigator.pop(context);
                      }, icon:const Icon(Icons.arrow_back,color: Colors.white,)),
               ],
             ),
           SizedBox(  height: MediaQuery.of(context).size.height * 0.01, ),
           Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            mytext( 'Song: ${widget.songName}',20, Colors.white),
            mytext('Artist: ${widget.artistName}',20,Colors.white),
            ],
           ),
           SizedBox(  height: MediaQuery.of(context).size.height * 0.05, ), 
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    lyrics,
                    style:const TextStyle(fontSize: 16,color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
