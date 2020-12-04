import 'package:cuchitoapp/registro/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final googleSignIn = GoogleSignIn();

Future<bool> signin(String email, String password) async {
  try {
    AuthResult result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    //FirebaseUser user = result.user;
    return Future.value(true);
  } catch (e) {
    switch (e.code) {
      case 'ERROR_INVALID_EMAIL':
        print('serror');
    }
  }
}

Future<bool> singUp(String email, String password) async {
  try {
    AuthResult result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    //FirebaseUser user = result.user;
    return Future.value(true);
  } catch (e) {
    switch (e.code) {
      case 'ERROR_EMAIL_ALLREADY_IN_USE':
        print('serror');
    }
  }
}
