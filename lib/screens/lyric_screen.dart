import 'package:flutter/material.dart';
import 'package:tune/reuse_code/color.dart';
import 'package:tune/reuse_code/fonts.dart';

class LyricsScreen extends StatefulWidget {
  const LyricsScreen({super.key});

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:Container(
        decoration: BoxDecoration(
          gradient: bgTheme2(),
        ),
        child: Center(
          child: mytext('NO LYRICS', 20, Colors.white),
        ),
     ) ,

    );
  }
}