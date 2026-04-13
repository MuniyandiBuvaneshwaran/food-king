import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/primary_button.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _couponController = TextEditingController();
  final _scheduleController = TextEditingController(text: 'Deliver now');
  String _paymentMethod = 'Cash on Delivery';

  final _paymentOptions = const [
    'Cash on Delivery',
    'Card',
    'UPI',
    'Wallet',
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Delivery address',
                  hintText: 'House no, street, city',
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 10) {
                    return 'Address must be at least 10 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _scheduleController,
                decoration: const InputDecoration(
                  labelText: 'Schedule',
                  hintText: 'Deliver now or set time',
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Schedule is required'
                    : null,
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                decoration: const InputDecoration(labelText: 'Payment gateway'),
                items: _paymentOptions
                    .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                    .toList(),
                onChanged: (value) => setState(() => _paymentMethod = value ?? _paymentMethod),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _couponController,
                decoration: const InputDecoration(
                  labelText: 'Coupon code',
                  hintText: 'Optional',
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 4) {
                    return 'Invalid coupon code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Payable amount: \$${cart.total.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Place Order',
                icon: Icons.check_circle_outline_rounded,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Get.snackbar('Order placed', 'Your mock order has been submitted.');
                    Get.toNamed(AppRoutes.orderTracking);
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
