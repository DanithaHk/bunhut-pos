import 'dart:async';
import 'package:flutter/material.dart';

import '../model/order.dart';
import '../core/service/order_service.dart';
import '../core/enums/date_filter.dart';


class OrderProvider extends ChangeNotifier {


  final OrderService orderService = OrderService();

  DateTime? customStart;
  DateTime? customEnd;

  List<Order> orders = [];


  DateFilter selectedFilter = DateFilter.today;


  StreamSubscription? _subscription;



  OrderProvider(){

    loadOrders();

  }



  void loadOrders(){

    _subscription?.cancel();


    _subscription =
        getOrders().listen((data){

          orders = data;

          notifyListeners();

        });

  }



  void changeFilter(DateFilter filter){

    selectedFilter = filter;

    loadOrders();

    notifyListeners();

  }

  Stream<List<Order>> getOrders(){

    switch(selectedFilter){

      case DateFilter.today:
        return orderService.getOrdersToday();


      case DateFilter.thisWeek:
        return orderService.getOrdersThisWeek();


      case DateFilter.thisMonth:
        return orderService.getOrdersThisMonth();


      case DateFilter.lastMonth:
        return orderService.getOrdersLastMonth();


      case DateFilter.thisYear:
        return orderService.getOrdersThisYear();


      case DateFilter.custom:

        if(customStart != null && customEnd != null){

          return orderService.getOrdersBetween(
            customStart!,
            customEnd!,
          );

        }

        // fallback if dates are not selected
        return orderService.getOrdersToday();

    }

  }

  @override
  void dispose(){

    _subscription?.cancel();

    super.dispose();

  }

}