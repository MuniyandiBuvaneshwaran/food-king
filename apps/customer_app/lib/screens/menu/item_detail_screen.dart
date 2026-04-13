import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({super.key});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int _quantity = 1;
  final Map<String, String> _item = Get.arguments ?? {
    'name': 'Chicken Burger',
    'emoji': '🍔',
    'price': '12.99',
    'category': 'Burgers',
    'rating': '4.9',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFF7ED), Color(0xFFFFF1F2)],
                  ),
                ),
                child: Center(
                  child: Text(_item['emoji']!, style: const TextStyle(fontSize: 120)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF97316).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _item['category']!,
                          style: const TextStyle(
                            color: Color(0xFFF97316),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 20),
                          const SizedBox(width: 4),
                          Text(
                            _item['rating']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          const Text(' (120+ reviews)', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _item['name']!,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Our signature classic burger is made with a juicy, grain-fed beef patty, topped with melted cheddar, fresh lettuce, vine-ripened tomatoes, and our secret house sauce on a toasted brioche bun.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF64748B),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Extras',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 12),
                  _ExtraItem(name: 'Extra Cheese', price: '1.50'),
                  _ExtraItem(name: 'Avocado', price: '2.00'),
                  _ExtraItem(name: 'Bacon bits', price: '2.50'),
                  const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() => _quantity = _quantity > 1 ? _quantity - 1 : 1),
                      icon: const Icon(Icons.remove_rounded, color: Color(0xFF475569)),
                    ),
                    Text(
                      '$_quantity',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _quantity++),
                      icon: const Icon(Icons.add_rounded, color: Color(0xFF475569)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.snackbar(
                      'Added to Cart',
                      '${_item['name']} has been added to your cart!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: const Color(0xFF1E293B),
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 16,
                    );
                  },
                  child: Text('Add to Cart - \$${(double.parse(_item['price']!) * _quantity).toStringAsFixed(2)}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExtraItem extends StatefulWidget {
  final String name;
  final String price;
  const _ExtraItem({required this.name, required this.price});

  @override
  State<_ExtraItem> createState() => _ExtraItemState();
}

class _ExtraItemState extends State<_ExtraItem> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _selected = !_selected),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _selected ? const Color(0xFFFFF7ED) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _selected ? const Color(0xFFF97316) : const Color(0xFFE2E8F0),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _selected ? const Color(0xFFF97316) : Colors.transparent,
                border: Border.all(
                  color: _selected ? const Color(0xFFF97316) : const Color(0xFFCBD5E1),
                ),
              ),
              child: _selected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
            const SizedBox(width: 12),
            Text(
              widget.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: _selected ? const Color(0xFF1E293B) : const Color(0xFF475569),
              ),
            ),
            const Spacer(),
            Text(
              '+\$${widget.price}',
              style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFF97316)),
            ),
          ],
        ),
      ),
    );
  }
}
