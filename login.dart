import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuchitoapp/models/user.dart';
import 'package:cuchitoapp/screens/CreateAccountPage.dart';
import 'package:cuchitoapp/screens/GoogleMapScreen.dart';
import 'package:cuchitoapp/screens/NotificationsPage.dart';
import 'package:cuchitoapp/screens/ProfilePage.dart';
import 'package:cuchitoapp/screens/SearchPage.dart';
import 'package:cuchitoapp/screens/TimeLinePage.dart';
import 'package:cuchitoapp/screens/UploadPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final usersReference = Firestore.instance.collection('users');
final timelineRefrence = Firestore.instance.collection("timeline");
final StorageReference storageReference =
    FirebaseStorage.instance.ref().child("Posts Pictures");
final postsReference = Firestore.instance.collection("posts");
final activityFeedReference = Firestore.instance.collection("feed");
final commentsRefrence = Firestore.instance.collection("comments");
final followersRefrence = Firestore.instance.collection("followers");
final followingRefrence = Firestore.instance.collection("following");
final DateTime timestamp = DateTime.now();
User currentUser;

class Login extends StatefulWidget {
  static final String id = 'login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isSignIn = false;
  PageController pageController;
  int getPageIndex = 0;

  void initState() {
    super.initState();

    pageController = PageController();

    _googleSignIn.onCurrentUserChanged.listen((gSigninAccount) {
      controlSignIn(gSigninAccount);
    }, onError: (gError) {
      print("Error Message: " + gError);
    });

    _googleSignIn
      ..signInSilently(suppressErrors: false).then((gSignInAccount) {
        controlSignIn(gSignInAccount);
      }).catchError((gError) {
        print("Error Message: " + gError);
      });
  }

  controlSignIn(GoogleSignInAccount gSigninAccount) async {
    if (gSigninAccount != null) {
      await saveUserInforFireStore();
      setState(() {
        isSignIn = true;
      });
    } else {
      isSignIn = false;
    }
  }

  saveUserInforFireStore() async {
    final GoogleSignInAccount gCurrentUser = _googleSignIn.currentUser;
    DocumentSnapshot documentSnapshot =
        await usersReference.document(gCurrentUser.id).get();
    if (!documentSnapshot.exists) {
      final username = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => CreateAccountPage()));

      usersReference.document(gCurrentUser.id).setData({
        "id": gCurrentUser.id,
        "profileName": gCurrentUser.displayName,
        "username": username,
        "url": gCurrentUser.photoUrl,
        "email": gCurrentUser.email,
        "bio": "",
        "timestamp": timestamp,
      });
      await followersRefrence
          .document(gCurrentUser.id)
          .collection("userFollowers")
          .document(gCurrentUser.id)
          .setData({});

      documentSnapshot = await usersReference.document(gCurrentUser.id).get();
    }
    currentUser = User.fromDocument(documentSnapshot);
  }

  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  logInUser() {
    _googleSignIn.signIn();
  }

  logoutUser() {
    _googleSignIn.signOut();
  }

  whenPageChanges(int pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  onTapChangePage(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 400), curve: Curves.bounceInOut);
  }

  buildHomeScreen() {
    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Advertencia'),
          content: Text('Quieres salir de Cuchito?'),
          actions: [
            FlatButton(
              child: Text('Si'),
              onPressed: () => SystemNavigator.pop(),
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(c, false),
            ),
          ],
        ),
      ),
      child: Scaffold(
        body: PageView(
          children: [
            UploadPage(
              gCurrentUser: currentUser,
            ),
            SearchPage(),
            TimeLinePage(gCurrentUser: currentUser),
            NotificationsPage(),
            ProfilePage(userProfileId: currentUser?.id),
          ],
          controller: pageController,
          onPageChanged: whenPageChanges,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: CupertinoTabBar(
          currentIndex: getPageIndex,
          onTap: onTapChangePage,
          backgroundColor: Theme.of(context).accentColor,
          activeColor: Colors.white,
          inactiveColor: Colors.blueGrey,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
              Icons.photo_camera,
              size: 37.0,
            )),
            BottomNavigationBarItem(icon: Icon(Icons.search)),
            BottomNavigationBarItem(icon: Icon(Icons.home)),
            BottomNavigationBarItem(icon: Icon(Icons.favorite)),
            BottomNavigationBarItem(icon: Icon(Icons.person)),
          ],
        ),
      ),
    );
  }

  buildSignInScreen() {
    // APLICACION Y VISTAS EN SI
    final _formKey = GlobalKey<FormState>();
    String _usuario, _pass;
    TextEditingController emailLogController = new TextEditingController();
    TextEditingController passLogController = new TextEditingController();
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
              onPressed: () => SystemNavigator.pop(),
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
                        onPressed: () {},
                        color: Colors.white,
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
                      onPressed:
                          null, /* () {
                        Navigator.pushNamed(context, Registro.id);
                      }, */
                    ),
                    FloatingActionButton(
                      heroTag: 'google',
                      child: Icon(FontAwesomeIcons.google),
                      backgroundColor: Color(0xff4285F4),
                      onPressed: () {
                        handleSignIn();
                      },
                    ),
                    FloatingActionButton(
                      heroTag: 'facebook',
                      backgroundColor: Color(0xff3b5998),
                      child: Icon(FontAwesomeIcons.facebook),
                      onPressed: () {
                        handleSignIn();

                        /* SnackBar(
                          content: Text('hola'),
                        );*/
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

  @override
  Widget build(BuildContext context) {
    if (isSignIn == true) {
      return buildHomeScreen();
    } else {
      return buildSignInScreen();
    }
  }

// Login Google
  FirebaseAuth _authG = FirebaseAuth.instance;

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
      Firestore.instance
          .collection('users')
          .where("id", isEqualTo: currentUser.uid)
          .getDocuments();
    }
    print(result);

    setState(() {
      isSignIn = true;
    });
  }

  // sign in cuchito

}
