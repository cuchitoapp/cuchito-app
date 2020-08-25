import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final FirebaseAuth mAuth = FirebaseAuth.instance;
bool signIn = false;

class RegisterPetC extends StatelessWidget {
  final String nameController, emailController, passController;

  const RegisterPetC(
      {Key key,
      @required this.nameController,
      @required this.emailController,
      @required this.passController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nombreMascotaController = new TextEditingController();
    TextEditingController especieController = new TextEditingController();
    TextEditingController edadController = new TextEditingController();
    TextEditingController cuidadController = new TextEditingController();
    TextEditingController sexoController = new TextEditingController();
    TextEditingController razaController = new TextEditingController();

    final theme = Theme.of(context);
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.grey),
          ),
          Form(
            key: formKey,
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      child: TextFormField(
                        controller: nombreMascotaController,
                        decoration: InputDecoration(
                          labelText: 'Nombre de tu mascota',
                          labelStyle: theme.textTheme.caption
                              .copyWith(color: Colors.white, fontSize: 13.0),
                          icon: Icon(
                            FontAwesomeIcons.paw,
                            color: Colors.white,
                          ),
                        ),
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      child: TextFormField(
                        controller: especieController,
                        decoration: InputDecoration(
                          labelText: 'Especie',
                          labelStyle: theme.textTheme.caption
                              .copyWith(color: Colors.white, fontSize: 13.0),
                          icon: Icon(
                            FontAwesomeIcons.cat,
                            color: Colors.white,
                          ),
                        ),
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      child: TextFormField(
                        controller: edadController,
                        decoration: InputDecoration(
                          labelText: 'Edad',
                          labelStyle: theme.textTheme.caption
                              .copyWith(color: Colors.white, fontSize: 13.0),
                          icon: Icon(
                            FontAwesomeIcons.userLock,
                            color: Colors.white,
                          ),
                        ),
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      child: TextFormField(
                        controller: cuidadController,
                        decoration: InputDecoration(
                          labelText: 'Cuidad',
                          labelStyle: theme.textTheme.caption
                              .copyWith(color: Colors.white, fontSize: 13.0),
                          icon: Icon(
                            FontAwesomeIcons.city,
                            color: Colors.white,
                          ),
                        ),
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      child: TextFormField(
                        controller: sexoController,
                        decoration: InputDecoration(
                          labelText: 'Sexo',
                          labelStyle: theme.textTheme.caption
                              .copyWith(color: Colors.white, fontSize: 13.0),
                          icon: Icon(
                            FontAwesomeIcons.key,
                            color: Colors.white,
                          ),
                        ),
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      child: TextFormField(
                        controller: razaController,
                        decoration: InputDecoration(
                          labelText: 'Raza',
                          labelStyle: theme.textTheme.caption
                              .copyWith(color: Colors.white, fontSize: 13.0),
                          icon: Icon(
                            FontAwesomeIcons.key,
                            color: Colors.white,
                          ),
                        ),
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                    Container(
                      width: 200,
                      height: 35,
                      child: RaisedButton(
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: emailController,
                                    password: passController)
                                .then((currentUser) => Firestore.instance
                                    .collection("users")
                                    .document(currentUser.user.uid)
                                    .setData({
                                      "email": emailController,
                                      "id": currentUser.user.uid,
                                      'username': nameController,
                                      'Nombre mascota':
                                          nombreMascotaController.text,
                                      'Especie': especieController.text,
                                      'Edad': edadController.text,
                                      'Cuidad': cuidadController.text,
                                      'Sexo': sexoController.text,
                                      'Raza': razaController.text,
                                    })
                                    .then((result) => {
                                          nombreMascotaController.clear(),
                                          especieController.clear(),
                                          edadController.clear(),
                                          cuidadController.clear(),
                                          sexoController.clear(),
                                          razaController.clear(),
                                        })
                                    .catchError((err) => print(err)))
                                .catchError((err) => print(err));
                          }
                        },
                        color: Colors.green,
                        child: Text(
                          'Registrar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
