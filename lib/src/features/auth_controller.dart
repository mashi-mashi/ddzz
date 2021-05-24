import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authControllerProvider = StateNotifierProvider<AuthController, User?>(
  (ref) => AuthController(initialUser: FirebaseAuth.instance.currentUser),
);

class AuthController extends StateNotifier<User?> {
  final _auth = FirebaseAuth.instance;
  User? get user => FirebaseAuth.instance.currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  AuthController({User? initialUser}) : super(initialUser) {
    _auth.userChanges().listen((user) {
      print('email ${user?.displayName?.toString()}');
      state = user;
    });
  }

  Future<User?> signInGoogle() async {
    try {
      final googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        return null;
      }

      final googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      //userのid取得
      final loginUser = (await _auth.signInWithCredential(credential)).user;

      if (loginUser == null) {
        throw ('');
      }
      final currentUser = _auth.currentUser;
      assert(loginUser.uid == currentUser?.uid);
      state = _auth.currentUser;

      return currentUser;
    } on PlatformException catch (err) {
      // https://github.com/flutter/flutter/issues/44431
      debugPrint('google login error ${err.toString()}');
      if (err.code == 'sign_in_canceled') {
        print('error sign_in_canceld ${err.toString()}');
      } else {
        rethrow;
      }
    }
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    await state?.delete();
    print('User Sign Out Google');
  }

  void clear() {}
}
