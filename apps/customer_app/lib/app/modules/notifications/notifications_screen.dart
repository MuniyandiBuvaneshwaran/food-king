import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../widgets/pagination_controls.dart';
import '../../widgets/search_filter_bar.dart';
import '../../widgets/section_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _type = 'All';
  int _page = 1;
  static const _pageSize = 8;

  List<Map<String, String>> get _filtered {
    return MockData.notifications.where((item) {
      final queryMatch = _query.isEmpty ||
          item['title']!.toLowerCase().contains(_query.toLowerCase()) ||
          item['message']!.toLowerCase().contains(_query.toLowerCase());
      final typeMatch = _type == 'All' || item['type'] == _type;
      return queryMatch && typeMatch;
    }).toList();
  }

  List<Map<String, String>> get _currentPage {
    final start = (_page - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, _filtered.length);
    if (start >= _filtered.length) return <Map<String, String>>[];
    return _filtered.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (_filtered.length / _pageSize).ceil().clamp(1, 999);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchFilterBar(
              searchHint: 'Search notifications',
              searchController: _searchController,
              onSearchChanged: (value) => setState(() {
                _query = value;
                _page = 1;
              }),
              filterValue: _type,
              filterOptions: const ['All', 'Order', 'Promo'],
              onFilterChanged: (value) => setState(() {
                _type = value;
                _page = 1;
              }),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: _currentPage.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, index) {
                  final item = _currentPage[index];
                  return SectionCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(item['type'] == 'Order'
                          ? Icons.receipt_long_rounded
                          : Icons.local_offer_rounded),
                      title: Text(item['title']!),
                      subtitle: Text(item['message']!),
                      trailing: Text(item['time']!, style: const TextStyle(fontSize: 12)),
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
