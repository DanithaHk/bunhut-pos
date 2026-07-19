import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/currency_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/enums/expense_filter.dart';

import '../../providers/expense_provider.dart';
import '../widgets/expenseCard.dart';



class ExpenseHistoryScreen extends StatelessWidget {


  const ExpenseHistoryScreen({
    super.key,
  });



  @override
  Widget build(BuildContext context) {


    final expenseProvider =
    context.watch<ExpenseProvider>();


    final expenses =
        expenseProvider.expenses;



    final total = expenses.fold(
      0.0,
          (sum, expense) =>
      sum + expense.amount,
    );



    double categoryTotal(String category) {

      return expenses
          .where(
            (e) => e.category == category,
      )
          .fold(
        0.0,
            (sum, expense) =>
        sum + expense.amount,
      );

    }





    return Scaffold(


      backgroundColor: AppColors.bg,



      appBar: AppBar(

        title: const Text(
          "Expense History",
        ),

        backgroundColor: Colors.white,

        elevation: 0,

        foregroundColor: AppColors.text,

      ),




      body: ListView(


        padding:
        const EdgeInsets.all(20),



        children: [



          // =========================
          // FILTER BUTTONS
          // =========================


          SingleChildScrollView(

            scrollDirection:
            Axis.horizontal,


            child: Row(


              children:
              ExpenseFilter.values.map(
                      (filter) {


                    return Padding(


                      padding:
                      const EdgeInsets.only(
                          right: 8
                      ),



                      child: ChoiceChip(


                        label: Text(
                          _filterName(filter),
                        ),



                        selected:
                        expenseProvider.filter
                            ==
                            filter,



                        selectedColor:
                        AppColors.expense,



                        labelStyle:
                        TextStyle(

                          color:
                          expenseProvider.filter
                              ==
                              filter
                              ?
                          Colors.white
                              :
                          AppColors.text,


                          fontWeight:
                          FontWeight.w600,

                        ),



                        onSelected: (_) {


                          context
                              .read<
                              ExpenseProvider>()
                              .changeFilter(
                              filter
                          );


                        },


                      ),


                    );


                  }

              ).toList(),

            ),

          ),




          const SizedBox(height:24),





          // =========================
          // SUMMARY TITLE
          // =========================


          const Text(

            "Expense Summary",

            style:
            TextStyle(

              fontSize:18,

              fontWeight:
              FontWeight.w700,

              color:
              AppColors.text,

            ),

          ),





          const SizedBox(height:12),





          // =========================
          // TOTAL + FOOD
          // =========================



          Row(

            children: [



              Expanded(

                child: _summaryCard(

                  title:
                  "Total Expense",

                  amount:
                  total,

                  icon:
                  Icons.account_balance_wallet,

                ),

              ),




              const SizedBox(
                  width:12
              ),




              Expanded(

                child: _summaryCard(

                  title:
                  "Food",

                  amount:
                  categoryTotal(
                      "Food"
                  ),

                  icon:
                  Icons.restaurant,

                ),

              ),



            ],

          ),





          const SizedBox(height:12),






          // =========================
          // UTILITY + SALARY
          // =========================



          Row(

            children: [



              Expanded(

                child: _summaryCard(

                  title:
                  "Utility",

                  amount:
                  categoryTotal(
                      "Utility"
                  ),

                  icon:
                  Icons.bolt,

                ),

              ),




              const SizedBox(
                  width:12
              ),




              Expanded(

                child: _summaryCard(

                  title:
                  "Salary",

                  amount:
                  categoryTotal(
                      "Salary"
                  ),

                  icon:
                  Icons.people,

                ),

              ),



            ],

          ),






          const SizedBox(height:12),





          // OTHER


          _summaryCard(

            title:
            "Other",

            amount:
            categoryTotal(
                "Other"
            ),

            icon:
            Icons.more_horiz,

          ),





          const SizedBox(height:24),






          // =========================
          // EXPENSE LIST TITLE
          // =========================



          Row(


            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,



            children: [



              const Text(

                "Expense Records",

                style:
                TextStyle(

                  fontSize:18,

                  fontWeight:
                  FontWeight.w700,

                  color:
                  AppColors.text,

                ),

              ),




              Text(

                "${expenses.length} Items",

                style:
                const TextStyle(

                  fontSize:12,

                  color:
                  AppColors.textSec,

                ),

              ),



            ],


          ),





          const SizedBox(height:12),






          // =========================
          // EXPENSE CARDS
          // =========================



          if(expenses.isEmpty)


            const AppCard(


              child:
              Padding(

                padding:
                EdgeInsets.all(20),


                child:
                Center(

                  child:
                  Text(

                    "No expenses found",

                    style:
                    TextStyle(

                      color:
                      AppColors.textSec,

                    ),

                  ),

                ),

              ),


            )



          else


            ...expenses.map(

                  (expense) => ExpenseCard(

                expense:
                expense,

              ),

            ),




        ],

      ),


    );


  }







  Widget _summaryCard({

    required String title,

    required double amount,

    required IconData icon,

  }) {



    return AppCard(


      child:
      Column(


        crossAxisAlignment:
        CrossAxisAlignment.start,



        children: [



          Container(


            padding:
            const EdgeInsets.all(8),



            decoration:
            BoxDecoration(


              color:
              AppColors.expense
                  .withOpacity(.1),



              borderRadius:
              BorderRadius.circular(10),


            ),



            child:
            Icon(

              icon,

              size:20,

              color:
              AppColors.expense,

            ),


          ),





          const SizedBox(height:10),




          Text(

            title,

            style:
            const TextStyle(

              fontSize:12,

              color:
              AppColors.textSec,

            ),

          ),





          const SizedBox(height:4),




          Text(

            formatLKR(amount),


            maxLines:1,


            overflow:
            TextOverflow.ellipsis,



            style:
            const TextStyle(

              fontSize:16,

              fontWeight:
              FontWeight.bold,

              color:
              AppColors.text,

            ),

          ),



        ],


      ),


    );


  }







  String _filterName(
      ExpenseFilter filter
      ) {


    switch(filter) {


      case ExpenseFilter.today:

        return "Today";


      case ExpenseFilter.thisWeek:

        return "This Week";


      case ExpenseFilter.thisMonth:

        return "This Month";


      case ExpenseFilter.thisYear:

        return "This Year";


      case ExpenseFilter.all:

        return "All";


    }


  }



}