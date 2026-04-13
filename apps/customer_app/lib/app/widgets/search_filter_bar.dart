import 'package:flutter/material.dart';

class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({
    super.key,
    required this.searchHint,
    required this.searchController,
    required this.onSearchChanged,
    required this.filterValue,
    required this.filterOptions,
    required this.onFilterChanged,
  });

  final String searchHint;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final String filterValue;
  final List<String> filterOptions;
  final ValueChanged<String> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: searchHint,
              prefixIcon: const Icon(Icons.search_rounded),
            ),
            onChanged: onSearchChanged,
          ),
        ),
        const SizedBox(width: 12),
        DropdownButton<String>(
          value: filterValue,
          borderRadius: BorderRadius.circular(12),
          items: filterOptions
              .map((option) => DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
          onChanged: (value) => onFilterChanged(value ?? filterOptions.first),
        ),
      ],
    );
  }
}
