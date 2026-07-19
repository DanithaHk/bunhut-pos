import 'dart:async';

import 'package:flutter/material.dart';

import '../core/enums/expense_filter.dart';
import '../core/service/expense_service.dart';
import '../model/expense.dart';



class ExpenseProvider extends ChangeNotifier {


  final ExpenseService _service = ExpenseService();



  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;



  ExpenseFilter _filter =
      ExpenseFilter.thisMonth;


  ExpenseFilter get filter => _filter;



  StreamSubscription? _subscription;



  void loadExpenses(){

    changeFilter(_filter);

  }




  void changeFilter(
      ExpenseFilter filter
      ){

    _filter = filter;


    _subscription?.cancel();



    Stream<List<Expense>> stream;


    switch(filter){


      case ExpenseFilter.today:

        stream =
            _service.getExpensesToday();

        break;



      case ExpenseFilter.thisWeek:

        stream =
            _service.getExpensesThisWeek();

        break;



      case ExpenseFilter.thisMonth:

        stream =
            _service.getExpensesThisMonth();

        break;



      case ExpenseFilter.thisYear:

        stream =
            _service.getExpensesThisYear();

        break;



      case ExpenseFilter.all:

        stream =
            _service.getAllExpenses();

        break;

    }




    _subscription =
        stream.listen((data){

          _expenses = data;

          notifyListeners();

        });


  }





  // ADD EXPENSE

  Future<void> add(
      Expense expense
      ) async {


    await _service.add(
      expense,
    );


  }





  // DELETE EXPENSE

  Future<void> remove(
      String id
      ) async {


    await _service.delete(
      id,
    );


  }




  @override
  void dispose(){

    _subscription?.cancel();

    super.dispose();

  }


}