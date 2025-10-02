
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/forgot_password_provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ForgotPasswordProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final email = _emailController.text.trim();
                  if (email.isNotEmpty) {
                    context.read<ForgotPasswordProvider>().resetPassword(context, email);
                  }
                },
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      )
    );
  }
}
