import 'package:flutter/material.dart';


class OrderDetailsScreen extends StatelessWidget {

  const OrderDetailsScreen({
    super.key, required String orderId,
  });


  @override
  Widget build(BuildContext context) {


    final orderId =
    ModalRoute.of(context)!
        .settings
        .arguments as String;



    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Order Details",
        ),

      ),


      body: Center(

        child: Text(
          "Order ID: $orderId",
        ),

      ),

    );

  }

}