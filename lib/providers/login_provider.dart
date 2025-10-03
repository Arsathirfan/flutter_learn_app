import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_app/utils/app_shared_preference.dart';
import 'package:flutter_ai_app/utils/custom_dialog.dart';

class LoginProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<bool> signInWithEmailAndPassword() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;
      await user?.reload();

      if (user != null && !user.emailVerified) {
        _error = 'Please verify your email before logging in.';
        await _auth.signOut();
        notifyListeners();
        return false;
      }

      // Update Firestore that email is verified
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'isEmailVerified': true,
        'lastLogin': FieldValue.serverTimestamp(),
      });

      await AppSharedPreference.setLoggedIn(true);
      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.message ?? 'Login failed';
      notifyListeners();
      return false;
    }
  }

  Future<void> resendVerificationEmail(BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      await user?.sendEmailVerification();
      CustomDialog.show(context, 'Verification Email Sent',
          'A new verification email has been sent to your email address.');
    } catch (e) {
      CustomDialog.show(context, 'Error', e.toString());
      notifyListeners();
    }
  }

}