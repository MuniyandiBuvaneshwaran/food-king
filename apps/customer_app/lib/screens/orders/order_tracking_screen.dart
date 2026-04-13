import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('Track Order')),
      body: Column(
        children: [
          // Map placeholder
          Expanded(
            flex: 3,
            child: Container(
              color: const Color(0xFFE2E8F0),
              child: Stack(
                children: [
                  const Center(child: Icon(Icons.map_rounded, size: 80, color: Color(0xFF94A3B8))),
                  // Dummy driver marker
                  Positioned(
                    top: 100, left: 150,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Color(0xFFF97316), shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)]),
                      child: const Icon(Icons.delivery_dining_rounded, color: Colors.white, size: 24),
                    ),
                  ),
                  // User marker
                  Positioned(
                    bottom: 80, right: 100,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Color(0xFF1E293B), shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)]),
                      child: const Icon(Icons.home_rounded, color: Colors.white, size: 24),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Status sheet
          Expanded(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)],
              ),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Driver Info
                  Row(
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
                        child: const Center(child: Text('AM', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF475569)))),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Alex Martinez', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
                          Text('Your delivery partner', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                        ]),
                      ),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.call_rounded, color: Color(0xFFF97316))),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.message_rounded, color: Color(0xFFF97316))),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // ETA
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Estimated Arrival', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
                      Text('12:45 PM (15 min)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFFF97316))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: 0.7, backgroundColor: const Color(0xFFF1F5F9), color: const Color(0xFFF97316), borderRadius: BorderRadius.circular(10), minHeight: 8),
                  
                  const SizedBox(height: 40),
                  
                  // Timeline
                  const _TrackNode(title: 'Order Placed', time: '12:10 PM', done: true),
                  const _TrackNode(title: 'Preparing', time: '12:15 PM', done: true),
                  const _TrackNode(title: 'Out for Delivery', time: '12:30 PM', active: true),
                  const _TrackNode(title: 'Delivered', time: 'Expected 12:45 PM', last: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackNode extends StatelessWidget {
  final String title;
  final String time;
  final bool done;
  final bool active;
  final bool last;
  const _TrackNode({required this.title, required this.time, this.done = false, this.active = false, this.last = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24, height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? const Color(0xFF22C55E) : active ? const Color(0xFFF97316) : Colors.white,
                  border: Border.all(color: done ? const Color(0xFF22C55E) : active ? const Color(0xFFF97316) : const Color(0xFFE2E8F0), width: 2),
                ),
                child: done ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
              ),
              if (!last) Container(width: 2, height: 50, color: done ? const Color(0xFF22C55E) : const Color(0xFFE2E8F0)),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: active || done ? const Color(0xFF1E293B) : const Color(0xFF94A3B8))),
                const SizedBox(height: 4),
                Text(time, style: TextStyle(fontSize: 12, color: active ? const Color(0xFFF97316) : const Color(0xFF94A3B8))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
