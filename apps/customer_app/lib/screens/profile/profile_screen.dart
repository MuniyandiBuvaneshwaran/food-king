import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Header section
          Center(
            child: Column(children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFF97316), Color(0xFFE11D48)]),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: const Color(0xFFF97316).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: const Center(child: Text('SJ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white))),
              ),
              const SizedBox(height: 16),
              const Text('Sarah Johnson', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
              const Text('sarah.j@example.com', style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8))),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(20)),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                    SizedBox(width: 4),
                    Text('Gold Member', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                  ],
                ),
              ),
            ]),
          ),
          
          const SizedBox(height: 40),
          
          // Wallet Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)]),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: const Color(0xFF4F46E5).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 6))],
            ),
            child: Row(children: [
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Available Balance', style: TextStyle(color: Colors.white70, fontSize: 13)),
                SizedBox(height: 4),
                Text('\$125.50', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
              ]),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF4F46E5), padding: const EdgeInsets.symmetric(horizontal: 16)),
                child: const Text('Top Up'),
              ),
            ]),
          ),

          const SizedBox(height: 32),
          
          // Menu List
          _ProfileMenuTile(icon: Icons.person_outline_rounded, label: 'Edit Profile', onTap: () {}),
          _ProfileMenuTile(icon: Icons.location_on_outlined, label: 'Saved Addresses', onTap: () => Get.toNamed(AppRoutes.addresses)),
          _ProfileMenuTile(icon: Icons.history_rounded, label: 'Order History', onTap: () => Get.toNamed(AppRoutes.orders)),
          _ProfileMenuTile(icon: Icons.notifications_none_rounded, label: 'Notifications', onTap: () => Get.toNamed(AppRoutes.notifications)),
          _ProfileMenuTile(icon: Icons.help_outline_rounded, label: 'Help & Support', onTap: () {}),
          _ProfileMenuTile(icon: Icons.info_outline_rounded, label: 'About FoodKing', onTap: () {}),
          
          const SizedBox(height: 24),
          
          _ProfileMenuTile(icon: Icons.logout_rounded, label: 'Logout', color: Colors.redAccent, onTap: () => Get.offAllNamed(AppRoutes.login)),
          
          const SizedBox(height: 40),
          const Center(child: Text('Version 1.0.0', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12))),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  const _ProfileMenuTile({required this.icon, required this.label, required this.onTap, this.color = const Color(0xFF475569)});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: color == Colors.redAccent ? color : const Color(0xFF1E293B))),
      trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFFCBD5E1)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
