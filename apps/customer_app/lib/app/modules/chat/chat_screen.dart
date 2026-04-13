import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../widgets/pagination_controls.dart';
import '../../widgets/search_filter_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messages = List<Map<String, dynamic>>.from(MockData.chatMessages);
  final _searchController = TextEditingController();
  final _messageController = TextEditingController();

  String _query = '';
  String _filter = 'All';
  int _page = 1;
  static const _pageSize = 10;

  List<Map<String, dynamic>> get _filtered {
    return _messages.where((item) {
      final queryMatch = _query.isEmpty ||
          item['text'].toString().toLowerCase().contains(_query.toLowerCase());
      final sender = item['from'] == 'me' ? 'Me' : 'Restaurant';
      final senderMatch = _filter == 'All' || sender == _filter;
      return queryMatch && senderMatch;
    }).toList();
  }

  List<Map<String, dynamic>> get _currentPage {
    final start = (_page - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, _filtered.length);
    if (start >= _filtered.length) return <Map<String, dynamic>>[];
    return _filtered.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (_filtered.length / _pageSize).ceil().clamp(1, 999);

    return Scaffold(
      appBar: AppBar(title: const Text('Chat with Restaurant')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchFilterBar(
              searchHint: 'Search messages',
              searchController: _searchController,
              onSearchChanged: (value) => setState(() {
                _query = value;
                _page = 1;
              }),
              filterValue: _filter,
              filterOptions: const ['All', 'Me', 'Restaurant'],
              onFilterChanged: (value) => setState(() {
                _filter = value;
                _page = 1;
              }),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _currentPage.length,
                itemBuilder: (_, index) {
                  final message = _currentPage[index];
                  final isMe = message['from'] == 'me';
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      constraints: const BoxConstraints(maxWidth: 280),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isMe
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(message['text'].toString()),
                          const SizedBox(height: 4),
                          Text(
                            message['time'].toString(),
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
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
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    if (_messageController.text.trim().isEmpty) return;
                    setState(() {
                      _messages.insert(
                        0,
                        {
                          'from': 'me',
                          'text': _messageController.text.trim(),
                          'time': 'Now',
                        },
                      );
                      _messageController.clear();
                      _page = 1;
                    });
                  },
                  child: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
