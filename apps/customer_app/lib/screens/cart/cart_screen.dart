import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cartItems.length,
              itemBuilder: (context, i) {
                final item = _cartItems[i];
                return _CartItemTile(item: item);
              },
            ),
          ),
          _CartSummary(),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFFF7ED), Color(0xFFFFF1F2)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: Text(item['emoji'], style: const TextStyle(fontSize: 32))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 2),
                Text(
                  item['addons'],
                  style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 10),
                Text(
                  '\$${item['price']}',
                  style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFFF97316), fontSize: 16),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    const Icon(Icons.remove_rounded, size: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('${item['qty']}', style: const TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    const Icon(Icons.add_rounded, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SummaryRow(label: 'Subtotal', value: '\$33.48'),
            const _SummaryRow(label: 'Delivery Fee', value: 'FREE', isFree: true),
            const _SummaryRow(label: 'Tax (8%)', value: '\$2.68'),
            const Divider(height: 32),
            const _SummaryRow(label: 'Total', value: '\$36.16', isBold: true),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.toNamed(AppRoutes.checkout),
                child: const Text('Checkout Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isFree;
  const _SummaryRow({required this.label, required this.value, this.isBold = false, this.isFree = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isBold ? const Color(0xFF1E293B) : const Color(0xFF94A3B8), fontWeight: isBold ? FontWeight.w800 : FontWeight.w500, fontSize: isBold ? 16 : 14)),
          Text(value, style: TextStyle(color: isFree ? const Color(0xFF22C55E) : isBold ? const Color(0xFFF97316) : const Color(0xFF1E293B), fontWeight: isBold ? FontWeight.w900 : FontWeight.w700, fontSize: isBold ? 20 : 14)),
        ],
      ),
    );
  }
}

const _cartItems = [
  {'name': 'Chicken Burger', 'emoji': '🍔', 'price': '12.99', 'qty': 2, 'addons': 'Extra Cheese'},
  {'name': 'Mango Smoothie', 'emoji': '🥤', 'price': '5.50', 'qty': 1, 'addons': ''},
  {'name': 'Choc Lava Cake', 'emoji': '🍰', 'price': '7.99', 'qty': 1, 'addons': ''},
];
