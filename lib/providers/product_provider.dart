import 'dart:async';
import 'package:flutter/material.dart';
import '../model/product.dart';
import '../core/service/product_service.dart';

class ProductProvider extends ChangeNotifier {
  ProductProvider() {
    loadProducts();
  }

  final ProductService _service = ProductService();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  StreamSubscription<List<Product>>? _subscription;

  List<Product> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ===========================
  // LOAD PRODUCTS (FIXED STREAM HANDLING)
  // ===========================
  void loadProducts() {
    _isLoading = true;
    notifyListeners();

    _subscription?.cancel(); // 🔥 prevent multiple listeners

    _subscription = _service.watch().listen(
          (list) {
        _products = list;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // ===========================
  // ADD PRODUCT
  // ===========================
  Future<void> addProduct(Product product) async {
    try {
      await _service.add(product);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ===========================
  // UPDATE PRODUCT
  // ===========================
  Future<void> updateProduct(Product product) async {
    try {
      await _service.update(product);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ===========================
  // DELETE PRODUCT
  // ===========================
  Future<void> deleteProduct(String id) async {
    try {
      await _service.delete(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ===========================
  // 🔥 DECREMENT STOCK (FIXED LOGIC)
  // ===========================
  Future<void> decrementStock(String id) async {
    final idx = _products.indexWhere((p) => p.id == id);
    if (idx < 0) return;

    final product = _products[idx];

    /// 🚨 IMPORTANT RULE
    /// If stock is NOT tracked → do nothing
    if (!product.trackStock) return;

    /// prevent negative stock
    if (product.stock <= 0) return;

    final updated = product.stock - 1;

    _products[idx] = product.copyWith(stock: updated);
    notifyListeners();

    await _service.updateStock(id, updated);
  }

  // ===========================
  // 🔥 INCREMENT STOCK (FIXED)
  // ===========================
  Future<void> incrementStock(String id) async {
    final idx = _products.indexWhere((p) => p.id == id);
    if (idx < 0) return;

    final product = _products[idx];

    if (!product.trackStock) return;

    final updated = product.stock + 1;

    _products[idx] = product.copyWith(stock: updated);
    notifyListeners();

    await _service.updateStock(id, updated);
  }

  // ===========================
  // RESTORE STOCK (FIXED)
  // ===========================
  Future<void> restoreStock(String id, int qty) async {
    final idx = _products.indexWhere((p) => p.id == id);
    if (idx < 0) return;

    final product = _products[idx];

    if (!product.trackStock) return;

    final updated = product.stock + qty;

    _products[idx] = product.copyWith(stock: updated);
    notifyListeners();

    await _service.updateStock(id, updated);
  }

  // ===========================
  // GET PRODUCT
  // ===========================
  Product? getById(String id) {

    try {

      return products.firstWhere(
            (p) => p.id == id,
      );

    } catch(e) {

      return null;

    }

  }

  // ===========================
  // STOCK CHECK (UPDATED LOGIC)
  // ===========================
  bool hasStock(String id) {
    final p = getById(id);

    if (p == null) return false;

    /// if NOT tracked → always available
    if (!p.trackStock) return true;

    return p.stock > 0;
  }

  // ===========================
  // DISPOSE
  // ===========================
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}