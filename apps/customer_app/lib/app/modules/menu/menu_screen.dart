import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../data/mock_data.dart';
import '../../routes/app_routes.dart';
import '../../widgets/pagination_controls.dart';
import '../../widgets/search_filter_bar.dart';
import '../../widgets/section_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _searchController = TextEditingController();
  String _search = '';
  String _category = 'All';
  int _page = 1;
  static const _pageSize = 8;

  List<MockFoodItem> get _filtered {
    return MockData.foodItems.where((item) {
      final queryMatch = _search.isEmpty ||
          item.name.toLowerCase().contains(_search.toLowerCase());
      final categoryMatch = _category == 'All' || item.category == _category;
      return queryMatch && categoryMatch;
    }).toList();
  }

  List<MockFoodItem> get _pageItems {
    final start = (_page - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, _filtered.length);
    if (start >= _filtered.length) {
      return <MockFoodItem>[];
    }
    return _filtered.sublist(start, end);
  }

  @override
  void initState() {
    super.initState();
    final category = Get.arguments;
    if (category is String && MockData.categories.contains(category)) {
      _category = category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final totalPages = (_filtered.length / _pageSize).ceil().clamp(1, 999);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu & Search'),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.cart),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchFilterBar(
              searchHint: 'Search menu items...',
              searchController: _searchController,
              onSearchChanged: (value) => setState(() {
                _search = value;
                _page = 1;
              }),
              filterValue: _category,
              filterOptions: MockData.categories,
              onFilterChanged: (value) => setState(() {
                _category = value;
                _page = 1;
              }),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: _pageItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.78,
                ),
                itemBuilder: (_, index) {
                  final item = _pageItems[index];
                  return SectionCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.lunch_dining_rounded, size: 42),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(item.category, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('\$${item.price.toStringAsFixed(2)}'),
                            IconButton(
                              onPressed: () {
                                cartController.addLine(
                                  CartLine(
                                    id: DateTime.now().millisecondsSinceEpoch,
                                    name: item.name,
                                    price: item.price,
                                    quantity: 1,
                                  ),
                                );
                                Get.snackbar('Added to cart', item.name);
                              },
                              icon: const Icon(Icons.add_circle_outline_rounded),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => Get.toNamed(AppRoutes.itemDetail, arguments: item),
                            child: const Text('Details'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            PaginationControls(
              currentPage: _page,
              totalPages: totalPages,
              onPrevious: () => setState(() => _page -= 1),
              onNext: () => setState(() => _page += 1),
            ),
          ],
        ),
      ),
    );
  }
}
