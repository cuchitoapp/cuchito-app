import 'package:flutter/material.dart';

class Feed2 extends StatelessWidget {
  final String username;
  const Feed2({Key key, @required this.username}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('hola: $username'),
    );
  }
}
