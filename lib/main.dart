import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/screens/loading_screen.dart';
import 'package:weather_app/services/location.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>Location()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: LoadingScreen(),
      ),
    );
  }
}