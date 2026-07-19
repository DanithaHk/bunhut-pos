import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  // ==========================
  // DATE HELPERS
  // ==========================

  DateTime _startOfDay() {
    final now = DateTime.now();

    return DateTime(
      now.year,
      now.month,
      now.day,
    );
  }


  DateTime _endOfDay() {
    final now = DateTime.now();

    return DateTime(
      now.year,
      now.month,
      now.day,
      23,
      59,
      59,
    );
  }


  DateTime _startOfMonth() {
    final now = DateTime.now();

    return DateTime(
      now.year,
      now.month,
    );
  }


  DateTime _startOfYear() {
    final now = DateTime.now();

    return DateTime(
      now.year,
    );
  }


  // ==========================
  // REUSABLE QUERY
  // ==========================

  Query _ordersBetween(
      DateTime start,
      DateTime end,
      ) {
    return _db
        .collection('orders')
        .where(
      'createdAt',
      isGreaterThanOrEqualTo: Timestamp.fromDate(start),
    )
        .where(
      'createdAt',
      isLessThanOrEqualTo: Timestamp.fromDate(end),
    );
  }


  double _getTotal(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return (data['total'] ?? 0).toDouble();
  }


  double _getExpense(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return (data['amount'] ?? 0).toDouble();
  }



  // ==========================
  // TODAY
  // ==========================

  Stream<double> todayRevenue() {

    return _ordersBetween(
      _startOfDay(),
      _endOfDay(),
    )
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.fold(
        0.0,
            (total, doc) {

          return total + _getTotal(doc);

        },
      );

    });
  }



  Stream<int> todayOrders() {

    return _ordersBetween(
      _startOfDay(),
      _endOfDay(),
    )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.length,
    );

  }



  // ==========================
  // THIS MONTH
  // ==========================

  Stream<double> monthRevenue() {

    return _ordersBetween(
      _startOfMonth(),
      DateTime.now(),
    )
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.fold(
        0.0,
            (total, doc) {

          return total + _getTotal(doc);

        },
      );

    });

  }



  Stream<int> monthOrders() {

    return _ordersBetween(
      _startOfMonth(),
      DateTime.now(),
    )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.length,
    );

  }



  // ==========================
  // LAST MONTH
  // ==========================

  Stream<double> lastMonthRevenue() {

    final now = DateTime.now();


    final start = DateTime(
      now.year,
      now.month - 1,
    );


    final end = DateTime(
      now.year,
      now.month,
      0,
      23,
      59,
      59,
    );


    return _ordersBetween(
      start,
      end,
    )
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.fold(
        0.0,
            (total, doc) {

          return total + _getTotal(doc);

        },
      );

    });

  }



  Stream<int> lastMonthOrders() {

    final now = DateTime.now();


    return _ordersBetween(
      DateTime(
        now.year,
        now.month - 1,
      ),
      DateTime(
        now.year,
        now.month,
        0,
      ),
    )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.length,
    );

  }



  // ==========================
  // THIS YEAR
  // ==========================

  Stream<double> yearRevenue() {

    return _ordersBetween(
      _startOfYear(),
      DateTime.now(),
    )
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.fold(
        0.0,
            (total, doc) {

          return total + _getTotal(doc);

        },
      );

    });

  }



  Stream<int> yearOrders() {

    return _ordersBetween(
      _startOfYear(),
      DateTime.now(),
    )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.length,
    );

  }



  // ==========================
  // TOTAL REVENUE
  // ==========================

  Stream<double> totalRevenue() {

    return _db
        .collection('orders')
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.fold(
        0.0,
            (total, doc) {

          return total + _getTotal(doc);

        },
      );

    });

  }



  // ==========================
  // TOTAL EXPENSES
  // ==========================

  Stream<double> totalExpenses() {

    return _db
        .collection('expenses')
        .snapshots()
        .map((snapshot) {

      return snapshot.docs.fold(
        0.0,
            (total, doc) {

          return total + _getExpense(doc);

        },
      );

    });

  }



  // ==========================
  // PROFIT
  // ==========================

  Stream<double> profit() {

    return totalRevenue()
        .asyncMap((revenue) async {

      final expenses =
      await totalExpenses().first;


      return revenue - expenses;

    });

  }

}