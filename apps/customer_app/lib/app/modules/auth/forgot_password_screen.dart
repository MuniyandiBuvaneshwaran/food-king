import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/primary_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Registered email'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty || !value.contains('@')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              PrimaryButton(
                label: 'Send reset link',
                icon: Icons.mark_email_read_rounded,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Get.snackbar('Reset link sent', 'Please check your inbox');
                    Get.back();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
