import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../widgets/pagination_controls.dart';
import '../../widgets/search_filter_bar.dart';
import '../../widgets/section_card.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final _addresses = List<Map<String, String>>.from(MockData.addresses);
  final _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _addressController = TextEditingController();

  String _query = '';
  String _filter = 'All';
  int _page = 1;
  static const _pageSize = 5;

  List<Map<String, String>> get _filtered {
    return _addresses.where((item) {
      final queryMatch = _query.isEmpty ||
          item['label']!.toLowerCase().contains(_query.toLowerCase()) ||
          item['address']!.toLowerCase().contains(_query.toLowerCase());
      final filterMatch = _filter == 'All' || item['type'] == _filter;
      return queryMatch && filterMatch;
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
      appBar: AppBar(title: const Text('Addresses')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddressForm,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Add Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchFilterBar(
              searchHint: 'Search address',
              searchController: _searchController,
              onSearchChanged: (value) => setState(() {
                _query = value;
                _page = 1;
              }),
              filterValue: _filter,
              filterOptions: const ['All', 'Home', 'Work'],
              onFilterChanged: (value) => setState(() {
                _filter = value;
                _page = 1;
              }),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: _currentPage.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, index) {
                  final address = _currentPage[index];
                  return SectionCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        address['type'] == 'Work'
                            ? Icons.business_rounded
                            : Icons.home_rounded,
                      ),
                      title: Text(address['label']!),
                      subtitle: Text(address['address']!),
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

  void _openAddressForm() {
    _labelController.clear();
    _addressController.clear();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _labelController,
                decoration: const InputDecoration(labelText: 'Label (Home/Work)'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Label is required'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Full address'),
                validator: (value) => (value == null || value.trim().length < 8)
                    ? 'Address is too short'
                    : null,
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        final type = _labelController.text.toLowerCase().contains('work')
                            ? 'Work'
                            : 'Home';
                        _addresses.insert(
                          0,
                          {
                            'label': _labelController.text.trim(),
                            'address': _addressController.text.trim(),
                            'type': type,
                          },
                        );
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Address'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
