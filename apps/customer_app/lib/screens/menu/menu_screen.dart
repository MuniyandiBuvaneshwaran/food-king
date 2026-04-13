import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category horizontal list
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, i) {
                final cat = _categories[i];
                final isSelected = _selectedCategory == cat['name'];
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat['name']!),
                    avatar: Text(cat['emoji']!),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() => _selectedCategory = cat['name']!);
                    },
                    selectedColor: const Color(0xFFF97316),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF475569),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? const Color(0xFFF97316) : const Color(0xFFE2E8F0),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Grid of items
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _menuItems.length,
              itemBuilder: (context, i) {
                final item = _menuItems[i];
                return _MenuItemCard(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final Map<String, String> item;
  const _MenuItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.itemDetail, arguments: item),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF7ED), Color(0xFFFFF1F2)],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Center(
                  child: Text(item['emoji']!, style: const TextStyle(fontSize: 52)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: Color(0xFF1E293B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['category']!,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${item['price']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: Color(0xFFF97316),
                        ),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF97316),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _categories = [
  {'name': 'All', 'emoji': '🍽️'},
  {'name': 'Burgers', 'emoji': '🍔'},
  {'name': 'Pizza', 'emoji': '🍕'},
  {'name': 'Sushi', 'emoji': '🍱'},
  {'name': 'Pasta', 'emoji': '🍝'},
  {'name': 'Salads', 'emoji': '🥗'},
  {'name': 'Desserts', 'emoji': '🍰'},
  {'name': 'Drinks', 'emoji': '🥤'},
];

const _menuItems = [
  {'id': '1', 'name': 'Classic Burger', 'category': 'Burgers', 'price': '12.99', 'emoji': '🍔', 'rating': '4.9'},
  {'id': '2', 'name': 'Pepperoni Pizza', 'category': 'Pizza', 'price': '14.99', 'emoji': '🍕', 'rating': '4.8'},
  {'id': '3', 'name': 'California Roll', 'category': 'Sushi', 'price': '18.50', 'emoji': '🍱', 'rating': '4.7'},
  {'id': '4', 'name': 'Pesto Pasta', 'category': 'Pasta', 'price': '13.50', 'emoji': '🍝', 'rating': '4.6'},
  {'id': '5', 'name': 'Greek Salad', 'category': 'Salads', 'price': '9.50', 'emoji': '🥗', 'rating': '4.5'},
  {'id': '6', 'name': 'Tiramisu', 'category': 'Desserts', 'price': '7.99', 'emoji': '🍰', 'rating': '4.9'},
];
