import 'package:flutter/material.dart';

class CartItem {
  final String productId;
  final String name;
  final double price;
  int qty;
  final Color tone;
  final String category;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.qty,
    required this.tone,
    required this.category,
  });

  double get lineTotal => price * qty;
}