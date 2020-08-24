import 'dart:io';

import 'package:flutter/material.dart';

class RegisterPetC extends StatelessWidget {
  final String name;

  const RegisterPetC({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Advertencia'),
          content: Text('Quieres salir de Cuchito?'),
          actions: [
            FlatButton(
              child: Text('Si'),
              onPressed: () => exit(0),
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(c, false),
            ),
          ],
        ),
      ),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(child: null),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Padding(padding: EdgeInsets.only(top: 50)), Center()],
            )
          ],
        ),
      ),
    );
  }
}
