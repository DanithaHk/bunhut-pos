import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/currency_formatter.dart';
import '../../../core/widgets/app_card.dart';

import '../../../providers/order_provider.dart';

import '../../core/service/dashboard_service.dart';
import '../widgets/dashboard_card.dart';



class DashboardScreen extends StatelessWidget {


  const DashboardScreen({
    super.key,
  });



  @override
  Widget build(BuildContext context) {


    final dashboardService =
    DashboardService();


    final orders =
        context.watch<OrderProvider>().orders;



    return SingleChildScrollView(

      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        24,
      ),


      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,


        children: [



          // ==========================
          // HEADER
          // ==========================


          const Text(
            "OVERVIEW",

            style: TextStyle(
              fontSize:12,
              color:AppColors.textSec,
              fontWeight:FontWeight.w500,
            ),

          ),



          const SizedBox(height:4),



          const Text(
            "Dashboard",

            style:TextStyle(
              fontSize:26,
              fontWeight:FontWeight.w700,
              color:AppColors.text,
            ),

          ),



          const SizedBox(height:20),





          // ==========================
          // DASHBOARD CARDS
          // ==========================


          GridView.count(

            shrinkWrap:true,

            physics:
            const NeverScrollableScrollPhysics(),


            crossAxisCount:2,


            crossAxisSpacing:12,

            mainAxisSpacing:12,


            childAspectRatio:1.45,



            children:[



              _RevenueCard(
                title:"Today's Income",
                stream:
                dashboardService.todayRevenue(),
                icon:
                Icons.today,
              ),




              _CountCard(
                title:"Today's Orders",
                stream:
                dashboardService.todayOrders(),
                icon:
                Icons.shopping_cart,
              ),




              _RevenueCard(
                title:"This Month Income",
                stream:
                dashboardService.monthRevenue(),
                icon:
                Icons.calendar_month,
              ),




              _CountCard(
                title:"This Month Orders",
                stream:
                dashboardService.monthOrders(),
                icon:
                Icons.receipt_long,
              ),




              _RevenueCard(
                title:"Last Month Income",
                stream:
                dashboardService.lastMonthRevenue(),
                icon:
                Icons.history,
              ),




              _CountCard(
                title:"Last Month Orders",
                stream:
                dashboardService.lastMonthOrders(),
                icon:
                Icons.shopping_bag,
              ),




              _RevenueCard(
                title:"This Year Income",
                stream:
                dashboardService.yearRevenue(),
                icon:
                Icons.date_range,
              ),




              _CountCard(
                title:"This Year Orders",
                stream:
                dashboardService.yearOrders(),
                icon:
                Icons.analytics,
              ),





              _RevenueCard(
                title:"Total Revenue",
                stream:
                dashboardService.totalRevenue(),
                icon:
                Icons.attach_money,
              ),




              _RevenueCard(
                title:"Total Expenses",
                stream:
                dashboardService.totalExpenses(),
                icon:
                Icons.money_off,
              ),





              _RevenueCard(
                title:"Net Profit",
                stream:
                dashboardService.profit(),
                icon:
                Icons.trending_up,
              ),



            ],

          ),




          const SizedBox(height:25),





          // ==========================
          // RECENT ORDERS
          // ==========================



          Row(

            children:[

              const Text(
                "Recent Orders",

                style:TextStyle(
                  fontSize:16,
                  fontWeight:
                  FontWeight.w700,
                ),

              ),


              const Spacer(),


              Text(
                "View All",

                style:TextStyle(
                  color:
                  AppColors.primary,
                  fontWeight:
                  FontWeight.w600,
                ),

              ),

            ],

          ),



          const SizedBox(height:12),




          AppCard(

            padding:
            EdgeInsets.zero,


            child:
            ListView.separated(

              shrinkWrap:true,

              physics:
              const NeverScrollableScrollPhysics(),


              itemCount:
              orders.length.clamp(0,5),



              separatorBuilder:
                  (_,__) =>
              const Divider(
                height:1,
                color:
                AppColors.divider,
              ),




              itemBuilder:
                  (_,index){



                final order =
                orders[index];



                return ListTile(


                  leading:
                  Container(

                    width:38,
                    height:38,


                    decoration:
                    BoxDecoration(

                      color:
                      AppColors.primaryTint,

                      borderRadius:
                      BorderRadius.circular(10),

                    ),


                    child:
                    const Icon(
                      Icons.shopping_bag,
                      color:
                      AppColors.primary,
                    ),

                  ),



                  title:
                  Text(
                    order.invoiceId,

                    style:
                    const TextStyle(
                      fontWeight:
                      FontWeight.w600,
                    ),

                  ),



                  subtitle:
                  Text(
                    "${order.itemCount} items",

                  ),



                  trailing:
                  Text(

                    formatLKR(
                      order.total,
                    ),

                    style:
                    const TextStyle(
                      fontWeight:
                      FontWeight.w700,
                    ),

                  ),


                );


              },


            ),

          ),


        ],

      ),

    );


  }

}






// =====================================
// REVENUE CARD
// =====================================


class _RevenueCard extends StatelessWidget {


  final String title;

  final Stream<double> stream;

  final IconData icon;



  const _RevenueCard({

    required this.title,

    required this.stream,

    required this.icon,

  });



  @override
  Widget build(BuildContext context){


    return StreamBuilder<double>(


      stream:stream,


      builder:(context,snapshot){


        return DashboardCard(

          title:title,

          value:
          snapshot.data ?? 0,


          icon:icon,

        );


      },

    );


  }


}






// =====================================
// COUNT CARD
// =====================================


class _CountCard extends StatelessWidget {


  final String title;

  final Stream<int> stream;

  final IconData icon;



  const _CountCard({

    required this.title,

    required this.stream,

    required this.icon,

  });



  @override
  Widget build(BuildContext context){


    return StreamBuilder<int>(


      stream:stream,


      builder:(context,snapshot){


        return DashboardCard(

          title:title,

          value:
          (snapshot.data ?? 0)
              .toDouble(),


          icon:icon,

        );


      },


    );


  }


}