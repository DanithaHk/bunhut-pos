import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_alert.dart';
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

          // ================= HEADER =================

          AppBar(

            title: const Text("Cart"),

            automaticallyImplyLeading: false,

            actions: [

              IconButton(

                icon: const Icon(Icons.close),

                onPressed: onClose,

              )

            ],

          ),



          // ================= EMPTY CART =================

          if(cart.items.isEmpty)

            const Expanded(

              child: Center(

                child: Text(
                  "Cart is Empty",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),

              ),

            )



          // ================= CART ITEMS =================

          else

            Expanded(

              child: ListView.builder(

                itemCount: cart.items.length,


                itemBuilder: (context,index){


                  final item = cart.items[index];


                  // Get Product object

                  final product = context
                      .read<ProductProvider>()
                      .getById(item.productId);



                  return ListTile(

                    leading: CircleAvatar(

                      backgroundColor: item.tone,

                      child: Text(
                        item.name[0],
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),

                    ),


                    title: Text(
                      item.name,
                    ),


                    subtitle: Text(

                      "Qty : ${item.qty}\n"
                          "LKR ${(item.price * item.qty).toStringAsFixed(0)}",

                    ),



                    trailing: Row(

                      mainAxisSize: MainAxisSize.min,


                      children: [



                        // ================= REMOVE =================

                        IconButton(

                          icon: const Icon(
                            Icons.remove,
                          ),


                          onPressed: (){


                            context
                                .read<CartProvider>()
                                .decrement(
                              item.productId,
                            );



                            AppAlert.show(

                              context,

                              message:
                              "Quantity decreased",

                              type:
                              AlertType.info,

                            );


                          },

                        ),





                        // ================= ADD =================

                        IconButton(

                          icon: const Icon(
                            Icons.add,
                          ),


                          onPressed: (){


                            context
                                .read<CartProvider>()
                                .increment(
                              item.productId,
                            );



                            // Reduce stock only tracked products

                            if(product != null &&
                                product.trackStock){


                              context
                                  .read<ProductProvider>()
                                  .decrementStock(
                                product.id,
                              );

                            }




                            AppAlert.show(

                              context,

                              message:
                              "Quantity increased",

                              type:
                              AlertType.success,

                            );


                          },

                        ),






                        // ================= DELETE =================

                        IconButton(

                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),



                          onPressed: (){


                            // Restore stock

                            if(product != null &&
                                product.trackStock){


                              context
                                  .read<ProductProvider>()
                                  .restoreStock(

                                product.id,

                                item.qty,

                              );


                            }



                            context
                                .read<CartProvider>()
                                .remove(
                              item.productId,
                            );




                            AppAlert.show(

                              context,

                              message:
                              "${item.name} removed",

                              type:
                              AlertType.warning,

                            );


                          },

                        ),


                      ],

                    ),


                  );


                },

              ),

            ),






          // ================= TOTAL SECTION =================


          Container(

            padding: const EdgeInsets.all(15),


            child: Column(

              children: [


                _row(
                  "Subtotal",
                  cart.subtotal,
                ),


                _row(
                  "Tax",
                  cart.tax,
                ),


                const Divider(),



                _row(

                  "Total",

                  cart.total,

                  bold: true,

                ),




                const SizedBox(
                  height: 15,
                ),





                SizedBox(

                  width: double.infinity,


                  child: ElevatedButton(


                    onPressed: (){


                      if(cart.items.isEmpty){


                        AppAlert.show(

                          context,

                          message:
                          "Cart is empty",

                          type:
                          AlertType.warning,

                        );


                        return;

                      }



                      onCheckout();


                    },



                    child:
                    const Text(
                      "Checkout",
                    ),


                  ),

                )



              ],


            ),


          )


        ],


      ),


    );


  }





  Widget _row(

      String label,

      double value,

      {
        bool bold = false,
      }

      ){


    return Row(


      children: [


        Text(

          label,

          style: TextStyle(

            fontWeight:
            bold
                ? FontWeight.bold
                : FontWeight.normal,

          ),

        ),



        const Spacer(),



        Text(

          "LKR ${value.toStringAsFixed(0)}",


          style: TextStyle(

            fontWeight:
            bold
                ? FontWeight.bold
                : FontWeight.normal,

          ),


        ),



      ],


    );

  }


}