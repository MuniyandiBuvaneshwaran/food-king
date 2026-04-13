import 'package:get/get.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/delivery_home_screen.dart';
import '../screens/order/order_detail_screen.dart';
import '../screens/history/delivery_history_screen.dart';
import '../screens/profile/delivery_profile_screen.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const home = '/home';
  static const orderDetail = '/order-detail';
  static const history = '/history';
  static const profile = '/profile';

  static final pages = [
    GetPage(name: splash, page: () => const DeliverySplashScreen()),
    GetPage(name: login, page: () => const DeliveryLoginScreen()),
    GetPage(name: home, page: () => const DeliveryHomeScreen()),
    GetPage(name: orderDetail, page: () => const DeliveryOrderDetailScreen()),
    GetPage(name: history, page: () => const DeliveryHistoryScreen()),
    GetPage(name: profile, page: () => const DeliveryProfileScreen()),
  ];
}

// Temporary stubs to avoid build errors in routing
class DeliverySplashScreen extends StatelessWidget {
  const DeliverySplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () => Get.offAllNamed(AppRoutes.login));
    return const Scaffold(body: Center(child: Text('FoodKing Delivery', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))));
  }
}
import 'package:flutter/material.dart';
class DeliveryLoginScreen extends StatelessWidget { const DeliveryLoginScreen({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Driver Login')), body: Center(child: ElevatedButton(onPressed: () => Get.offAllNamed(AppRoutes.home), child: const Text('Login')))); }
class DeliveryHomeScreen extends StatelessWidget { const DeliveryHomeScreen({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Today\'s Orders')), body: const Center(child: Text('Home'))); }
class DeliveryOrderDetailScreen extends StatelessWidget { const DeliveryOrderDetailScreen({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Order Details')), body: const Center(child: Text('Details'))); }
class DeliveryHistoryScreen extends StatelessWidget { const DeliveryHistoryScreen({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Past Deliveries')), body: const Center(child: Text('History'))); }
class DeliveryProfileScreen extends StatelessWidget { const DeliveryProfileScreen({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('My Profile')), body: const Center(child: Text('Profile'))); }
