import 'package:flutter/material.dart';

import '../model/cart_item.dart';
import '../model/product.dart';


class CartProvider extends ChangeNotifier {

  // cart items list
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // total count
  int get count {
    int total = 0;
    for (var item in _items) {
      total += item.qty;
    }
    return total;
  }

  // subtotal
  double get subtotal {
    double total = 0;
    for (var item in _items) {
      total += item.lineTotal;
    }
    return total;
  }

  // tax (simple 10%)
  double get tax {
    return subtotal * 0.1;
  }

  // total
  double get total {
    return subtotal + tax;
  }

  // add product
  void addProduct(Product product) {

    for (var item in _items) {
      if (item.productId == product.id) {
        item.qty++;
        notifyListeners();
        return;
      }
    }

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

    notifyListeners();
  }

  // increase qty
  void increment(String productId) {
    for (var item in _items) {
      if (item.productId == productId) {
        item.qty++;
      }
    }
    notifyListeners();
  }

  // decrease qty
  void decrement(String productId) {
    for (var item in _items) {
      if (item.productId == productId) {
        item.qty--;

        if (item.qty <= 0) {
          _items.remove(item);
        }
        break;
      }
    }
    notifyListeners();
  }

  // remove item
  void remove(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  // clear cart
  void clear() {
    _items.clear();
    notifyListeners();
  }
}