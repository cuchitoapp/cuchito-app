import 'package:cuchitoapp/screens/feed.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login1 extends StatefulWidget {
  @override
  _Login1State createState() => _Login1State();
}

class _Login1State extends State<Login1> {
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
          Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Usuario',
                        labelStyle: theme.textTheme.caption
                            .copyWith(color: Colors.white, fontSize: 15.0),
                        icon: Icon(
                          Icons.person_add,
                          color: Colors.white,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (input) =>
                          input.isEmpty ? 'Ingrese su nombre de usuario' : null,
                      onSaved: (input) => _usuario = input,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: theme.textTheme.caption
                            .copyWith(color: Colors.white, fontSize: 15.0),
                        icon: Icon(
                          Icons.enhanced_encryption,
                          color: Colors.white,
                        ),
                      ),
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
                    child: Icon(FontAwesomeIcons.google),
                    backgroundColor: Color(0xff4285F4),
                  ),
                  FloatingActionButton(
                    child: Icon(FontAwesomeIcons.twitter),
                    backgroundColor: Color(0xff00aced),
                  ),
                  FloatingActionButton(
                    backgroundColor: Color(0xff3b5998),
                    child: Icon(FontAwesomeIcons.facebook),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}