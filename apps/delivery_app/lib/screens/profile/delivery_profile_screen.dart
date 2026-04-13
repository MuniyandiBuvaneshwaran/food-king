import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class DeliveryProfileScreen extends StatelessWidget {
  const DeliveryProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Partner Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Header section
          Center(
            child: Column(children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF1E3A8A)]),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: const Center(child: Text('AM', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white))),
              ),
              const SizedBox(height: 16),
              const Text('Alex Martinez', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
              const Text('Partner ID: DRV-44210', style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8))),
            ]),
          ),
          
          const SizedBox(height: 32),
          
          // Availability Toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(color: const Color(0xFFF0F9FF), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFBAE6FD))),
            child: Row(
              children: [
                const Icon(Icons.circle, color: Color(0xFF10B981), size: 12),
                const SizedBox(width: 12),
                const Expanded(child: Text('Online & Accepting Orders', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF0369A1)))),
                Switch(value: true, onChanged: (v) {}, activeColor: const Color(0xFF3B82F6)),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          _MenuTile(icon: Icons.account_balance_wallet_outlined, label: 'Earnings Dashboard', value: '\$842.00', onTap: () {}),
          _MenuTile(icon: Icons.history_rounded, label: 'Delivery History', onTap: () => Get.toNamed(AppRoutes.history)),
          _MenuTile(icon: Icons.star_outline_rounded, label: 'Ratings & Feedback', value: '4.8★', onTap: () {}),
          _MenuTile(icon: Icons.settings_outlined, label: 'App Settings', onTap: () {}),
          _MenuTile(icon: Icons.help_outline_rounded, label: 'Partner Support', onTap: () {}),
          
          const SizedBox(height: 24),
          _MenuTile(icon: Icons.logout_rounded, label: 'Logout', color: Colors.redAccent, onTap: () => Get.offAllNamed(AppRoutes.login)),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;
  final Color color;
  const _MenuTile({required this.icon, required this.label, this.value, required this.onTap, this.color = const Color(0xFF475569)});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color, size: 22),
      title: Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: color == Colors.redAccent ? color : const Color(0xFF1E293B))),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null) Text(value!, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF3B82F6), fontSize: 14)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFFCBD5E1)),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    );
  }
}
