import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/currency_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/constants/app_string.dart';
import '../../core/widgets/app_alert.dart'; // ✅ ADD THIS

import '../../model/expense.dart';
import '../../providers/expense_provider.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {

  String _category = 'Spices';

  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final expenses = context.watch<ExpenseProvider>().expenses;

    final total = expenses.fold(
      0.0,
          (sum, expense) => sum + expense.amount,
    );

    final grouped = <String, List<Expense>>{};

    for (final expense in expenses) {
      grouped.putIfAbsent(expense.category, () => []).add(expense);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          const Text(
            'TRACKING',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSec,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 2),

          const Text(
            'Expenses',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),

          const SizedBox(height: 16),

          // TOTAL CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.expense, Color(0xFFEA580C)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TOTAL EXPENSES TODAY',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  formatLKR(total),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${expenses.length} entries across ${grouped.length} categories',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // QUICK ADD
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  'Quick Add',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [

                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _category,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: AppColors.bg,
                        ),
                        items: AppString.expenseCategories
                            .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _category = value!;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: TextField(
                        controller: _amountCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Amount',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: AppColors.bg,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: _noteCtrl,
                  decoration: InputDecoration(
                    hintText: 'Note (optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: AppColors.bg,
                  ),
                ),

                const SizedBox(height: 12),

                GestureDetector(
                  onTap: () {

                    final amt = double.tryParse(_amountCtrl.text);

                    // ❌ ERROR ALERT
                    if (amt == null || amt <= 0) {
                      AppAlert.show(
                        context,
                        message: 'අවලංගු මුදලක් ඇතුළත් කර ඇත',
                        type: AlertType.error,
                      );
                      return;
                    }

                    context.read<ExpenseProvider>().add(
                      Expense(
                        id: '',
                        category: _category,
                        amount: amt,
                        note: _noteCtrl.text.isEmpty
                            ? '$_category purchase'
                            : _noteCtrl.text,
                        createdAt: DateTime.now(),
                      ),
                    );

                    _amountCtrl.clear();
                    _noteCtrl.clear();

                    // ✅ SUCCESS ALERT
                    AppAlert.show(
                      context,
                      message: 'වියදම සාර්ථකව එකතු කරන ලදී',
                      type: AlertType.success,
                    );
                  },

                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.expense, Color(0xFFEA580C)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Add Expense',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // LIST
          ...grouped.entries.map((entry) {

            final catTotal = entry.value.fold(
              0.0,
                  (sum, e) => sum + e.amount,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
                  child: Row(
                    children: [

                      const Icon(Icons.circle,
                          size: 6, color: AppColors.expense),

                      const SizedBox(width: 8),

                      Text(entry.key,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700)),

                      const Spacer(),

                      Text(formatLKR(catTotal),
                          style: const TextStyle(
                              color: AppColors.expense)),
                    ],
                  ),
                ),

                AppCard(
                  padding: EdgeInsets.zero,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: entry.value.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, i) {

                      final e = entry.value[i];

                      return ListTile(
                        title: Text(e.note),
                        subtitle: Text(e.createdAt.toString()),
                        trailing: Text(formatLKR(e.amount)),

                        onLongPress: () {
                          context.read<ExpenseProvider>().remove(e.id);

                          // ✅ DELETE ALERT
                          AppAlert.show(
                            context,
                            message: 'වියදම ඉවත් කරන ලදී',
                            type: AlertType.warning,
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 14),
              ],
            );
          }),
        ],
      ),
    );
  }
}