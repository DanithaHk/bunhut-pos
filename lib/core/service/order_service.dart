import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/enums/date_filter.dart';
import '../../core/utils/date_utils.dart';
import '../../model/cart_item.dart';
import '../../model/order.dart' as model;

class OrderService {
  final CollectionReference<Map<String, dynamic>> orders =
  FirebaseFirestore.instance.collection('orders');

  /// -------------------------------
  /// Private reusable stream
  /// -------------------------------
  Stream<List<model.Order>> _watchBetween(
      DateTime start,
      DateTime end,
      ) {
    return orders
        .where(
      'createdAt',
      isGreaterThanOrEqualTo: Timestamp.fromDate(start),
    )
        .where(
      'createdAt',
      isLessThan: Timestamp.fromDate(end),
    )
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map(model.Order.fromFirestore).toList(),
    );
  }

  /// -------------------------------
  /// Public reusable method
  /// -------------------------------
  Stream<List<model.Order>> getOrdersBetween(
      DateTime start,
      DateTime end,
      ) {
    return _watchBetween(start, end);
  }

  Stream<List<model.Order>> getOrdersToday() {
    final range = AppDateUtils.getRange(DateFilter.today);
    return _watchBetween(range['start']!, range['end']!);
  }

  Stream<List<model.Order>> getOrdersThisWeek() {
    final range = AppDateUtils.getRange(DateFilter.thisWeek);
    return _watchBetween(range['start']!, range['end']!);
  }

  Stream<List<model.Order>> getOrdersThisMonth() {
    final range = AppDateUtils.getRange(DateFilter.thisMonth);
    return _watchBetween(range['start']!, range['end']!);
  }

  Stream<List<model.Order>> getOrdersLastMonth() {
    final range = AppDateUtils.getRange(DateFilter.lastMonth);
    return _watchBetween(range['start']!, range['end']!);
  }

  Stream<List<model.Order>> getOrdersThisYear() {
    final range = AppDateUtils.getRange(DateFilter.thisYear);
    return _watchBetween(range['start']!, range['end']!);
  }

  /// Keep existing method (backward compatibility)
  Stream<List<model.Order>> watchToday() {
    return getOrdersToday();
  }

  /// Save Order
  Future<String> placeOrder(
      String invoiceId,
      List<CartItem> items,
      double total,
      double subtotal,
      double tax,
      ) async {
    final doc = await orders.add(
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