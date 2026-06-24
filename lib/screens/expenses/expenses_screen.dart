import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/currency_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/constants/app_string.dart';

import '../../model/expense.dart';
import '../../providers/expense_provider.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {

  // =====================================================
  // Selected category for new expense
  // =====================================================
  String _category = 'Spices';

  // =====================================================
  // Text controllers
  // =====================================================
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {

    // Release memory when screen is closed
    _amountCtrl.dispose();
    _noteCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // =====================================================
    // Get expenses from provider
    // =====================================================
    final expenses = context.watch<ExpenseProvider>().expenses;

    // Calculate total expense amount
    final total = expenses.fold(
      0.0,
          (sum, expense) => sum + expense.amount,
    );

    // =====================================================
    // Group expenses by category
    // Example:
    // Bakery -> [expense1, expense2]
    // Spices -> [expense3]
    // =====================================================
    final grouped = <String, List<Expense>>{};

    for (final expense in expenses) {
      grouped.putIfAbsent(
        expense.category,
            () => [],
      ).add(expense);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          // =================================================
          // HEADER
          // =================================================

          const Text(
            'TRACKING',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSec,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),

          const SizedBox(height: 2),

          const Text(
            'Expenses',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
              letterSpacing: -0.4,
            ),
          ),

          const SizedBox(height: 16),

          // =================================================
          // TOTAL EXPENSE CARD
          // =================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.expense,
                  Color(0xFFEA580C),
                ],
              ),

              borderRadius: BorderRadius.circular(16),

              boxShadow: [
                BoxShadow(
                  color: AppColors.expense.withOpacity(0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const Text(
                  'TOTAL EXPENSES TODAY',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 6),

                // Total Expense Amount
                Text(
                  formatLKR(total),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 4),

                // Number of expenses and categories
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

          // =================================================
          // QUICK ADD EXPENSE CARD
          // =================================================

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const Text(
                  'Quick Add',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),

                const SizedBox(height: 12),

                // =============================================
                // Category + Amount
                // =============================================

                Row(
                  children: [

                    // Category Dropdown
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _category,

                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),

                          filled: true,
                          fillColor: AppColors.bg,
                        ),

                        items: AppString.expenseCategories
                            .map(
                              (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                            .toList(),

                        onChanged: (value) {
                          setState(() {
                            _category = value!;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Amount Field
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

                // =============================================
                // Note Field
                // =============================================

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

                // =============================================
                // ADD EXPENSE BUTTON
                // =============================================

                GestureDetector(
                  onTap: () {

                    // Convert amount text to double
                    final amt =
                    double.tryParse(_amountCtrl.text);

                    if (amt == null) return;

                    // Add expense to provider
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

                    // Clear text fields
                    _amountCtrl.clear();
                    _noteCtrl.clear();
                  },

                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 13,
                    ),

                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.expense,
                          Color(0xFFEA580C),
                        ],
                      ),

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,

                      children: const [

                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),

                        SizedBox(width: 8),

                        Text(
                          'Add Expense',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
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

          // =================================================
          // EXPENSE LIST GROUPED BY CATEGORY
          // =================================================

          ...grouped.entries.map((entry) {

            // Calculate category total
            final catTotal = entry.value.fold(
              0.0,
                  (sum, expense) => sum + expense.amount,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                // ===========================================
                // CATEGORY HEADER
                // ===========================================

                Padding(
                  padding:
                  const EdgeInsets.fromLTRB(4, 4, 4, 8),

                  child: Row(
                    children: [

                      const SizedBox(
                        width: 6,
                        height: 6,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.expense,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(width: 6),

                      Text(
                        '· ${entry.value.length}',
                      ),

                      const Spacer(),

                      Text(
                        formatLKR(catTotal),
                        style: const TextStyle(
                          color: AppColors.expense,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                // ===========================================
                // CATEGORY EXPENSES
                // ===========================================

                AppCard(
                  padding: EdgeInsets.zero,

                  child: ListView.separated(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),

                    itemCount: entry.value.length,

                    separatorBuilder: (_, __) =>
                    const Divider(),

                    itemBuilder: (_, i) {

                      final e = entry.value[i];

                      return Padding(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),

                        child: Row(
                          children: [

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,

                                children: [

                                  Text(e.note),

                                  Text(
                                    e.createdAt.toString(),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              formatLKR(e.amount),
                            ),

                            const SizedBox(width: 10),

                            // Delete Expense
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<ExpenseProvider>()
                                    .remove(e.id);
                              },

                              child: Container(
                                width: 30,
                                height: 30,

                                decoration: BoxDecoration(
                                  color:
                                  AppColors.expenseTint,
                                  borderRadius:
                                  BorderRadius.circular(
                                      8),
                                ),

                                child: const Icon(
                                  Icons.delete_outline,
                                  color:
                                  AppColors.expense,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 14),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}