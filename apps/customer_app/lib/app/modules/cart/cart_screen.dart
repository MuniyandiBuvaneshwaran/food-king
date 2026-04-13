import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_card.dart';

class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (controller.lines.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text('Your cart is empty')),
              )
            else
              ...controller.lines.map(
                (line) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SectionCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(line.name),
                      subtitle: Text('Qty ${line.quantity} • ${line.addons.join(', ')}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('\$${(line.price * line.quantity).toStringAsFixed(2)}'),
                          TextButton(
                            onPressed: () => controller.removeLine(line.id),
                            child: const Text('Remove'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            SectionCard(
              child: Column(
                children: [
                  _priceRow('Subtotal', controller.subtotal),
                  const SizedBox(height: 8),
                  _priceRow('Tax', controller.tax),
                  const Divider(height: 24),
                  _priceRow('Total', controller.total, bold: true),
                ],
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Proceed to Checkout',
              icon: Icons.payments_outlined,
              onPressed: controller.lines.isEmpty
                  ? null
                  : () => Get.toNamed(AppRoutes.checkout),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String label, double value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w600),
        ),
      ],
    );
  }
}
