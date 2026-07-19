import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/currency_formatter.dart';
import '../../core/widgets/app_alert.dart';

import '../../model/expense.dart';
import '../../providers/expense_provider.dart';


class ExpenseCard extends StatelessWidget {

  final Expense expense;


  const ExpenseCard({
    super.key,
    required this.expense,
  });



  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.only(bottom: 12),

      child: Card(

        elevation: 0,

        color: Colors.white,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: AppColors.border,
          ),
        ),


        child: ListTile(

          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),



          // CATEGORY ICON
          leading: CircleAvatar(

            radius: 22,

            backgroundColor:
            AppColors.expense.withOpacity(0.1),

            child: const Icon(

              Icons.receipt_long,

              color: AppColors.expense,

              size: 22,

            ),

          ),



          // DETAILS
          title: Text(

            expense.category,

            style: const TextStyle(

              fontSize: 15,

              fontWeight: FontWeight.w700,

              color: AppColors.text,

            ),

          ),



          subtitle: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [


              const SizedBox(height: 4),


              Text(

                expense.note,

                style: const TextStyle(

                  fontSize: 13,

                  color: AppColors.textSec,

                ),

              ),



              const SizedBox(height: 4),



              Text(

                _formatDate(expense.createdAt),

                style: const TextStyle(

                  fontSize: 12,

                  color: AppColors.textTer,

                ),

              ),


            ],

          ),




          // AMOUNT + DELETE
          trailing: Column(

            mainAxisAlignment:
            MainAxisAlignment.center,


            crossAxisAlignment:
            CrossAxisAlignment.end,


            children: [


              Text(

                formatLKR(
                  expense.amount,
                ),

                style: const TextStyle(

                  fontSize: 14,

                  fontWeight: FontWeight.bold,

                  color: AppColors.text,

                ),

              ),



              SizedBox(

                height: 32,

                width: 32,

                child: IconButton(

                  padding: EdgeInsets.zero,


                  icon: const Icon(

                    Icons.delete_outline,

                    size: 22,

                    color: Colors.red,

                  ),



                  onPressed: () async {


                    await context
                        .read<ExpenseProvider>()
                        .remove(
                      expense.id,
                    );



                    if(context.mounted){

                      AppAlert.show(

                        context,

                        message:
                        "වියදම ඉවත් කරන ලදී",

                        type:
                        AlertType.warning,

                      );

                    }


                  },


                ),

              ),


            ],

          ),


        ),

      ),

    );

  }





  String _formatDate(DateTime date){

    return "${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')} "
        "${date.hour.toString().padLeft(2,'0')}:${date.minute.toString().padLeft(2,'0')}";

  }


}