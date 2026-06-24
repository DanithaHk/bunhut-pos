import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/cart_item.dart';
import '../../model/order.dart' as model;


class OrderService {

  // orders collection reference
  final orders =
  FirebaseFirestore.instance.collection('orders');

  // අද orders ලබාගන්න
  Stream<List<model.Order>> watchToday() {
    DateTime today = DateTime.now();

    DateTime startOfDay = DateTime(
      today.year,
      today.month,
      today.day,
    );

    return orders
        .where(
      'createdAt',
      isGreaterThanOrEqualTo:
      Timestamp.fromDate(startOfDay),
    )
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.map((doc) {
        return model.Order.fromFirestore(doc);
      }).toList();

    });
  }

  // order save කරන්න
  Future<String> placeOrder(
      String invoiceId,
      List<CartItem> items,
      double total,
      double subtotal,
      double tax,
      ) async {

    DocumentReference doc =
    await orders.add(
      model.Order.fromCart(
        invoiceId,
        items,
        total,
        subtotal,
        tax,
      ),
    );

    return doc.id;
  }
}