import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../widgets/pagination_controls.dart';
import '../../widgets/search_filter_bar.dart';
import '../../widgets/section_card.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _type = 'All';
  int _page = 1;
  static const _pageSize = 7;

  List<Map<String, String>> get _filtered {
    return MockData.walletTransactions.where((item) {
      final queryMatch = _query.isEmpty ||
          item['title']!.toLowerCase().contains(_query.toLowerCase());
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
      appBar: AppBar(title: const Text('E-wallet / Credit Balance')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Current Balance', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 4),
                  Text('\$138.40', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SearchFilterBar(
              searchHint: 'Search transaction',
              searchController: _searchController,
              onSearchChanged: (value) => setState(() {
                _query = value;
                _page = 1;
              }),
              filterValue: _type,
              filterOptions: const ['All', 'Credit', 'Debit'],
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
                  final transaction = _currentPage[index];
                  final isCredit = transaction['type'] == 'Credit';
                  return SectionCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        isCredit ? Icons.south_west_rounded : Icons.north_east_rounded,
                        color: isCredit ? Colors.green : Colors.red,
                      ),
                      title: Text(transaction['title']!),
                      subtitle: Text(transaction['date']!),
                      trailing: Text(
                        transaction['amount']!,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isCredit ? Colors.green : Colors.red,
                        ),
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
