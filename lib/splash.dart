import 'dart:async';

import 'package:cuchitoapp/screens/login_screen.dart';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 4),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.lightGreen[900]),
            child: Hero(
                tag: 'imageHero',
                child: Image.network(
                  'https://i.ibb.co/syVr5Rx/screen-splash.png',
                  fit: BoxFit.cover,
                )),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 290),
                          child: Text(
                            '',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Billabong',
                                fontSize: 50,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation(Colors.blueAccent[200]),
                        backgroundColor: Colors.green[300],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Text(
                      '',
                      style: TextStyle(
                          fontFamily: 'Billabong',
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
