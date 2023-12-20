import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tune/Screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState(); 
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
     requestPermission();
    Timer(const Duration(seconds: 3), 
          ()=>Navigator.pushReplacement(context, 
          MaterialPageRoute(builder: 
        (context) =>   const HomeScreen()
        ) 
     ) ,
   ); 
  }
  void requestPermission() {
    Permission.storage.request();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:Center( 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Image.asset('assets/images/logo.png',),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('T U N E',style: GoogleFonts.emblemaOne(color: Colors.black,fontSize: 35),),
                Text(' @',style: GoogleFonts.kohSantepheap(color:Colors.amber[800],fontSize: 30),)
              ],),
            ], ),
        )
      )
    );
  }}