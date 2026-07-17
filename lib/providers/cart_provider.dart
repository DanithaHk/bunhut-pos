import 'package:flutter/material.dart';
import '../model/cart_item.dart';
import '../model/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get count =>
      _items.fold<int>(0, (sum, item) => sum + item.qty);

  double get subtotal =>
      _items.fold<double>(0, (sum, item) => sum + item.lineTotal);

  double get tax => 0;

  double get total => subtotal + tax;

  // ===========================
  // ADD PRODUCT
  // ===========================
  void addProduct(Product product) {
    final index =
    _items.indexWhere((i) => i.productId == product.id);

    if (index >= 0) {
      _items[index].qty++;
    } else {
      _items.add(
        CartItem(
          productId: product.id,
          name: product.name,
          price: product.price,
          qty: 1,
          tone: product.tone,
          category: product.category,
        ),
      );
    }

    notifyListeners();
  }

  // ===========================
  // INCREMENT
  // ===========================
  void increment(String productId) {
    final index =
    _items.indexWhere((i) => i.productId == productId);

    if (index >= 0) {
      _items[index].qty++;
      notifyListeners();
    }
  }

  // ===========================
  // DECREMENT
  // ===========================
  void decrement(String productId) {
    final index =
    _items.indexWhere((i) => i.productId == productId);

    if (index < 0) return;

    if (_items[index].qty > 1) {
      _items[index].qty--;
    } else {
      _items.removeAt(index);
    }

    notifyListeners();
  }

  // ===========================
  // REMOVE
  // ===========================
  void remove(String productId) {
    _items.removeWhere((i) => i.productId == productId);
    notifyListeners();
  }

  // ===========================
  // CLEAR
  // ===========================
  void clear() {
    _items.clear();
    notifyListeners();
  }

  CartItem? getItem(String productId) {
    try {
      return _items.firstWhere((i) => i.productId == productId);
    } catch (_) {
      return null;
    }
  }

  bool contains(String productId) {
    return _items.any((i) => i.productId == productId);
  }
}