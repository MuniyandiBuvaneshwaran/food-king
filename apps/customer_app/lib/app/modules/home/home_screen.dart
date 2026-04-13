import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/mock_data.dart';
import '../../routes/app_routes.dart';
import '../../widgets/section_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final featured = MockData.foodItems.where((item) => item.isFeatured).take(6).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('FoodKing Home'),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.notifications),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.cart),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hungry?\nLet us deliver fast.',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 8),
                      Text('Free delivery above \$20'),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: const Icon(Icons.ramen_dining_rounded, size: 34),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text('Categories', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
          const SizedBox(height: 10),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: MockData.categories.length - 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final category = MockData.categories[index + 1];
                return ActionChip(
                  label: Text(category),
                  onPressed: () => Get.toNamed(AppRoutes.menu, arguments: category),
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Featured Items', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.menu),
                child: const Text('See all'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...featured.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SectionCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: const Icon(Icons.fastfood_rounded),
                  ),
                  title: Text(item.name),
                  subtitle: Text('${item.category} • ${item.rating.toStringAsFixed(1)} ?'),
                  trailing: Text('\$${item.price.toStringAsFixed(2)}'),
                  onTap: () => Get.toNamed(AppRoutes.itemDetail, arguments: item),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => Get.toNamed(AppRoutes.orderHistory),
                icon: const Icon(Icons.history_rounded),
                label: const Text('Order History'),
              ),
              FilledButton.tonalIcon(
                onPressed: () => Get.toNamed(AppRoutes.wallet),
                icon: const Icon(Icons.account_balance_wallet_outlined),
                label: const Text('E-Wallet'),
              ),
              FilledButton.tonalIcon(
                onPressed: () => Get.toNamed(AppRoutes.chat),
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                label: const Text('Chat'),
              ),
              FilledButton.tonalIcon(
                onPressed: () => Get.toNamed(AppRoutes.profile),
                icon: const Icon(Icons.person_outline_rounded),
                label: const Text('Profile'),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 1) Get.toNamed(AppRoutes.menu);
          if (index == 2) Get.toNamed(AppRoutes.orderHistory);
          if (index == 3) Get.toNamed(AppRoutes.profile);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'Menu'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Orders'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
