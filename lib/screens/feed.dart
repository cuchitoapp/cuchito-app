import 'package:flutter/material.dart';

class feed extends StatefulWidget {
  @override
  _feedState createState() => _feedState();
}

class _feedState extends State<feed> {
  @override
  Widget build(BuildContext context) {
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
                style: TextStyle(fontFamily: 'Billabong', fontSize: 50),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
