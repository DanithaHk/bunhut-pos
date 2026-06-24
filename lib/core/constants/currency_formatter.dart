import 'package:intl/intl.dart';

String formatLKR(num amount) {
  final formatter = NumberFormat('#,##0.##', 'en_US');
  return 'LKR ${formatter.format(amount)}';
}