import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/expense.dart';

class ExpenseService {

  // expenses collection
  final expenses =
  FirebaseFirestore.instance.collection('expenses');

  // අද expenses බලන්න (simple stream)
  Stream<List<Expense>> watchToday() {

    DateTime today = DateTime.now();

    DateTime startOfDay = DateTime(
      today.year,
      today.month,
      today.day,
    );

    return expenses
        .where(
      'createdAt',
      isGreaterThanOrEqualTo:
      Timestamp.fromDate(startOfDay),
    )
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.map((doc) {
        return Expense.fromFirestore(doc);
      }).toList();

    });
  }

  // add expense
  Future<void> add(Expense expense) async {
    await expenses.add(expense.toMap());
  }

  // delete expense
  Future<void> delete(String id) async {
    await expenses.doc(id).delete();
  }
}