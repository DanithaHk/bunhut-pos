import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';

class CartDrawer extends StatelessWidget {

  final VoidCallback onClose;
  final VoidCallback onCheckout;

  const CartDrawer({
    super.key,
    required this.onClose,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {

    final cart = context.watch<CartProvider>();

    return Drawer(

      child: Column(
        children: [

          // Header
          AppBar(
            title: const Text("Cart"),
            automaticallyImplyLeading: false,
            actions: [

              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close),
              ),

            ],
          ),

          // Empty cart
          if (cart.items.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  "Cart is Empty",
                ),
              ),
            )

          else

          // Cart Items
            Expanded(
              child: ListView.builder(

                itemCount: cart.items.length,

                itemBuilder: (context, index) {

                  final item = cart.items[index];

                  return ListTile(

                    title: Text(item.name),

                    subtitle: Text(
                      "Qty : ${item.qty}",
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [

                        // Minus button
                        IconButton(
                          icon: const Icon(Icons.remove),

                          onPressed: () {

                            context
                                .read<ProductProvider>()
                                .incrementStock(
                                item.productId);

                            cart.decrement(
                                item.productId);
                          },
                        ),

                        // Plus button
                        IconButton(
                          icon: const Icon(Icons.add),

                          onPressed: () {

                            cart.increment(
                                item.productId);
                          },
                        ),

                        // Delete button
                        IconButton(
                          icon: const Icon(Icons.delete),

                          onPressed: () {

                            context
                                .read<ProductProvider>()
                                .restoreStock(
                              item.productId,
                              item.qty,
                            );

                            cart.remove(
                                item.productId);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

          // Total section
          Container(

            padding: const EdgeInsets.all(15),

            child: Column(
              children: [

                Row(
                  children: [

                    const Text("Subtotal"),

                    const Spacer(),

                    Text(
                      "LKR ${cart.subtotal}",
                    ),
                  ],
                ),

                Row(
                  children: [

                    const Text("Tax"),

                    const Spacer(),

                    Text(
                      "LKR ${cart.tax}",
                    ),
                  ],
                ),

                Row(
                  children: [

                    const Text(
                      "Total",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      "LKR ${cart.total}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(

                    onPressed: onCheckout,

                    child: const Text(
                      "Checkout",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}