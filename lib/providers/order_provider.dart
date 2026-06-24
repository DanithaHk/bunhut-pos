import 'package:flutter/material.dart';
import '../model/order.dart';
import '../core/service/order_service.dart';

class OrderProvider extends ChangeNotifier {

  // Order Service Object
  final OrderService orderService = OrderService();

  // Orders List
  List<Order> orders = [];

  // Load Orders From Firestore
  void loadOrders() {

    orderService.watchToday().listen((data) {

      orders = data;

      // UI Refresh
      notifyListeners();

    });
  }
}