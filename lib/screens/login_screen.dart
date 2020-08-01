import 'package:cuchitoapp/screens/feed.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _usuario, _pass;
  _submit() {
    if (_formKey.currentState.validate()) {
      if (_usuario == 'cuchito' && _pass == '1234') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.red[50],
              title: new Text(
                'Bienvenido',
                style: TextStyle(
                  fontFamily: 'Billabong',
                  fontSize: 48.0,
                ),
              ),
              content: new Text(
                "Bienvenido: " + _usuario,
                style: TextStyle(fontFamily: 'Billabong', fontSize: 20.0),
              ),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Continuar"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Feed()),
                    );
                  },
                ),
              ],
            );
          },
        );
      } else {
        _formKey.currentState.save();
        print(_usuario);
        print(_pass);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'CuhitoAPP',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 48.0,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Usuario'),
                      validator: (input) =>
                          input.isEmpty ? 'Ingrese su nombre de usuario' : null,
                      onSaved: (input) => _usuario = input,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Contraseña'),
                      validator: (input) => input.trim().isEmpty
                          ? 'Debe ingresar alguna contraseña'
                          : null,
                      onSaved: (input) => _pass = input,
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    width: 250.0,
                    child: FlatButton(
                      onPressed: _submit,
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
          ],
        ),
      ),
    );
  }
}
