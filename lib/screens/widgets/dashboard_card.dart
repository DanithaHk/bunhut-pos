import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/currency_formatter.dart';
import '../../../core/widgets/app_card.dart';


class DashboardCard extends StatelessWidget {


  final String title;
  final double value;
  final IconData icon;


  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });



  @override
  Widget build(BuildContext context){


    return AppCard(

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children:[


          Icon(
            icon,
            color: AppColors.primary,
          ),


          const SizedBox(height:10),


          Text(
            title,
            style: const TextStyle(
              fontSize:12,
              color:AppColors.textSec,
            ),
          ),


          const SizedBox(height:5),


          Text(
            formatLKR(value),
            style:const TextStyle(
              fontSize:20,
              fontWeight:FontWeight.w700,
            ),
          )

        ],

      ),

    );

  }

}