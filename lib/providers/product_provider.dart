import 'dart:async';
import 'package:flutter/material.dart';
import '../model/product.dart';
import '../core/service/product_service.dart';

class ProductProvider extends ChangeNotifier {
  ProductProvider() {
    loadProducts(); // auto load on app start
  }
  final ProductService _service = ProductService();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  // ===========================
  // CHANGE: Keep only one stream
  // subscription.
  // ===========================
  StreamSubscription<List<Product>>? _subscription;

  List<Product> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ===========================
  // CHANGE:
  // Prevent multiple listeners.
  // ===========================
  void loadProducts() {
    print("🔥 loadProducts CALLED"); // ADD THIS

    _isLoading = true;
    notifyListeners();

    _service.watch().listen(
          (list) {
        print("✅ Products received: ${list.length}"); // ADD THIS

        _products = list;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        print("❌ Firestore error: $e"); // ADD THIS

        _isLoading = false;
        _error = e.toString();
        notifyListeners();
      },
    );
  }
  Future<void> addProduct(Product product) async {
    try {
      await _service.add(product);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ===========================
  // CHANGE:
  // Added update product.
  // ===========================
  Future<void> updateProduct(Product product) async {
    try {
      await _service.update(product);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _service.delete(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> decrementStock(String id) async {
    final idx = _products.indexWhere((p) => p.id == id);

    if (idx < 0) return;

    if (_products[idx].stock <= 0) return;

    final stock = _products[idx].stock - 1;

    _products[idx] = _products[idx].copyWith(stock: stock);

    notifyListeners();

    await _service.updateStock(id, stock);
  }

  Future<void> incrementStock(String id) async {
    final idx = _products.indexWhere((p) => p.id == id);

    if (idx < 0) return;

    final stock = _products[idx].stock + 1;

    _products[idx] = _products[idx].copyWith(stock: stock);

    notifyListeners();

    await _service.updateStock(id, stock);
  }

  Future<void> restoreStock(String id, int qty) async {
    final idx = _products.indexWhere((p) => p.id == id);

    if (idx < 0) return;

    final stock = _products[idx].stock + qty;

    _products[idx] = _products[idx].copyWith(stock: stock);

    notifyListeners();

    await _service.updateStock(id, stock);
  }

  Product? getById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  bool hasStock(String id) {
    final p = getById(id);
    return p != null && p.stock > 0;
  }

  @override
  void dispose() {
    // ===========================
    // CHANGE:
    // Cancel Firestore listener.
    // ===========================
    _subscription?.cancel();
    super.dispose();
  }
}