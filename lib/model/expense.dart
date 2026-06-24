import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String category;
  final double amount;
  final String note;
  final DateTime createdAt;

  Expense({
    required this.id,
    required this.category,
    required this.amount,
    required this.note,
    required this.createdAt,
  });

  factory Expense.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Expense(
      id:        doc.id,
      category:  d['category'] ?? '',
      amount:    (d['amount'] ?? 0).toDouble(),
      note:      d['note'] ?? '',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'category':  category,
    'amount':    amount,
    'note':      note,
    'createdAt': FieldValue.serverTimestamp(),
  };
}