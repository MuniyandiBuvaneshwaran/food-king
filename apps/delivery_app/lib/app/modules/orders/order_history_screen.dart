import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
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

  List<DeliveryOrder> get _filtered {
    return DeliveryMockData.deliveredOrders.where((order) {
      final queryMatch = _query.isEmpty ||
          order.id.toLowerCase().contains(_query.toLowerCase()) ||
          order.customer.toLowerCase().contains(_query.toLowerCase());
      final statusMatch = _status == 'All' || order.status == _status;
      return queryMatch && statusMatch;
    }).toList();
  }

  List<DeliveryOrder> get _currentPage {
    final start = (_page - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, _filtered.length);
    if (start >= _filtered.length) return <DeliveryOrder>[];
    return _filtered.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (_filtered.length / _pageSize).ceil().clamp(1, 999);

    return Scaffold(
      appBar: AppBar(title: const Text('Delivery History')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchFilterBar(
              searchController: _searchController,
              onSearchChanged: (value) => setState(() {
                _query = value;
                _page = 1;
              }),
              filterValue: _status,
              filterOptions: const ['All', 'Delivered', 'Failed', 'Returned'],
              onFilterChanged: (value) => setState(() {
                _status = value;
                _page = 1;
              }),
              hint: 'Search history order',
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
                      title: Text('${order.id} • ${order.customer}'),
                      subtitle: Text('${order.status} • ${order.address}'),
                      trailing: Text('\$${order.amount.toStringAsFixed(2)}'),
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
