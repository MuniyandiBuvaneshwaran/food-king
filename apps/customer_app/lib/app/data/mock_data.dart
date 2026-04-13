class MockFoodItem {
  MockFoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.isFeatured,
  });

  final int id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final bool isFeatured;
}

class MockOrder {
  MockOrder({
    required this.id,
    required this.restaurant,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String restaurant;
  final double amount;
  final String status;
  final String createdAt;
}

class MockData {
  static const categories = <String>[
    'All',
    'Burger',
    'Pizza',
    'Rice',
    'Dessert',
    'Drinks',
  ];

  static final foodItems = List<MockFoodItem>.generate(
    24,
    (index) => MockFoodItem(
      id: index + 1,
      name: 'Food Item ${index + 1}',
      category: categories[(index % (categories.length - 1)) + 1],
      price: 6 + (index % 9) + 0.99,
      rating: 3.8 + ((index % 12) * 0.1),
      isFeatured: index % 4 == 0,
    ),
  );

  static final orders = List<MockOrder>.generate(
    30,
    (index) {
      final statuses = ['Pending', 'Preparing', 'Out for delivery', 'Delivered', 'Cancelled'];
      return MockOrder(
        id: 'FK-${2200 + index}',
        restaurant: 'Restaurant ${index % 7 + 1}',
        amount: 14 + (index * 1.7),
        status: statuses[index % statuses.length],
        createdAt: '2026-04-${(index % 28) + 1}'.padLeft(10, '0'),
      );
    },
  );

  static final notifications = List<Map<String, String>>.generate(
    28,
    (index) => {
      'title': index % 2 == 0 ? 'Order update' : 'Offer alert',
      'type': index % 2 == 0 ? 'Order' : 'Promo',
      'message': 'Notification message #${index + 1}',
      'time': '${(index % 12) + 1}h ago',
    },
  );

  static final addresses = List<Map<String, String>>.generate(
    15,
    (index) => {
      'label': index % 2 == 0 ? 'Home' : 'Work',
      'address': '${110 + index} Main Street, FoodCity',
      'type': index % 2 == 0 ? 'Home' : 'Work',
    },
  );

  static final walletTransactions = List<Map<String, String>>.generate(
    18,
    (index) => {
      'title': index % 2 == 0 ? 'Order payment' : 'Wallet top-up',
      'amount': index % 2 == 0 ? '-\$${(8 + index).toStringAsFixed(2)}' : '+\$${(10 + index).toStringAsFixed(2)}',
      'type': index % 2 == 0 ? 'Debit' : 'Credit',
      'date': 'Apr ${(index % 28) + 1}, 2026',
    },
  );

  static final chatMessages = List<Map<String, dynamic>>.generate(
    22,
    (index) => {
      'from': index % 2 == 0 ? 'restaurant' : 'me',
      'text': index % 2 == 0
          ? 'Your order is being prepared.'
          : 'Thanks, please add extra sauce.',
      'time': '10:${index.toString().padLeft(2, '0')} AM',
    },
  );
}
