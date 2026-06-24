import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CartFAB extends StatelessWidget {

  final int count;
  final double total;

  final VoidCallback onOpen;
  final VoidCallback onCheckout;

  const CartFAB({
    super.key,
    required this.count,
    required this.total,
    required this.onOpen,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Row(
        children: [

          // Cart information area
          Expanded(
            child: GestureDetector(

              onTap: onOpen,

              child: Row(
                children: [

                  // Cart icon
                  const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),

                  const SizedBox(width: 10),

                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(
                        '$count Items',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),

                      Text(
                        'LKR ${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Checkout button
          ElevatedButton(

            onPressed: onCheckout,

            style: ElevatedButton.styleFrom(
              backgroundColor:
              AppColors.primary,
            ),

            child: const Text(
              'Checkout',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}