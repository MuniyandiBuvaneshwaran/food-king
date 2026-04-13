import 'package:flutter/material.dart';

class DeliveryOrderDetailScreen extends StatelessWidget {
  const DeliveryOrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order ID: #O-1294', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                    Text('Oct 12, 12:45 PM', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Restaurant Info
                const _InfoSection(
                  title: 'PICKUP FROM',
                  name: 'The Burger Joint',
                  address: '15 Main Street, New York, NY',
                  icon: Icons.restaurant_rounded,
                  color: Color(0xFF3B82F6),
                ),
                
                const SizedBox(height: 20),
                const Center(child: Icon(Icons.arrow_downward_rounded, color: Color(0xFFE2E8F0))),
                const SizedBox(height: 20),
                
                // Customer Info
                const _InfoSection(
                  title: 'DELIVER TO',
                  name: 'Sarah Johnson',
                  address: '456 Park Avenue, Apt 12, New York, NY',
                  icon: Icons.location_on_rounded,
                  color: Color(0xFFF97316),
                ),
                
                const SizedBox(height: 32),
                
                // Items
                const Text('ORDER ITEMS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1)),
                const SizedBox(height: 12),
                _OrderItem(name: 'Chicken Burger', qty: 2),
                _OrderItem(name: 'Mango Smoothie', qty: 1),
                
                const SizedBox(height: 32),
                
                // Payment
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TOTAL EARNING', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    const Text('\$12.50', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xFF10B981))),
                  ],
                ),
              ],
            ),
          ),
          
          // Action button
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32)), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)]),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6), minimumSize: const Size(double.infinity, 56)),
                child: const Text('Start Delivery'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final String name;
  final String address;
  final IconData icon;
  final Color color;
  const _InfoSection({required this.title, required this.name, required this.address, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFF1F5F9))),
          child: Row(
            children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 20)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  Text(address, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrderItem extends StatelessWidget {
  final String name;
  final int qty;
  const _OrderItem({required this.name, required this.qty});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$qty x $name', style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF475569))),
          const Icon(Icons.check_circle_outline_rounded, size: 18, color: Color(0xFFCBD5E1)),
        ],
      ),
    );
  }
}
