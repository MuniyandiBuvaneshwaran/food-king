import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifs.length,
        itemBuilder: (context, i) {
          final notif = _notifs[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: notif['read'] ? Colors.white : const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: notif['read'] ? const Color(0xFFF1F5F9) : const Color(0xFFF97316).withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: notif['color'].withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(notif['icon'], color: notif['color'], size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(notif['title'], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                          Text(notif['time'], style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(notif['body'], style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

const _notifs = [
  {'title': 'Order Out for Delivery', 'body': 'Alex is on the way with your order #13042599. Get ready!', 'time': '2m ago', 'icon': Icons.delivery_dining_rounded, 'color': Color(0xFFF97316), 'read': false},
  {'title': 'Promo Code Just for You!', 'body': 'Use code YUM30 to get 30% off on your next burger order.', 'time': '1h ago', 'icon': Icons.local_offer_rounded, 'color': Color(0xFFEC4899), 'read': false},
  {'title': 'Order Confirmed', 'body': 'Restaurant has accepted your order #13042599.', 'time': '20m ago', 'icon': Icons.check_circle_rounded, 'color': Color(0xFF22C55E), 'read': true},
  {'title': 'New Restaurant Alert', 'body': 'The Pizza Place is now open near you. Check out their menu!', 'time': '3h ago', 'icon': Icons.restaurant_rounded, 'color': Color(0xFF3B82F6), 'read': true},
];
