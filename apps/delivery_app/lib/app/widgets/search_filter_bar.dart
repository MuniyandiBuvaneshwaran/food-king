import 'package:flutter/material.dart';

class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.filterValue,
    required this.filterOptions,
    required this.onFilterChanged,
    this.hint = 'Search',
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final String filterValue;
  final List<String> filterOptions;
  final ValueChanged<String> onFilterChanged;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: const Icon(Icons.search_rounded),
            ),
          ),
        ),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: filterValue,
          items: filterOptions
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: (value) => onFilterChanged(value ?? filterOptions.first),
        ),
      ],
    );
  }
}
