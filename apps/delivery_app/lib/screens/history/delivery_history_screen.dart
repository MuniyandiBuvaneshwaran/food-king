import 'package:flutter/material.dart';

class DeliveryHistoryScreen extends StatelessWidget {
  const DeliveryHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Past Deliveries')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _history.length,
        itemBuilder: (context, i) {
          final item = _history[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(14)),
                  child: const Center(child: Icon(Icons.check_circle_rounded, color: Color(0xFF22C55E), size: 24)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['id'], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                      Text(item['date'], style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                      Text(item['restaurant'], style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
                Text(
                  item['earning'],
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF10B981)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

const _history = [
  {'id': '#O-1280', 'date': 'Oct 11, 2026', 'restaurant': 'Sushi Zen', 'earning': '\$10.20'},
  {'id': '#O-1275', 'date': 'Oct 11, 2026', 'restaurant': 'Pizza Palace', 'earning': '\$14.50'},
  {'id': '#O-1268', 'date': 'Oct 10, 2026', 'restaurant': 'The Burger Joint', 'earning': '\$9.80'},
  {'id': '#O-1260', 'date': 'Oct 10, 2026', 'restaurant': 'Taco Bell', 'earning': '\$11.30'},
];
