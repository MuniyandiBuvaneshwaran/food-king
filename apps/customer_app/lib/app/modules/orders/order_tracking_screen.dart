import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const statuses = [
      ('Order placed', true),
      ('Restaurant accepted', true),
      ('Preparing your meal', true),
      ('Rider picked up order', false),
      ('Delivered', false),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracking')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Order #FK-2205', style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(height: 4),
                  Text('Estimated delivery: 28 min'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...statuses.asMap().entries.map(
            (entry) {
              final item = entry.value;
              final isLast = entry.key == statuses.length - 1;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Icon(
                        item.$2 ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                        color: item.$2 ? Colors.green : Colors.grey,
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 46,
                          color: item.$2 ? Colors.green : Colors.grey.shade300,
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      item.$1,
                      style: TextStyle(
                        fontWeight: item.$2 ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
