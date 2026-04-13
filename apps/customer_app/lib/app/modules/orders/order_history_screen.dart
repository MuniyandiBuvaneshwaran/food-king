import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/mock_data.dart';
import '../../routes/app_routes.dart';
import '../../widgets/pagination_controls.dart';
import '../../widgets/search_filter_bar.dart';
import '../../widgets/section_card.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _status = 'All';
  int _page = 1;
  static const _pageSize = 8;

  List<MockOrder> get _filtered {
    return MockData.orders.where((order) {
      final qMatch = _query.isEmpty ||
          order.id.toLowerCase().contains(_query.toLowerCase()) ||
          order.restaurant.toLowerCase().contains(_query.toLowerCase());
      final sMatch = _status == 'All' || order.status == _status;
      return qMatch && sMatch;
    }).toList();
  }

  List<MockOrder> get _currentPage {
    final start = (_page - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, _filtered.length);
    if (start >= _filtered.length) return <MockOrder>[];
    return _filtered.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    const statuses = ['All', 'Pending', 'Preparing', 'Out for delivery', 'Delivered', 'Cancelled'];
    final totalPages = (_filtered.length / _pageSize).ceil().clamp(1, 999);

    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchFilterBar(
              searchHint: 'Search order ID or restaurant',
              searchController: _searchController,
              onSearchChanged: (value) => setState(() {
                _query = value;
                _page = 1;
              }),
              filterValue: _status,
              filterOptions: statuses,
              onFilterChanged: (value) => setState(() {
                _status = value;
                _page = 1;
              }),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: _currentPage.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, index) {
                  final order = _currentPage[index];
                  return SectionCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('${order.id} • ${order.restaurant}'),
                      subtitle: Text('${order.status} • ${order.createdAt}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('\$${order.amount.toStringAsFixed(2)}'),
                          TextButton(
                            onPressed: () => Get.toNamed(AppRoutes.orderTracking),
                            child: const Text('Track'),
                          ),
                        ],
                      ),
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
