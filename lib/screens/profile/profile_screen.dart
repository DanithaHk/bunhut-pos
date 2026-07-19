import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_alert.dart';
import '../../providers/app_auth_provider.dart';
import '../expenses/expense_history_screen.dart';
import '../ordersHistory/orders_history_screen.dart';
import 'user_management_screen.dart'; // Import target navigation terminal profile

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Connect access instances to tap values and display names
    final authProvider = Provider.of<AppAuthProvider>(context);
    final userModel = authProvider.currentUserModel;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          // ── Header Profile Summary Display Block ──
          Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.border)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: authProvider.isAdmin ? AppColors.primaryDark : AppColors.primaryTint,
                    child: Icon(
                      authProvider.isAdmin ? Icons.admin_panel_settings : Icons.person,
                      color: authProvider.isAdmin ? Colors.white : AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userModel?.email ?? 'Unknown User Profile',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.text),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: authProvider.isAdmin ? AppColors.primaryTint : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            authProvider.isAdmin ? 'ADMIN' : 'CASHIER',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: authProvider.isAdmin ? AppColors.primary : AppColors.textSec,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Settings Action Lists Navigation Option ──
          Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.border)),
            child: Column(
              children: [
                // ✅ TRIGGER INTERACTION TO OPEN USER ACTIONS & PERMISSIONS ROUTE SCREEN
                ListTile(
                  leading: const Icon(Icons.shield_outlined, color: AppColors.primary),
                  title: const Text('Account Security & Services', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    authProvider.isAdmin
                        ? 'Provision new user account & update passwords'
                        : 'Update account password metrics',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.textTer),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserManagementScreen()),
                    );
                  },
                ),

                const Divider(height: 1, color: AppColors.border),
                ListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: const Text('Orders History'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OrdersHistoryScreen()),
                    );
                  },
                ),
                Divider(height: 1, color: AppColors.border),

                ListTile(
                  leading: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: AppColors.expense,
                  ),
                  title: const Text(
                    'Expense History',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'View all business expenses',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    size: 20,
                  ),

                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ExpenseHistoryScreen(),
                      ),
                    );

                  },
                ),
                // Core System Logout Actions Item
                ListTile(
                  leading: const Icon(Icons.logout_outlined, color: AppColors.expense),
                  title: const Text('Log Out Account', style: TextStyle(fontSize: 14, color: AppColors.expense, fontWeight: FontWeight.w600)),
                  onTap: () async {
                    await authProvider.logout();

                    AppAlert.show(
                      context,
                      message: 'Logout Successful',
                      type: AlertType.success,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}