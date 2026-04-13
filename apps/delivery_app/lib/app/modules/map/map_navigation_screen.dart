import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class MapNavigationScreen extends StatelessWidget {
  const MapNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map Navigation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFCCE9E2), Color(0xFFEEF8F5)],
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map_rounded, size: 72),
                    SizedBox(height: 8),
                    Text('Mock map view\n(use real maps package later)', textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Get.toNamed(AppRoutes.deliveryConfirmation),
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: const Text('Reached Customer Location'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
