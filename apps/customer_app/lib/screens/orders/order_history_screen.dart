import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _orders.length,
        itemBuilder: (context, i) {
          final order = _orders[i];
          return _OrderCard(order: order);
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final isActive = ['Pending', 'Confirmed', 'Preparing', 'Out for Delivery'].contains(order['status']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isActive ? const Color(0xFFF97316).withOpacity(0.3) : const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order ID ${order['id']}',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF94A3B8)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(order['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order['status'],
                  style: TextStyle(
                    color: _getStatusColor(order['status']),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 50, height: 50,
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
                child: Center(child: Text(order['emoji'], style: const TextStyle(fontSize: 28))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['summary'],
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${order['date']} · ${order['itemCount']} items',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${order['total']}',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFFF97316)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (isActive)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.toNamed(AppRoutes.orderTracking, arguments: order),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                    child: const Text('Track Order'),
                  ),
                )
              else
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Reorder', style: TextStyle(color: Color(0xFF475569))),
                  ),
                ),
              const SizedBox(width: 12),
              if (!isActive)
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Give Feedback', style: TextStyle(color: Color(0xFFF97316), fontWeight: FontWeight.w700)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Delivered': return const Color(0xFF22C55E);
      case 'Out for Delivery': return const Color(0xFF3B82F6);
      case 'Preparing': return const Color(0xFFF59E0B);
      case 'Cancelled': return Colors.redAccent;
      default: return const Color(0xFF94A3B8);
    }
  }
}

const _orders = [
  {'id': '#13042599', 'date': 'Today, 2:00 PM', 'status': 'Out for Delivery', 'summary': 'Chicken Burger, Mango Smoothie', 'emoji': '🍔', 'itemCount': 3, 'total': '36.16'},
  {'id': '#13042450', 'date': 'Apr 11, 2026', 'status': 'Delivered', 'summary': 'Salmon Sushi Roll', 'emoji': '🍱', 'itemCount': 1, 'total': '18.50'},
  {'id': '#13042301', 'date': 'Apr 9, 2026', 'status': 'Delivered', 'summary': 'Pasta Carbonara, Salad', 'emoji': '🍝', 'itemCount': 2, 'total': '23.00'},
  {'id': '#13042100', 'date': 'Apr 7, 2026', 'status': 'Cancelled', 'summary': 'BBQ Bacon Burger', 'emoji': '🍔', 'itemCount': 1, 'total': '13.99'},
];
