
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ai_app/utils/custom_dialog.dart';

class ForgotPasswordProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      CustomDialog.show(context, 'Password Reset', 'Password reset email sent. Please check your inbox.');
    } on FirebaseAuthException catch (e) {
      CustomDialog.show(context, 'Password Reset Failed', e.message ?? 'An unknown error occurred.');
    }
  }
}
