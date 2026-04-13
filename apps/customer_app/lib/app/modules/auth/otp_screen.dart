import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../widgets/primary_button.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Enter 6-digit OTP sent to your phone.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(labelText: 'OTP code'),
                validator: (value) {
                  if (value == null || value.length != 6) {
                    return 'Enter a valid 6-digit OTP';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'Verify OTP',
                icon: Icons.verified_user_rounded,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Get.offAllNamed(AppRoutes.home);
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
