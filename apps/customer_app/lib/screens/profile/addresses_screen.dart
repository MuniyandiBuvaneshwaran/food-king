import 'package:flutter/material.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Addresses')),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: _addresses.length,
        itemBuilder: (context, i) {
          final addr = _addresses[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: addr['default'] ? const Color(0xFFF97316) : const Color(0xFFF1F5F9)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(14)),
                  child: Center(child: Icon(addr['icon'], color: const Color(0xFF475569))),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(
                      children: [
                        Text(addr['label'], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                        if (addr['default']) ...[
                          const SizedBox(width: 8),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(8)), child: const Text('DEFAULT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF22C55E)))),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(addr['full'], style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                  ]),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF94A3B8))),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFFF97316),
        label: const Text('Add New Address', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}

const _addresses = [
  {'label': 'Home', 'icon': Icons.home_rounded, 'full': '123 Main Street, Apt 4B, New York, NY 10001', 'default': true},
  {'label': 'Office', 'icon': Icons.work_rounded, 'full': '456 Business Blvd, Floor 12, New York, NY 10022', 'default': false},
];
