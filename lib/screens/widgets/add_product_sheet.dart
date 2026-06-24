import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_string.dart';
import '../../../model/product.dart';
import '../../../providers/product_provider.dart';

class AddProductSheet extends StatefulWidget {
  final Function(Product) onSave;

  const AddProductSheet({super.key, required this.onSave});

  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet> {
  final _nameCtrl     = TextEditingController();
  final _priceCtrl    = TextEditingController();
  final _stockCtrl    = TextEditingController();
  final _formKey      = GlobalKey<FormState>();
  String _category    = 'Bakery';

  // Tone map — matches the prototype colour per category
  static const Map<String, String> _categoryTones = {
    'Bakery':    '#E8B383',
    'Beverages': '#C7E5B5',
    'Spices':    '#A7B98C',
  };

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final toneHex = _categoryTones[_category] ?? '#FCD9A6';
    final hex     = toneHex.replaceAll('#', '');
    final tone    = Color(int.parse('FF$hex', radix: 16));

    final product = Product(
      id:       '',           // Firestore will generate the real id
      name:     _nameCtrl.text.trim(),
      price:    double.parse(_priceCtrl.text.trim()),
      stock:    int.parse(_stockCtrl.text.trim()),
      category: _category,
      tone:     tone,
    );

    widget.onSave(product);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Respect keyboard insets so the sheet lifts above the keyboard
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
            // ── Drag handle ──────────────────────────────────
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // ── Title row ────────────────────────────────────
            Row(
              children: [
                const Text('Add Product',
                    style: TextStyle(
                      fontSize: 19, fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    )),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: AppColors.textSec, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Product name ─────────────────────────────────
            _label('Product Name'),
            _buildField(
              controller: _nameCtrl,
              hint:       'e.g. Almond Croissant',
              validator:  (v) => v == null || v.trim().isEmpty
                  ? 'Product name is required' : null,
            ),
            const SizedBox(height: 14),

            // ── Price & Stock row ─────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Price (LKR)'),
                      _buildField(
                        controller:   _priceCtrl,
                        hint:         '0',
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (double.tryParse(v.trim()) == null) return 'Invalid';
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
                      _buildField(
                        controller:   _stockCtrl,
                        hint:         '0',
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (int.tryParse(v.trim()) == null) return 'Invalid';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── Category dropdown ─────────────────────────────
            _label('Category'),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color:        AppColors.bg,
                borderRadius: BorderRadius.circular(12),
                border:       Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _category,
                  isExpanded: true,
                  style: const TextStyle(
                    fontSize: 15, color: AppColors.text,
                  ),
                  items: AppString.categories   // ['Bakery','Beverages','Spices']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v!),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Save button ───────────────────────────────────
            GestureDetector(
              onTap: _save,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topCenter,
                    end:   Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color:  AppColors.primary.withOpacity(0.32),
                      blurRadius: 14, offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('Save Product',
                        style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text,
        style: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.w600,
          color: AppColors.textSec, letterSpacing: 0.2,
        )),
  );

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        controller:   controller,
        keyboardType: keyboardType,
        validator:    validator,
        style: const TextStyle(fontSize: 15, color: AppColors.text),
        decoration: InputDecoration(
          hintText:      hint,
          hintStyle:     const TextStyle(color: AppColors.textTer),
          filled:        true,
          fillColor:     AppColors.bg,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:   const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:   const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:   const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:   const BorderSide(color: AppColors.expense),
          ),
        ),
      );
}