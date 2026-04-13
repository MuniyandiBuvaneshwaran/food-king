import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class DeliveryLoginScreen extends StatefulWidget {
  const DeliveryLoginScreen({super.key});
  @override
  State<DeliveryLoginScreen> createState() => _DeliveryLoginScreenState();
}

class _DeliveryLoginScreenState extends State<DeliveryLoginScreen> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF3B82F6), Color(0xFF1E3A8A)]),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Column(children: [
                  Icon(Icons.delivery_dining_rounded, size: 80, color: Colors.white),
                  SizedBox(height: 16),
                  Text('FoodKing Delivery', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)),
                  Text('Partner Portal', style: TextStyle(color: Colors.white70, fontSize: 14)),
                ]),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
                  padding: const EdgeInsets.all(32),
                  child: SingleChildScrollView(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      const Text('Welcome back Partner!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                      const SizedBox(height: 4),
                      const Text('Sign in to your delivery account', style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8))),
                      const SizedBox(height: 32),
                      const TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.person_rounded, color: Color(0xFF3B82F6)), hintText: 'Driver ID / Email')),
                      const SizedBox(height: 16),
                      const TextField(obscureText: true, decoration: InputDecoration(prefixIcon: Icon(Icons.lock_rounded, color: Color(0xFF3B82F6)), hintText: 'Password')),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _loading ? null : () async {
                          setState(() => _loading = true);
                          await Future.delayed(const Duration(seconds: 1));
                          Get.offAllNamed(AppRoutes.home);
                        },
                        child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Login securely'),
                      ),
                      const SizedBox(height: 24),
                      Center(child: TextButton(onPressed: () {}, child: const Text('Forgot Driver ID?', style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.w700)))),
                      const SizedBox(height: 40),
                      const Text('By signing in, you agree to FoodKing Partner Terms.', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
