import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../core/constants/app_string.dart';           // AppStrings.categories
import '../../core/widgets/app_pill.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';           // ProductProvider
import '../core/widgets/app_alert.dart';
import 'widgets/product_card.dart';                       // ProductCard
import 'widgets/cart_fab.dart';                           // CartFAB
import 'cart/cart_drawer.dart';                        // CartDrawer
import 'receipt/receipt_dialog.dart';                  // ReceiptDialog


class POSScreen extends StatefulWidget {
  const POSScreen({super.key});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  String _activeCat = 'All';
  String _query = '';

  bool _showCart = false;
  bool _showReceipt = false;

  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final products = context.watch<ProductProvider>().products;

    final filtered = products.where((p) {
      final catOk = _activeCat == 'All' || p.category == _activeCat;
      final qOk = _query.isEmpty ||
          p.name.toLowerCase().contains(_query.toLowerCase());

      return catOk && qOk;
    }).toList();

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            /// ================= HEADER =================
            SliverToBoxAdapter(child: _buildHeader()),

            /// ================= SEARCH =================
            SliverToBoxAdapter(child: _buildSearch()),

            /// ================= CATEGORY =================
            SliverToBoxAdapter(child: _buildCategoryPills()),

            /// ================= PRODUCTS =================
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                20,
                0,
                20,
                cart.count > 0 ? 170 : 30,
              ),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (ctx, i) {
                    final product = filtered[i];

                    return ProductCard(
                      product: product,
                      onAdd: () {
                        final provider =
                        context.read<ProductProvider>();

                        /// 🔥 NEW SAFE LOGIC
                        if (product.trackStock) {
                          if (product.stock <= 0) {
                            AppAlert.show(
                              context,
                              message: "Stock නැත",
                              type: AlertType.warning,
                            );
                            return;
                          }

                          provider.decrementStock(product.id);
                        }

                        context.read<CartProvider>().addProduct(product);
                      },
                    );
                  },
                  childCount: filtered.length,
                ),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
              ),
            ),
          ],
        ),

        /// ================= CART BAR =================
        if (cart.count > 0)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: CartFAB(
              count: cart.count,
              total: cart.total,
              onOpen: () => setState(() => _showCart = true),
              onCheckout: () => setState(() => _showReceipt = true),
            ),
          ),

        /// ================= CART DRAWER =================
        if (_showCart)
          CartDrawer(
            onClose: () => setState(() => _showCart = false),
            onCheckout: () => setState(() {
              _showCart = false;
              _showReceipt = true;
            }),
          ),

        /// ================= RECEIPT =================
        if (_showReceipt && cart.count > 0)
          ReceiptDialog(
            onClose: () => setState(() => _showReceipt = false),
            onComplete: (invoiceId) {
              setState(() => _showReceipt = false);

              AppAlert.show(
                context,
                message: 'Order $invoiceId සාර්ථකව complete කරන ලදී',
                type: AlertType.success,
              );
            },
          ),
      ],
    );
  }

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'POINT OF SALE',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSec,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2),
        Text(
          'BunHut POS',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );

  Widget _buildSearch() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: _searchCtrl,
        decoration: const InputDecoration(
          hintText: 'Search products…',
          border: InputBorder.none,
          icon: Icon(Icons.search),
        ),
        onChanged: (v) => setState(() => _query = v),
      ),
    ),
  );

  Widget _buildCategoryPills() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
    child: Row(
      children: AppString.categories.map((c) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: AppPill(
            label: c,
            active: c == _activeCat,
            onTap: () => setState(() => _activeCat = c),
          ),
        );
      }).toList(),
    ),
  );
}