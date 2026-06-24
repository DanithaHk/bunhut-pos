import 'package:bunhut_pos/providers/app_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_colors.dart';

import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/order_provider.dart';
import 'providers/expense_provider.dart';

import 'screens/auth/login_screen.dart';
import 'screens/pos_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/product/product_screen.dart';
import 'screens/expenses/expenses_screen.dart';
import 'screens/profile/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  runApp(const BunHutApp());
}

/// ================= APP ROOT =================
class BunHutApp extends StatelessWidget {
  const BunHutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()..loadProducts()),
        ChangeNotifierProvider(create: (_) => OrderProvider()..loadOrders()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()..loadExpenses()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const AuthWrapper(),
      ),
    );
  }
}
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }

        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        return const MainShell();
      },
    );
  }
}

/// Simple loader screen
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AppAuthProvider>(context);
    final isAdmin = auth.isAdmin;
    print(isAdmin);
    /// ================= SCREENS =================
    final screens = <Widget>[
      const POSScreen(),

      if (isAdmin) const DashboardScreen(),
      if (isAdmin) const ProductScreen(),

      const ExpensesScreen(),
      const ProfileScreen(),
    ];

    /// ================= NAV ITEMS =================
    final items = <NavigationDestination>[
      const NavigationDestination(
        icon: Icon(Icons.shopping_bag_outlined),
        label: 'POS',
      ),

      if (isAdmin)
        const NavigationDestination(
          icon: Icon(Icons.bar_chart_outlined),
          label: 'Dashboard',
        ),

      if (isAdmin)
        const NavigationDestination(
          icon: Icon(Icons.inventory_2_outlined),
          label: 'Products',
        ),

      const NavigationDestination(
        icon: Icon(Icons.account_balance_wallet_outlined),
        label: 'Expenses',
      ),

      const NavigationDestination(
        icon: Icon(Icons.person_outline),
        label: 'Profile',
      ),
    ];

    /// FIX INDEX CRASH
    if (index >= screens.length) index = 0;

    return Scaffold(
      backgroundColor: AppColors.bg,

      body: SafeArea(
        child: screens[index],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: items,
      ),
    );
  }
}
