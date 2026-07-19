import 'package:flutter/material.dart';

import '../../screens/ordersHistory/order_detail.dart';
import 'app_routes.dart';



class RouteGenerator {


  static Route<dynamic> generateRoute(
      RouteSettings settings,
      ){


    switch(settings.name){


      case AppRoutes.orderDetails:


        final orderId =
        settings.arguments as String;


        return MaterialPageRoute(

          builder: (_) =>
              OrderDetailsScreen(
                orderId: orderId,
              ),

        );



      default:


        return MaterialPageRoute(

          builder: (_) => Scaffold(

            body: Center(

              child: Text(
                "Route Not Found: ${settings.name}",
              ),

            ),

          ),

        );

    }

  }


}