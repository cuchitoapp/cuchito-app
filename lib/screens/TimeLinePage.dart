import 'package:cuchitoapp/widgets/HeaderWidget.dart';
import 'package:cuchitoapp/widgets/ProgressWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class TimeLinePage extends StatefulWidget {
  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

final GoogleSignIn _googleSignIn = GoogleSignIn();

class _TimeLinePageState extends State<TimeLinePage> {
  signout() {
    _googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(
          context,
          isAppTitle: true,
        ),
        body: RaisedButton(
          onPressed: signout(),
        ));
  }
}
