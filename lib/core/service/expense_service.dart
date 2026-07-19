import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/enums/date_filter.dart';
import '../../core/utils/date_utils.dart';
import '../../model/expense.dart';

class ExpenseService {
  final CollectionReference<Map<String, dynamic>> expenses =
  FirebaseFirestore.instance.collection('expenses');

  /// -------------------------------
  /// Private reusable stream
  /// -------------------------------
  Stream<List<Expense>> getAllExpenses(){

    return expenses
        .orderBy(
      'createdAt',
      descending:true,
    )
        .snapshots()
        .map(
          (snapshot)=>
          snapshot.docs
              .map(
              Expense.fromFirestore
          )
              .toList(),
    );

  }
  Stream<List<Expense>> _watchBetween(
      DateTime start,
      DateTime end,
      ) {
    return expenses
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
          snapshot.docs.map(Expense.fromFirestore).toList(),
    );
  }

  Stream<List<Expense>> getExpensesBetween(
      DateTime start,
      DateTime end,
      ) {
    return _watchBetween(start, end);
  }

  Stream<List<Expense>> getExpensesToday() {
    final range = AppDateUtils.getRange(DateFilter.today);
    return _watchBetween(range['start']!, range['end']!);
  }

  Stream<List<Expense>> getExpensesThisWeek() {
    final range = AppDateUtils.getRange(DateFilter.thisWeek);
    return _watchBetween(range['start']!, range['end']!);
  }

  Stream<List<Expense>> getExpensesThisMonth() {
    final range = AppDateUtils.getRange(DateFilter.thisMonth);
    return _watchBetween(range['start']!, range['end']!);
  }

  Stream<List<Expense>> getExpensesLastMonth() {
    final range = AppDateUtils.getRange(DateFilter.lastMonth);
    return _watchBetween(range['start']!, range['end']!);
  }

  Stream<List<Expense>> getExpensesThisYear() {
    final range = AppDateUtils.getRange(DateFilter.thisYear);
    return _watchBetween(range['start']!, range['end']!);
  }

  /// Keep existing method
  Stream<List<Expense>> watchToday() {
    return getExpensesToday();
  }

  Future<void> add(Expense expense) async {
    await expenses.add(expense.toMap());
  }

  Future<void> delete(String id) async {
    await expenses.doc(id).delete();
  }
}