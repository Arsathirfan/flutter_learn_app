import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_ai_app/providers/account_provider.dart';
import 'package:flutter_ai_app/providers/forgot_password_provider.dart';
import 'package:flutter_ai_app/utils/app_shared_preference.dart';
import 'package:flutter_ai_app/utils/routes.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await AppSharedPreference.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friendly Meals',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppSharedPreference.getLoggedIn()
          ? Routes.home
          : Routes.account,
      routes: Routes.getRoutes(),
    );
  }
}
