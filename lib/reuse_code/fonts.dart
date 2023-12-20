
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

mytext(String text, double size, Color color) {
  return Text(text,
  style: TextStyle(
    fontFamily: GoogleFonts.merienda().fontFamily,
    color: color,
    fontSize: size,
     
  ),
  );
}
mytext2(String text ){
  return Text(text,
    style:const TextStyle(color:Colors.white) ,
  );
}