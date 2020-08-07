import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Registro extends StatefulWidget {
  @override
  _RegistroState createState() => _RegistroState();
}

final FirebaseAuth mAuth = FirebaseAuth.instance;

class _RegistroState extends State<Registro> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _email, _pass;
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
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 13.0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo Electronico',
                        labelStyle: theme.textTheme.caption
                            .copyWith(color: Colors.white, fontSize: 15.0),
                        icon: Icon(
                          FontAwesomeIcons.paperPlane,
                          color: Colors.white,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (input) =>
                          !input.contains('@') ? 'Ingrese un email' : null,
                      onSaved: (input) => _email = input,
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 13.0),
                    child: TextFormField(
                      controller: passController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: theme.textTheme.caption
                            .copyWith(color: Colors.white, fontSize: 15.0),
                        icon: Icon(
                          FontAwesomeIcons.userLock,
                          color: Colors.white,
                        ),
                      ),
                      validator: (input) =>
                          input.length < 6 ? 'Al menos 6 caracters' : null,
                      onSaved: (input) => _email = input,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      obscureText: true,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      signinEmailandPassoword();
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
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void signinEmailandPassoword() async {
    FirebaseUser user;
    if (_formKey.currentState.validate()) {
      try {
        user = (await mAuth.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passController.text)) as FirebaseUser;
      } catch (e) {
        print(e.toString());
      } finally {
        if (user != null) {
          print('usuario registrado');
        }
      }
    } else {
      _formKey.currentState.save();
      print(_email);
      print(_pass);
    }
  }
}
