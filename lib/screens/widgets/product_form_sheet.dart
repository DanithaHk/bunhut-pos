import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_string.dart';
import '../../../core/widgets/app_alert.dart';
import '../../../model/product.dart';

class ProductFormSheet extends StatefulWidget {
  final Product? existing;
  final Function(Product) onSave;

  const ProductFormSheet({
    super.key,
    this.existing,
    required this.onSave,
  });

  @override
  State<ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductFormSheetState extends State<ProductFormSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();

  String _category = AppString.productCategories.first;

  /// 🔥 NEW: track stock toggle
  bool _trackStock = true;

  static const _tones = {
    'Bun & Buggers ': '#E8B383',
    'Desert & Beverages': '#C7E5B5',
    'Rice': '#A7B98C',
    'Kottu': '#D6C07A',
    'Rice & Curry': '#9BC1BC',
  };

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();

    if (_isEdit) {
      final p = widget.existing!;
      _nameCtrl.text = p.name;
      _priceCtrl.text = p.price.toStringAsFixed(0);
      _stockCtrl.text = p.stock.toString();

      _category = AppString.productCategories.contains(p.category)
          ? p.category
          : AppString.productCategories.first;

      /// 🔥 LOAD EXISTING TRACK STOCK
      _trackStock = p.trackStock;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      AppAlert.show(
        context,
        message: "කරුණාකර සියලු fields නිවැරදිව පුරවන්න",
        type: AlertType.warning,
      );
      return;
    }

    try {
      final hex = _tones[_category]!.replaceAll('#', '');
      final tone = Color(int.parse('FF$hex', radix: 16));

      final product = Product(
        id: widget.existing?.id ?? '',
        name: _nameCtrl.text.trim(),
        price: double.parse(_priceCtrl.text.trim()),

        /// 🔥 IMPORTANT LOGIC
        stock: _trackStock
            ? int.parse(_stockCtrl.text.trim())
            : 0,

        trackStock: _trackStock,

        category: _category,
        tone: tone,
      );

      widget.onSave(product);

      AppAlert.show(
        context,
        message: _isEdit
            ? "Product එක සාර්ථකව update වුණා"
            : "Product එක සාර්ථකව add වුණා",
        type: AlertType.success,
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.pop(context);
      });
    } catch (e) {
      AppAlert.show(
        context,
        message: "Something went wrong. නැවත try කරන්න",
        type: AlertType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 14, 20, 28 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Text(
                  _isEdit ? 'Edit Product' : 'Add Product',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: AppColors.textSec),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _label('Product Name'),
            _field(
              ctrl: _nameCtrl,
              hint: 'e.g. Almond Croissant',
              validator: (v) =>
              v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Price (LKR)'),
                      _field(
                        ctrl: _priceCtrl,
                        hint: '0',
                        type: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (double.tryParse(v.trim()) == null) {
                            return 'Invalid';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Stock'),

                      /// 🔥 DISABLE IF TRACK STOCK OFF
                      TextFormField(
                        controller: _stockCtrl,
                        enabled: _trackStock,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (!_trackStock) return null;
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (int.tryParse(v.trim()) == null) return 'Invalid';
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: _trackStock ? '0' : 'Unlimited',
                          filled: true,
                          fillColor: AppColors.bg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// 🔥 TRACK STOCK SWITCH
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Text(
                    "Track Stock",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Switch(
                    value: _trackStock,
                    onChanged: (v) {
                      setState(() {
                        _trackStock = v;

                        /// auto reset stock if turned off
                        if (!v) {
                          _stockCtrl.text = "0";
                        }
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            _label('Category'),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _category,
                  isExpanded: true,
                  items: AppString.productCategories
                      .map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(c),
                  ))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v!),
                ),
              ),
            ),

            const SizedBox(height: 24),

            GestureDetector(
              onTap: _save,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    _isEdit ? 'Save Changes' : 'Add Product',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSec,
      ),
    ),
  );

  Widget _field({
    required TextEditingController ctrl,
    required String hint,
    TextInputType type = TextInputType.text,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        controller: ctrl,
        keyboardType: type,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: AppColors.bg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
}