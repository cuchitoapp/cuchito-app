import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Feed extends StatelessWidget {
  static final String id = 'feed';
  final String username;
  final String name;

  const Feed({Key key, this.username, this.name}) : super(key: key);
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
              Container(
                child: RaisedButton(
                  onPressed: () {},
                  color: Colors.green,
                  child: Text(
                    'bienvenido',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
