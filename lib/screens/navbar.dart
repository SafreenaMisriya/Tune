// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
         const ListTile(
            leading: Icon(Icons.privacy_tip_sharp),iconColor: Colors.black,
            title:  Text('Privacy Policy'),
           // onTap: () => null,
          ),
          const ListTile(
            leading:Icon(Icons.star_border),iconColor: Colors.black,
            title:  Text('Rate Us'),   
          ),
        const  ListTile(
            leading:    Icon(Icons.feedback_rounded),iconColor: Colors.black,
            title:  Text('Feedback'),
           
          ), 
        ],
      ),
    );
  }
}