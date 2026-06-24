import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../core/service/order_service.dart';

class ReceiptDialog extends StatelessWidget {

  final VoidCallback onClose;
  final Function(String) onComplete;

  const ReceiptDialog({
    super.key,
    required this.onClose,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {

    final cart = context.read<CartProvider>();

    String invoiceId =
        "INV-${DateTime.now().millisecondsSinceEpoch}";

    return AlertDialog(

      title: const Text("Receipt"),

      content: SizedBox(
        width: double.maxFinite,

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [

            // Products
            ...cart.items.map((item) {

              return ListTile(
                title: Text(item.name),

                subtitle: Text(
                  "${item.qty} x ${item.price}",
                ),

                trailing: Text(
                  "${item.lineTotal}",
                ),
              );

            }).toList(),

            const Divider(),

            // Bill Summary
            Row(
              children: [
                const Text("Subtotal"),
                const Spacer(),
                Text("LKR ${cart.subtotal}"),
              ],
            ),

            Row(
              children: [
                const Text("Tax"),
                const Spacer(),
                Text("LKR ${cart.tax}"),
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
          ],
        ),
      ),

      actions: [

        // Cancel Button
        TextButton(
          onPressed: onClose,
          child: const Text("Cancel"),
        ),

        // Save Order Button
        ElevatedButton(

          onPressed: () async {

            await OrderService().placeOrder(
              invoiceId,
              cart.items,
              cart.total,
              cart.subtotal,
              cart.tax,
            );

            cart.clear();

            onComplete(invoiceId);
          },

          child: const Text("Print Bill"),
        ),
      ],
    );
  }
}