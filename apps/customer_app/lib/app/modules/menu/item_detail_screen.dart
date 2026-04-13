import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../data/mock_data.dart';
import '../../routes/app_routes.dart';
import '../../widgets/primary_button.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({super.key});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final _addons = {
    'Extra Cheese': false,
    'French Fries': false,
    'Spicy Sauce': false,
  };
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final item = (Get.arguments as MockFoodItem?) ?? MockData.foodItems.first;

    return Scaffold(
      appBar: AppBar(title: const Text('Item Detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: const Icon(Icons.local_pizza_rounded, size: 84),
          ),
          const SizedBox(height: 16),
          Text(item.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('${item.category} • ${item.rating.toStringAsFixed(1)} ?'),
          const SizedBox(height: 10),
          Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          const Text('Select Add-ons', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          ..._addons.entries.map(
            (entry) => CheckboxListTile(
              value: entry.value,
              title: Text(entry.key),
              subtitle: const Text('+\$1.00'),
              onChanged: (value) => setState(() => _addons[entry.key] = value ?? false),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Quantity', style: TextStyle(fontWeight: FontWeight.w700)),
              Row(
                children: [
                  IconButton(
                    onPressed: _quantity > 1 ? () => setState(() => _quantity -= 1) : null,
                    icon: const Icon(Icons.remove_circle_outline_rounded),
                  ),
                  Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  IconButton(
                    onPressed: () => setState(() => _quantity += 1),
                    icon: const Icon(Icons.add_circle_outline_rounded),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: 'Add to Cart',
            icon: Icons.shopping_cart_checkout_rounded,
            onPressed: () {
              final selectedAddons = _addons.entries
                  .where((entry) => entry.value)
                  .map((entry) => entry.key)
                  .toList();
              Get.find<CartController>().addLine(
                CartLine(
                  id: DateTime.now().millisecondsSinceEpoch,
                  name: item.name,
                  price: item.price + (selectedAddons.length * 1.0),
                  quantity: _quantity,
                  addons: selectedAddons,
                ),
              );
              Get.snackbar('Added to cart', item.name);
              Get.toNamed(AppRoutes.cart);
            },
          ),
        ],
      ),
    );
  }
}
