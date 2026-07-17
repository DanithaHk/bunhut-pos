import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/product_provider.dart';
import '../../model/product.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/product_card.dart';
import '../widgets/product_form_sheet.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  void _openForm(BuildContext context, {Product? product}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return ProductFormSheet(
          existing: product,
          onSave: (p) {
            if (product == null) {
              context.read<ProductProvider>().addProduct(p);
            } else {
              context.read<ProductProvider>().updateProduct(p);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final products = provider.products;

    return Scaffold(
      backgroundColor: AppColors.bg,

      appBar: AppBar(
        title: const Text("Products"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openForm(context),
          )
        ],
      ),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.products.isEmpty
          ? const Center(
        child: Text(
          "No products found",
          style: TextStyle(color: Colors.grey),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final product = products[index];

            return Stack(
              children: [
                ProductCard(
                  product: product,
                  onAdd: () {
                    // Admin view: open edit instead of add-to-cart
                    _openForm(context, product: product);
                  },
                ),

                /// 🔥 TRACK STOCK BADGE
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: product.trackStock
                          ? Colors.orange
                          : Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.trackStock
                          ? "STOCK"
                          : "UNLIMITED",
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _openForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}