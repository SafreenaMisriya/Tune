
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tune/Povider/image_provider.dart';
import 'package:tune/db/model/db_playlistmodel.dart';
import 'package:tune/db/model/db_recentmodel.dart';
import 'package:tune/screens/splash_screen.dart';
import 'package:tune/db/model/db_favmodel.dart';
import 'package:tune/db/model/db_model.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await Hive.initFlutter();
 if(!Hive.isAdapterRegistered( MusicSongAdapter().typeId)){
  Hive.registerAdapter(MusicSongAdapter());
 }
  if(!Hive.isAdapterRegistered(ListmodelAdapter ().typeId)){
  Hive.registerAdapter(ListmodelAdapter());
 }
 if(!Hive.isAdapterRegistered( FavmodelAdapter ().typeId)){
  Hive.registerAdapter(FavmodelAdapter());
 }
 if(!Hive.isAdapterRegistered( RecentmodelAdapter ().typeId)){
  Hive.registerAdapter(RecentmodelAdapter());
 }
  runApp(  MultiProvider(
      providers: [
        
        ChangeNotifierProvider<songModelProvider>(
          create: (_) => songModelProvider(),
        ),
      ],
      child: const myApp(),
    ),);
}
// ignore: camel_case_types
class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: const SplashScreen(),
    );
  }
}

