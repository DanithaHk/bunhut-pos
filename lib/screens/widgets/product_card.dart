import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/product_placeholder.dart';
import '../../../model/product.dart';

class ProductCard extends StatefulWidget {

  final Product product;
  final VoidCallback onAdd;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAdd,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {

  bool isPressed = false;

  @override
  Widget build(BuildContext context) {

    Product product = widget.product;

    bool outOfStock = product.stock <= 0;

    bool lowStock =
        product.stock > 0 &&
            product.stock <= 5;

    return GestureDetector(

      // Finger press
      onTapDown: (_) {
        if (!outOfStock) {
          setState(() {
            isPressed = true;
          });
        }
      },

      // Finger release
      onTapUp: (_) {

        if (!outOfStock) {

          setState(() {
            isPressed = false;
          });

          widget.onAdd();
        }
      },

      // Cancel tap
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },

      child: AnimatedScale(

        scale: isPressed ? 0.96 : 1.0,

        duration: const Duration(
          milliseconds: 120,
        ),

        child: Opacity(

          opacity: outOfStock ? 0.5 : 1,

          child: Container(

            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: AppColors.surface,

              borderRadius:
              BorderRadius.circular(18),

              border: Border.all(
                color: AppColors.border,
              ),
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                // Product image area
                Stack(
                  children: [

                    ProductPlaceholder(
                      tone: product.tone,
                      label: product.category,
                      height: 96,
                    ),

                    // Stock badge
                    Positioned(
                      top: 8,
                      left: 8,

                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(50),
                        ),

                        child: Text(

                          outOfStock
                              ? 'OUT'
                              : '${product.stock} LEFT',

                          style: TextStyle(

                            fontSize: 10,

                            fontWeight:
                            FontWeight.bold,

                            color: outOfStock
                                ? Colors.red
                                : lowStock
                                ? Colors.orange
                                : Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Product Name
                Text(
                  product.name,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // Category
                Text(
                  product.category,

                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [

                    // Price
                    Expanded(
                      child: Text(
                        'LKR ${product.price.toStringAsFixed(0)}',

                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Add button
                    Container(

                      width: 35,
                      height: 35,

                      decoration: BoxDecoration(

                        color: outOfStock
                            ? Colors.grey
                            : AppColors.primary,

                        borderRadius:
                        BorderRadius.circular(10),
                      ),

                      child: Icon(
                        Icons.add,

                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}