import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountProvider extends ChangeNotifier {

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static bool isInitialize = false;

  static Future<void> initSignIn() async {

    if (!isInitialize) {
      await _googleSignIn.initialize(
        serverClientId:
        '690075272845-4hen5u7fud8pl8ta6f1ht1d9jsc0krbo.apps.googleusercontent.com',
      );
    }
    isInitialize = true;
  }

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      await initSignIn();
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final idToken = googleUser.authentication.idToken;
      final authorizationClient = googleUser.authorizationClient;
      GoogleSignInClientAuthorization? authorization = await authorizationClient.authorizationForScopes(['email', 'profile']);
      final accessToken = authorization?.accessToken;
      if (accessToken == null) {
        final authorization2 = await authorizationClient.authorizationForScopes(
          ['email', 'profile'],
        );
        if (authorization2?.accessToken == null) {
          throw FirebaseAuthException(code: "error", message: "error");
        }
        authorization = authorization2;
      }
      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      // if (user != null) {
      //   final userDoc = FirebaseFirestore.instance
      //       .collection('users')
      //       .doc(user.uid);
      //   final docSnapshot = await userDoc.get();
      //   if (!docSnapshot.exists) {
      //     await userDoc.set({
      //       'uid': user.uid,
      //       'name': user.displayName ?? '',
      //       'email': user.email ?? '',
      //       'photoURL': user.photoURL ?? '',
      //       'provider': 'google',
      //       'createdAt': FieldValue.serverTimestamp(),
      //     });
      //   }

      return userCredential;
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      throw e;
    }
  }
  // Get current user
  static User? getCurrentUser() {
    return _auth.currentUser;
  }
}
