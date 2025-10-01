import 'package:flutter/material.dart';
import 'package:flutter_ai_app/pages/account_screen.dart';
import 'package:flutter_ai_app/pages/login_screen.dart';
import 'package:flutter_ai_app/pages/recipe_generator.dart';
import 'package:flutter_ai_app/pages/signup_screen.dart';

class Routes {
  static const String account = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      account: (context) => const AccountScreen(),
      home: (context) => const RecipeGeneratorScreen(),
      login: (context) => const LoginScreen(),
      signup: (context) => const SignupScreen(),
    };
  }
}
