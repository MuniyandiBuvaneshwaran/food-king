import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class DeliveryConfirmationScreen extends StatelessWidget {
  DeliveryConfirmationScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Confirmation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(Icons.inventory_2_outlined, size: 72),
              const SizedBox(height: 14),
              const Text(
                'Collect customer OTP to confirm delivery.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(labelText: '4-digit OTP'),
                validator: (value) => (value == null || value.length != 4)
                    ? 'Enter valid 4-digit OTP'
                    : null,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      Get.snackbar('Delivery confirmed', 'Order marked as delivered.');
                      Get.offAllNamed(AppRoutes.home);
                    }
                  },
                  icon: const Icon(Icons.verified_rounded),
                  label: const Text('Confirm Delivery'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
