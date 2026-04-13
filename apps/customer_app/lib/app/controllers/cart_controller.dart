import 'package:get/get.dart';

class CartLine {
  CartLine({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.addons = const <String>[],
  });

  final int id;
  final String name;
  final double price;
  final int quantity;
  final List<String> addons;
}

class CartController extends GetxController {
  final lines = <CartLine>[
    CartLine(id: 1, name: 'Classic Burger', price: 8.99, quantity: 1, addons: ['Extra Cheese']),
    CartLine(id: 2, name: 'Crispy Fries', price: 4.20, quantity: 2, addons: ['Peri Peri']),
  ].obs;

  double get subtotal => lines.fold(0, (sum, line) => sum + (line.price * line.quantity));

  double get tax => subtotal * 0.08;

  double get total => subtotal + tax;

  void addLine(CartLine line) {
    lines.add(line);
  }

  void removeLine(int id) {
    lines.removeWhere((line) => line.id == id);
  }
}
