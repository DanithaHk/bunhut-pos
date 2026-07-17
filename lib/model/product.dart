import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final double price;

  int stock;

  /// NEW
  final bool trackStock;

  final String category;
  final Color tone;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.trackStock,
    required this.category,
    required this.tone,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;

    return Product(
      id: doc.id,
      name: d['name'] ?? '',
      price: (d['price'] ?? 0).toDouble(),
      stock: d['stock'] ?? 0,
      trackStock: d['trackStock'] ?? true,
      category: d['category'] ?? 'Bakery',
      tone: _hexToColor(d['tone'] ?? '#FCD9A6'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'stock': stock,
      'trackStock': trackStock,
      'category': category,
      'tone': _colorToHex(tone),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Product copyWith({
    int? stock,
    bool? trackStock,
  }) {
    return Product(
      id: id,
      name: name,
      price: price,
      stock: stock ?? this.stock,
      trackStock: trackStock ?? this.trackStock,
      category: category,
      tone: tone,
    );
  }

  static Color _hexToColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  static String _colorToHex(Color c) =>
      '#${c.value.toRadixString(16).substring(2).toUpperCase()}';
}