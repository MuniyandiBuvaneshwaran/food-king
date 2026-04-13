import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/app_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/section_card.dart';

class ProfileScreen extends GetView<AppController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: const Icon(Icons.person_rounded, size: 30),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Buvanesh R', style: TextStyle(fontWeight: FontWeight.w700)),
                      Text('buvanesh@foodking.com'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Obx(
            () => SwitchListTile(
              value: controller.themeMode.value == ThemeMode.dark,
              title: const Text('Dark mode'),
              subtitle: const Text('Switch light / dark UI'),
              onChanged: (_) => controller.toggleTheme(),
            ),
          ),
          Obx(
            () => SwitchListTile(
              value: controller.locale.value.languageCode == 'ar',
              title: const Text('RTL (Arabic)'),
              subtitle: const Text('Toggle layout direction'),
              onChanged: (_) => controller.toggleLocale(),
            ),
          ),
          const Divider(height: 28),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text('Addresses'),
            onTap: () => Get.toNamed(AppRoutes.addresses),
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined),
            title: const Text('E-wallet'),
            onTap: () => Get.toNamed(AppRoutes.wallet),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_none_rounded),
            title: const Text('Notifications'),
            onTap: () => Get.toNamed(AppRoutes.notifications),
          ),
          ListTile(
            leading: const Icon(Icons.chat_bubble_outline_rounded),
            title: const Text('Restaurant Chat'),
            onTap: () => Get.toNamed(AppRoutes.chat),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: const Text('Order history'),
            onTap: () => Get.toNamed(AppRoutes.orderHistory),
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () => Get.offAllNamed(AppRoutes.login),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
