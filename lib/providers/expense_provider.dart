import 'package:flutter/material.dart';
import '../model/expense.dart';
import '../core/service/expense_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final _service = ExpenseService();
  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  void loadExpenses() {
    _service.watchToday().listen((list) {
      _expenses = list;
      notifyListeners();
    });
  }

  Future<void> add(Expense e) => _service.add(e);

  Future<void> remove(String id) => _service.delete(id);
}