import 'package:cuchitoapp/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  static final String id = 'feed';
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    FirebaseUser userG = ModalRoute.of(context).settings.arguments;
    return Center(
      child: Scaffold(
        backgroundColor: Colors.amber,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Inserte el feed aqui',
                style: TextStyle(fontFamily: 'Billabong', fontSize: 30),
              ),
              Hero(
                  tag: 'imageHero',
                  child: Image.network(
                    'https://www.hola.com/imagenes/estar-bien/20190820147813/razas-perros-pequenos-parecen-grandes/0-711-550/razas-perro-pequenos-grandes-m.jpg',
                    width: 500,
                    height: 400,
                  )),
              Text('porfis',
                  style: TextStyle(fontFamily: 'Billabong', fontSize: 30)),
              RaisedButton(
                onPressed: () {
                  _signOut();
                },
                color: Colors.green,
                child: Text(
                  'bienvenido' + userG.displayName + userG.email,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed: null,
                child: Image.network(userG.photoUrl),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Login> _signOut() async {
    await FirebaseAuth.instance.signOut();

    return new Login();
  }
}
