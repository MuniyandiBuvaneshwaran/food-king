import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/mock_data.dart';
import '../../routes/app_routes.dart';
import '../../widgets/section_card.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = (Get.arguments as DeliveryOrder?) ?? DeliveryMockData.assignedOrders.first;

    return Scaffold(
      appBar: AppBar(title: const Text('Order Detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order ${order.id}', style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text('Customer: ${order.customer}'),
                Text('Address: ${order.address}'),
                Text('Status: ${order.status}'),
                Text('Amount: \$${order.amount.toStringAsFixed(2)}'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Items', style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(height: 8),
                Text('1x Chicken Burger'),
                Text('2x Fries'),
                Text('1x Cola'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.map),
            icon: const Icon(Icons.map_outlined),
            label: const Text('Open Map Navigation'),
          ),
        ],
      ),
    );
  }
}
