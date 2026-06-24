import 'package:bunhut_pos/core/constants/app_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/currency_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../model/product.dart';
import '../../providers/product_provider.dart';
import '../widgets/product_form_sheet.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  /// ==========================
  /// CHANGED: category filter
  /// ==========================
  String _activeCat = 'All';

  /// ==========================
  /// CHANGED: search query
  /// ==========================
  String _query = '';

  final _searchCtrl = TextEditingController();

  final List<String> _categories = AppString.categories;

  /// ==========================================================
  /// CHANGED: Load products when screen opens
  /// THIS FIXES "PRODUCTS NOT SHOWING"
  /// ==========================================================
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<ProductProvider>();
    final products = provider.products;

    /// ==========================
    /// FILTER LOGIC (unchanged)
    /// ==========================
    final filtered = products.where((p) {
      final catOk = _activeCat == 'All' || p.category == _activeCat;
      final qOk   = _query.isEmpty ||
          p.name.toLowerCase().contains(_query.toLowerCase());
      return catOk && qOk;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildHeader(context, products.length),

            _buildSearch(),

            _buildCategoryPills(),

            _buildStockSummary(products),

            Expanded(
              child: provider.isLoading
                  ? const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.primary))
                  : filtered.isEmpty
                  ? _buildEmpty()
                  : _buildList(filtered),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context, null),
        backgroundColor: AppColors.primary,
        elevation: 0,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Product',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // HEADER (unchanged)
  // ==========================================================
  Widget _buildHeader(BuildContext context, int count) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
    child: Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.arrow_back_ios_new,
                color: AppColors.text, size: 16),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('INVENTORY',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSec,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  )),
              Text('Products  ·  $count items',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                    letterSpacing: -0.4,
                  )),
            ],
          ),
        ),
      ],
    ),
  );

  // ==========================================================
  // SEARCH (unchanged)
  // ==========================================================
  Widget _buildSearch() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 10)
        ],
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
                hintStyle: TextStyle(
                    color: AppColors.textTer, fontSize: 14),
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
              child: const Icon(Icons.close,
                  color: AppColors.textSec, size: 16),
            ),
        ],
      ),
    ),
  );

  // ==========================================================
  // CATEGORY (unchanged)
  // ==========================================================
  Widget _buildCategoryPills() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
    child: Row(
      children: _categories.map((c) {
        final active = c == _activeCat;
        return GestureDetector(
          onTap: () => setState(() => _activeCat = c),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: active ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                  color: active ? AppColors.primary : AppColors.border),
              boxShadow: active
                  ? [BoxShadow(
                  color: AppColors.primary.withOpacity(0.25),
                  blurRadius: 6)]
                  : [const BoxShadow(
                  color: Color(0x0A000000), blurRadius: 4)],
            ),
            child: Text(c,
                style: TextStyle(
                  color: active ? Colors.white : AppColors.text,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                )),
          ),
        );
      }).toList(),
    ),
  );

  // ==========================================================
  // STOCK SUMMARY (unchanged)
  // ==========================================================
  Widget _buildStockSummary(List<Product> products) {
    final outOfStock = products.where((p) => p.stock <= 0).length;
    final lowStock   = products.where((p) => p.stock > 0 && p.stock <= 5).length;
    final inStock    = products.where((p) => p.stock > 5).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Row(
        children: [
          _StockChip(
            label: 'In Stock',
            count: inStock,
            color: AppColors.income,
          ),
          const SizedBox(width: 8),
          _StockChip(
            label: 'Low',
            count: lowStock,
            color: AppColors.expense,
          ),
          const SizedBox(width: 8),
          _StockChip(
            label: 'Out',
            count: outOfStock,
            color: const Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PRODUCT LIST
  // ==========================================================
  Widget _buildList(List<Product> products) => ListView.builder(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
    itemCount: products.length,
    itemBuilder: (_, i) => _ProductTile(
      product: products[i],
      onEdit:   () => _openForm(context, products[i]),
      onDelete: () => _confirmDelete(context, products[i]),
    ),
  );

  Widget _buildEmpty() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
            color: AppColors.primaryTint,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(Icons.inventory_2_outlined,
              color: AppColors.primary, size: 32),
        ),
        const SizedBox(height: 14),
        const Text('No products found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            )),
        const SizedBox(height: 4),
        const Text('Tap + Add Product to get started.',
            style: TextStyle(fontSize: 13, color: AppColors.textSec)),
      ],
    ),
  );

  // ==========================================================
  // ADD / EDIT PRODUCT
  // ==========================================================
  void _openForm(BuildContext context, Product? existing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProductFormSheet(
        existing: existing,
        onSave: (product) {
          if (existing == null) {

            /// ADD PRODUCT
            context.read<ProductProvider>().addProduct(product);
          } else {

            /// ==========================
            /// CHANGED:
            /// FIXED UPDATE LOGIC
            /// ==========================
            context.read<ProductProvider>().updateProduct(product);
          }
        },
      ),
    );
  }

  // ==========================================================
  // DELETE
  // ==========================================================
  void _confirmDelete(BuildContext context, Product p) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Product',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text('Remove "${p.name}" from inventory?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSec)),
          ),
          TextButton(
            onPressed: () {
              context.read<ProductProvider>().deleteProduct(p.id);
              Navigator.pop(context);
            },
            child: const Text('Delete',
                style: TextStyle(
                  color: AppColors.expense,
                  fontWeight: FontWeight.w700,
                )),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// PRODUCT TILE
// ==========================================================
class _ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductTile({
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final p   = product;
    final out = p.stock <= 0;
    final low = p.stock > 0 && p.stock <= 5;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 10,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [

            // ── Colour swatch ──────────────────────────────
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: p.tone.withOpacity(0.25),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: p.tone.withOpacity(0.4)),
              ),
              child: Center(
                child: Text(
                  p.name.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: p.tone,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // ── Info ───────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Name
                  Text(p.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      )),
                  const SizedBox(height: 5),

                  // Category + Stock chips
                  Row(
                    children: [
                      // Category chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTint,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(p.category,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDark,
                            )),
                      ),
                      const SizedBox(width: 6),

                      // Stock chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: out
                              ? const Color(0xFFFEE2E2)
                              : low
                              ? AppColors.expenseTint
                              : const Color(0xFFD1FAE5),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 5, height: 5,
                              decoration: BoxDecoration(
                                color: out
                                    ? const Color(0xFFEF4444)
                                    : low
                                    ? AppColors.expense
                                    : AppColors.income,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              out  ? 'Out of stock'
                                  : low  ? '${p.stock} left (low)'
                                  : '${p.stock} in stock',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: out
                                    ? const Color(0xFFEF4444)
                                    : low
                                    ? AppColors.expense
                                    : AppColors.income,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Price
                  Text(formatLKR(p.price),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                        letterSpacing: -0.3,
                      )),
                ],
              ),
            ),

            // ── Edit / Delete buttons ──────────────────────
            Column(
              children: [
                _ActionBtn(
                  icon:  Icons.edit_outlined,
                  color: AppColors.primary,
                  bg:    AppColors.primaryTint,
                  onTap: onEdit,
                ),
                const SizedBox(height: 6),
                _ActionBtn(
                  icon:  Icons.delete_outline,
                  color: AppColors.expense,
                  bg:    AppColors.expenseTint,
                  onTap: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Small square action button ────────────────────────────────
class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.bg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 34, height: 34,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 17),
    ),
  );
}

// ── Stock summary chip ────────────────────────────────────────
class _StockChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StockChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: color.withOpacity(0.25)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6, height: 6,
          decoration: BoxDecoration(
              color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text('$count $label',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            )),
      ],
    ),
  );
}