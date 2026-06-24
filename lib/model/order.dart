import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item.dart';

class Order {
  final String id;
  final String invoiceId;
  final double total;
  final int itemCount;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.invoiceId,
    required this.total,
    required this.itemCount,
    required this.createdAt,
  });

  factory Order.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Order(
      id:        doc.id,
      invoiceId: d['invoiceId'] ?? '',
      total:     (d['total'] ?? 0).toDouble(),
      itemCount: d['itemCount'] ?? 0,
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  static Map<String, dynamic> fromCart(
      String invoiceId,
      List<CartItem> items,
      double total,
      double subtotal,
      double tax,
      ) => {
    'invoiceId': invoiceId,
    'total':     total,
    'subtotal':  subtotal,
    'tax':       tax,
    'itemCount': items.fold(0, (s, c) => s + c.qty),
    'items': items.map((c) => {
      'productId': c.productId,
      'name':      c.name,
      'price':     c.price,
      'qty':       c.qty,
    }).toList(),
    'cashierName': 'Admin',
    'createdAt':   FieldValue.serverTimestamp(),
  };
}