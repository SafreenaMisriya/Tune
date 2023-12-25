// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tune/settings/about_screen.dart';
import 'package:tune/settings/privacy_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class NavScreen extends StatelessWidget {
  const NavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          Center(
            child: Column(
               children: [
                Image.asset('assets/images/logo.png'),
              Text('TUNE@',style: GoogleFonts.monoton(color: const Color.fromARGB(255, 65, 2, 69),fontSize: 23),),
               ],  
            ),
          ),
         const Divider(),
           ListTile(
            leading:const  Icon(Icons.share),iconColor: Colors.black, 
            title:const Text('Share'), 
            onTap: ()async{
              // shareapp();
              },
          ),
             ListTile(
            leading: const   Icon(Icons.feedback_rounded),iconColor: Colors.black,
            title:const  Text('Feedback'),
            onTap: (){
               _email();
            },
          ), 
          ListTile(
            leading:const Icon(Icons.lock),iconColor: Colors.black,
            title: const Text('Privacy Policy'),
            onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const PrivcyScreen()));}
          ),
          ListTile(
            leading:const Icon(Icons.info),iconColor: Colors.black,
            title: const Text('About '),  
               onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const AboutScreen()));} 
          ),
            SizedBox(  height: MediaQuery.of(context).size.height * 0.02, ),
           const Center(child: Text('V.1.0.0')),
           
           
        ],
      ),
    );
  }
  Future<void> _email() async {
    // ignore: deprecated_member_use
    if (await launch('mailto:safreenamisriya02@mail.com')) {
      throw "Try Again";
    }
  }
}