import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuchitoapp/registro/registroPetC.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Registro extends StatefulWidget {
  static final String id = 'registro';
  @override
  _RegistroState createState() => _RegistroState();
}

final FirebaseAuth mAuth = FirebaseAuth.instance;
bool signIn = false;

class _RegistroState extends State<Registro> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passConfirmController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _email, _pass, _confirmpass;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
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
          Form(
            key: _formKey,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo Electronico',
                        labelStyle: theme.textTheme.caption
                            .copyWith(color: Colors.white, fontSize: 13.0),
                        icon: Icon(
                          FontAwesomeIcons.envelope,
                          color: Colors.white,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (input) => !input.contains('@')
                          ? 'Ingrese un email valido'
                          : null,
                      onSaved: (input) => _email = input,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre de usuario',
                        labelStyle: theme.textTheme.caption
                            .copyWith(color: Colors.white, fontSize: 13.0),
                        icon: Icon(
                          FontAwesomeIcons.user,
                          color: Colors.white,
                        ),
                      ),
                      validator: (input) =>
                          input.isEmpty ? 'ingrese su nombre' : null,
                      onSaved: (input) => _pass = input,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    child: TextFormField(
                      controller: passController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: theme.textTheme.caption
                            .copyWith(color: Colors.white, fontSize: 13.0),
                        icon: Icon(
                          FontAwesomeIcons.userLock,
                          color: Colors.white,
                        ),
                      ),
                      validator: (input) => input.trim().length < 6
                          ? 'Al menos 6 caracters'
                          : null,
                      onSaved: (input) => _pass = input,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                      obscureText: true,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    child: TextFormField(
                      controller: passConfirmController,
                      decoration: InputDecoration(
                        labelText: 'Confirme su contraseña',
                        labelStyle: theme.textTheme.caption
                            .copyWith(color: Colors.white, fontSize: 13.0),
                        icon: Icon(
                          FontAwesomeIcons.key,
                          color: Colors.white,
                        ),
                      ),
                      validator: (_pass) =>
                          passController.text != passConfirmController.text
                              ? 'Las contraseñas deben coincidir'
                              : null,
                      onSaved: (input) => _confirmpass = input,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                      obscureText: true,
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 35,
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          signinEmailandPassoword()
                              .whenComplete(() => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterPetC(
                                      name: nameController.text,
                                    ),
                                  )));
                        }
                      },
                      color: Colors.green,
                      child: Text(
                        'Registrarme',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  FirebaseUser _user;
  Future signinEmailandPassoword() async {
    if (_pass == _confirmpass) {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passConfirmController.text)
          .then((currentUser) => Firestore.instance
              .collection("users")
              .document(currentUser.user.uid)
              .setData({
                "email": emailController.text,
                "id": currentUser.user.uid,
                'username': nameController.text,
                'new': true
              })
              .then((result) => {
                    emailController.clear(),
                    nameController.clear(),
                    passController.clear(),
                    passConfirmController.clear(),
                  })
              .catchError((err) => print(err)))
          .catchError((err) => print(err));
    }

    _formKey.currentState.save();
    print(_email);
    print(_pass);
    print(_confirmpass);

    setState(() {
      signIn = true;
      return _user;
    });
  }
}
