import 'package:bunhut_pos/model/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final Order order;


  const OrderCard({
    super.key,
    required this.order,

  });

  @override
  Widget build(BuildContext context) {

    final dateStr =
    DateFormat('dd MMM yyyy').format(order.createdAt);

    final timeStr =
    DateFormat('hh:mm a').format(order.createdAt);


    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),

      elevation: 1,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),


      child: Padding(
        padding: const EdgeInsets.all(14),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [


            // Invoice + Total
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [

                Text(
                  'Invoice #${order.invoiceId}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),


                Text(
                  'LKR ${order.total.toStringAsFixed(2)}',

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

              ],
            ),


            const SizedBox(height: 10),



            // Date and Time
            Row(
              children: [

                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Colors.grey[600],
                ),


                const SizedBox(width: 5),


                Text(
                  dateStr,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13,
                  ),
                ),


                const SizedBox(width: 15),


                Icon(
                  Icons.access_time,
                  size: 14,
                  color: Colors.grey[600],
                ),


                const SizedBox(width: 5),


                Text(
                  timeStr,

                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13,
                  ),
                ),

              ],
            ),



            const SizedBox(height: 8),



            // Items
            Row(
              children: [

                Icon(
                  Icons.shopping_bag_outlined,
                  size: 14,
                  color: Colors.grey[600],
                ),


                const SizedBox(width: 5),


                Text(
                  '${order.itemCount} items',

                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13,
                  ),
                ),

              ],
            ),






          ],
        ),
      ),
    );
  }
}