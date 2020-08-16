import 'package:cuchitoapp/screens/feed.dart';
import 'package:cuchitoapp/screens/login.dart';
import 'package:cuchitoapp/screens/registro.dart';
import 'package:cuchitoapp/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CuhitoAPP',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        Login.id: (context) => Login(),
        Registro.id: (context) => Registro(),
        Feed.id: (context) => Feed(),
      },
    );
  }
}
