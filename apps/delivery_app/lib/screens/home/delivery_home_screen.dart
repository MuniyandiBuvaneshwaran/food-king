import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class DeliveryHomeScreen extends StatelessWidget {
  const DeliveryHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Deliveries'),
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
          child: const Center(child: Text('AM', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 10, color: Color(0xFF3B82F6)))),
        ),
        actions: [
          IconButton(onPressed: () => Get.toNamed(AppRoutes.profile), icon: const Icon(Icons.person_outline_rounded)),
        ],
      ),
      body: Column(
        children: [
          // Today's Stats
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(label: 'Total Orders', value: '12', color: const Color(0xFF3B82F6)),
                _StatItem(label: 'Earnings', value: '\$142.50', color: const Color(0xFF10B981)),
                _StatItem(label: 'Rating', value: '4.8 ★', color: const Color(0xFFF59E0B)),
              ],
            ),
          ),
          
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          
          // Orders List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _orders.length,
              itemBuilder: (context, i) {
                final order = _orders[i];
                return _DeliveryOrderCard(order: order);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF3B82F6),
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          if (i == 1) Get.toNamed(AppRoutes.history);
          if (i == 2) Get.toNamed(AppRoutes.profile);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.delivery_dining_rounded), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
      ],
    );
  }
}

class _DeliveryOrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  const _DeliveryOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order['id'], style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF3B82F6))),
              Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(12)), child: Text(order['status'], style: const TextStyle(color: Color(0xFF0369A1), fontWeight: FontWeight.w800, fontSize: 10))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.restaurant_rounded, size: 16, color: Color(0xFF94A3B8)),
              const SizedBox(width: 8),
              Expanded(child: Text(order['restaurant'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_rounded, size: 16, color: Color(0xFF94A3B8)),
              const SizedBox(width: 8),
              Expanded(child: Text(order['address'], style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.toNamed(AppRoutes.orderDetail, arguments: order),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFE2E8F0)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  child: const Text('Details', style: TextStyle(color: Color(0xFF475569))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
                  child: const Text('Accept Order'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

const _orders = [
  {'id': '#O-1294', 'restaurant': 'The Burger Joint', 'address': '456 Park Avenue, Apt 12', 'status': 'Pending'},
  {'id': '#O-1301', 'restaurant': 'Pizza Palace', 'address': '789 Broadway St, Floor 4', 'status': 'Assigned'},
  {'id': '#O-1305', 'restaurant': 'Sushi Zen', 'address': '101 Fifth Ave, Room 201', 'status': 'Pending'},
];
