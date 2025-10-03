import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_app/utils/app_shared_preference.dart';

class SignupProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> signUpWithEmailAndPassword() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;

      if (user != null) {
        await user.sendEmailVerification();

        // Save user details in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': nameController.text, // Add name here
          'createdAt': FieldValue.serverTimestamp(),
          'isEmailVerified': false, // initially false
        });

        _error = 'A verification email has been sent to your email address.';
      }

      // Don’t set logged in yet — wait until verification
      await AppSharedPreference.setLoggedIn(false);

      _isLoading = false;
      notifyListeners();

      // Return true but show "Check your email" UI
      return true;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error : $e');
      if (e.code == 'weak-password') {
        _error = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        _error = 'The account already exists for that email.';
      } else {
        _error = e.message ?? 'An authentication error occurred.';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } on FirebaseException catch (e) {

      print('Firebase Exception Error : $e');

      print('Firebase Firestore Error : $e');
      _error = 'Firestore error: ${e.message}';
      // Optionally, delete the created auth user if Firestore write fails
      await _auth.currentUser?.delete();
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print('General Error : $e');
      _error = 'An unexpected error occurred: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> resendVerificationEmail() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }
}
