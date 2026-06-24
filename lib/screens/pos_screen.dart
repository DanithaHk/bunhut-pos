import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../core/constants/app_string.dart';           // AppStrings.categories
import '../../core/widgets/app_pill.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';           // ProductProvider
import 'widgets/product_card.dart';                       // ProductCard
import 'widgets/cart_fab.dart';                           // CartFAB
import 'widgets/add_product_sheet.dart';                  // AddProductSheet
import 'cart/cart_drawer.dart';                        // CartDrawer
import 'receipt/receipt_dialog.dart';                  // ReceiptDialog


class POSScreen extends StatefulWidget {
  const POSScreen({super.key});
  @override State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  String _activeCat = 'All';
  String _query = '';
  bool _showCart = false;
  bool _showReceipt = false;
  final _searchCtrl = TextEditingController();

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final products = context.watch<ProductProvider>().products;

    final filtered = products.where((p) {
      final catOk = _activeCat == 'All' || p.category == _activeCat;
      final qOk   = _query.isEmpty ||
          p.name.toLowerCase().contains(_query.toLowerCase());
      return catOk && qOk;
    }).toList();

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // ── Header ──────────────────────────────────────
            SliverToBoxAdapter(child: _buildHeader()),
            // ── Search ──────────────────────────────────────
            SliverToBoxAdapter(child: _buildSearch()),
            // ── Category pills ──────────────────────────────
            SliverToBoxAdapter(child: _buildCategoryPills()),
            // ── Product grid ────────────────────────────────
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 0, 20,
                  cart.count > 0 ? 170 : 30),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (ctx, i) => ProductCard(
                    product: filtered[i],
                    onAdd: () {
                      context.read<ProductProvider>().decrementStock(filtered[i].id);
                      context.read<CartProvider>().addProduct(filtered[i]);
                    },
                  ),
                  childCount: filtered.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12, mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
              ),
            ),
          ],
        ),

        // ── Floating cart bar ────────────────────────────────
        if (cart.count > 0)
          Positioned(
            left: 16, right: 16, bottom: 16,
            child: CartFAB(
              count: cart.count,
              total: cart.total,
              onOpen:     () => setState(() => _showCart    = true),
              onCheckout: () => setState(() => _showReceipt = true),
            ),
          ),

        // ── Cart drawer ───────────────────────────────────────
        if (_showCart)
          CartDrawer(
            onClose:    () => setState(() => _showCart    = false),
            onCheckout: () => setState(() {
              _showCart    = false;
              _showReceipt = true;
            }),
          ),

        // ── Receipt dialog ─────────────────────────────────────
        if (_showReceipt && cart.count > 0)
          ReceiptDialog(
            onClose: () => setState(() => _showReceipt = false),
            onComplete: (invoiceId) {
              setState(() => _showReceipt = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order $invoiceId printed'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
    child: Row(
      children: [
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('POINT OF SALE',
                style: TextStyle(fontSize: 12, color: AppColors.textSec,
                    fontWeight: FontWeight.w500, letterSpacing: 0.3)),
            SizedBox(height: 2),
            Text('BunHut POS',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700,
                    color: AppColors.text, letterSpacing: -0.4)),
          ],
        )),
        GestureDetector(
          onTap: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => AddProductSheet(
              onSave: (p) => context.read<ProductProvider>().addProduct(p),
            ),
          ),
          child: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(
                color: AppColors.primary.withOpacity(0.32),
                blurRadius: 14, offset: const Offset(0, 6),
              )],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 22),
          ),
        ),
      ],
    ),
  );

  Widget _buildSearch() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 12)],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.textSec, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration.collapsed(
                hintText: 'Search products…',
                hintStyle: TextStyle(color: AppColors.textTer),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          if (_query.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchCtrl.clear();
                setState(() => _query = '');
              },
              child: const Icon(Icons.close, color: AppColors.textSec, size: 16),
            ),
        ],
      ),
    ),
  );

  Widget _buildCategoryPills() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
    child: Row(
      children: AppString.categories.map((c) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: AppPill(
          label: c,
          active: c == _activeCat,
          onTap: () => setState(() => _activeCat = c),
        ),
      )).toList(),
    ),
  );
}