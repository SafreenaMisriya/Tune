import 'package:flutter/material.dart';
import 'package:tune/reuse_code/color.dart';
import 'package:tune/reuse_code/fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient:bgTheme2(),
        ),
        child: Column(
          children: [
             SizedBox(  height: MediaQuery.of(context).size.height * 0.06, ),
             Row(
              children: [
                IconButton(onPressed: (){
                  Navigator.pop(context);
                  }, icon:const Icon(Icons.arrow_back,color: Colors.white,)),
               SizedBox(  width: MediaQuery.of(context).size.width * 0.3,),
               mytext('ABOUT', 20, Colors.white)
              ],
            ), 
           const Padding(
              padding:    EdgeInsets.all(30),
              child: Text(
               '''Introducing our innovative music player app, designed to revolutionize your listening experience. Our app combines cutting-edge technology with an intuitive interface,  offering seamless navigation through your music library. Enjoy personalized playlists, superiorsound quality, and effortless organization of your favorite tracks. Whether you're a music enthusiast or a casual listener, our app caters to your every need. Elevate your music journey with our feature-rich, user-centric music player app.''',
               style: TextStyle(
                color: Colors.grey,fontSize: 20
               ),
              ),
            )
          ],
        ), 
      ),

    );
  }
}