import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/enums/date_filter.dart';
import '../../providers/order_provider.dart';
import '../widgets/order_card.dart';



class OrdersHistoryScreen extends StatelessWidget {


  const OrdersHistoryScreen({
    super.key,
  });



  @override
  Widget build(BuildContext context) {


    return ChangeNotifierProvider(

      create: (_) => OrderProvider(),


      child: Scaffold(


        appBar: AppBar(

          title: const Text(
            "Orders History",
          ),

        ),



        body: Column(


          children: [



            Consumer<OrderProvider>(


              builder: (context, provider, child){


                return SingleChildScrollView(

                  scrollDirection: Axis.horizontal,


                  padding:
                  const EdgeInsets.all(8),


                  child: Row(

                    children: [


                      _filterChip(
                        "Today",
                        DateFilter.today,
                        provider,
                      ),


                      _filterChip(
                        "Week",
                        DateFilter.thisWeek,
                        provider,
                      ),


                      _filterChip(
                        "Month",
                        DateFilter.thisMonth,
                        provider,
                      ),


                      _filterChip(
                        "Last Month",
                        DateFilter.lastMonth,
                        provider,
                      ),


                      _filterChip(
                        "Year",
                        DateFilter.thisYear,
                        provider,
                      ),


                    ],

                  ),

                );

              },

            ),



            const Divider(),



            Expanded(


              child: Consumer<OrderProvider>(


                builder: (context, provider, child){



                  return StreamBuilder(


                    stream: provider.getOrders(),


                    builder: (context, snapshot){



                      if(snapshot.connectionState ==
                          ConnectionState.waiting){


                        return const Center(

                          child:
                          CircularProgressIndicator(),

                        );

                      }



                      if(snapshot.hasError){


                        return Center(

                          child: Text(
                            snapshot.error.toString(),
                          ),

                        );

                      }



                      final orders =
                          snapshot.data ?? [];



                      if(orders.isEmpty){


                        return const Center(

                          child: Text(
                            "No Orders Found",
                          ),

                        );

                      }




                      return ListView.builder(

                        itemCount: orders.length,

                        itemBuilder: (context, index) {

                          final order = orders[index];

                          return OrderCard(
                            order: order
                          );

                        },

                      );



                    },


                  );


                },

              ),


            ),



          ],

        ),

      ),

    );

  }






  Widget _filterChip(

      String title,

      DateFilter filter,

      OrderProvider provider,

      ){


    return Padding(

      padding:
      const EdgeInsets.symmetric(horizontal:4),


      child: ChoiceChip(


        label: Text(title),


        selected:
        provider.selectedFilter == filter,


        onSelected: (_){

          provider.changeFilter(filter);

        },

      ),

    );

  }


}