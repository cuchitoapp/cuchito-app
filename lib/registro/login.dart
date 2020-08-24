import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuchitoapp/screens/feed.dart';
import 'package:cuchitoapp/registro/registroUser.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  static final String id = 'login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // APLICACION Y VISTAS EN SI
  final _formKey = GlobalKey<FormState>();
  String _usuario, _pass;
  TextEditingController emailLogController = new TextEditingController();
  TextEditingController passLogController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            Container(
              decoration: BoxDecoration(color: Colors.lightGreen[900]),
              child: Image.asset(
                'assets/images/foto1.png',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 20.0),
                      child: TextFormField(
                        controller: emailLogController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: theme.textTheme.caption
                              .copyWith(color: Colors.white, fontSize: 15.0),
                          icon: Icon(
                            FontAwesomeIcons.envelope,
                            color: Colors.white,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (input) =>
                            input.isEmpty ? 'Ingrese su email' : null,
                        onSaved: (input) => _usuario = input,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 20.0),
                      child: TextFormField(
                        controller: passLogController,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: theme.textTheme.caption
                              .copyWith(color: Colors.white, fontSize: 15.0),
                          icon: Icon(
                            FontAwesomeIcons.unlock,
                            color: Colors.white,
                          ),
                        ),
                        validator: (input) => input.trim().isEmpty
                            ? 'Debe ingresar alguna contraseña'
                            : null,
                        onSaved: (input) => _pass = input,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: 200.0,
                      child: RaisedButton(
                        onPressed: () {
                          logInWithCuchito();
                        },
                        color: Colors.green,
                        child: Text(
                          'Ingresar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                alignment: Alignment.bottomCenter,
                height: 500,
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FloatingActionButton(
                      heroTag: 'cuchito',
                      backgroundColor: Color(0xff3b5998),
                      child: Icon(FontAwesomeIcons.paw),
                      onPressed: () {
                        Navigator.pushNamed(context, Registro.id);
                      },
                    ),
                    FloatingActionButton(
                      heroTag: 'google',
                      child: Icon(FontAwesomeIcons.google),
                      backgroundColor: Color(0xff4285F4),
                      onPressed: () {
                        handleSignIn().whenComplete(() => Navigator.pushNamed(
                            context, Feed.id,
                            arguments: _userG));
                      },
                    ),
                    FloatingActionButton(
                      heroTag: 'facebook',
                      backgroundColor: Color(0xff3b5998),
                      child: Icon(FontAwesomeIcons.facebook),
                      onPressed: () {
                        SnackBar(
                          content: Text('hola'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Login Google
  FirebaseAuth _authG = FirebaseAuth.instance;
  FirebaseUser _userG;
  bool isSignIn = false;

  GoogleSignIn _googleSignIn = new GoogleSignIn();
  Future<void> handleSignIn() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    AuthResult result = (await _authG.signInWithCredential(credential));
    final FirebaseUser currentUser = await _authG.currentUser();
    if (currentUser != null) {
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where("id", isEqualTo: currentUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> document = result.documents;
      if (document.length == 0) {
        Firestore.instance
            .collection('users')
            .document(currentUser.uid)
            .setData({
          'id': currentUser.uid,
          'username': currentUser.displayName,
          'profilePicture': currentUser.photoUrl,
          'email': currentUser.email,
          'new': true
        });
      } else {}
    }
    print(result);
    _userG = result.user;

    setState(() {
      isSignIn = true;
      return _userG;
    });
  }

  // sign in cuchito
  final FirebaseAuth mAuth = FirebaseAuth.instance;
  FirebaseUser userC;
  Future logInWithCuchito() async {
    if (_formKey.currentState.validate()) {
      try {
        userC = await mAuth.signInWithEmailAndPassword(
            email: emailLogController.text,
            password: passLogController.text) as FirebaseUser;
      } catch (e) {
        print(e.toString());
      } finally {
        if (userC != null) {
          print('Usuario Logeado');
        }
      }
      setState(() {
        return userC;
      });
    }
  }
}

// login facebook