import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/product_placeholder.dart';
import '../../../model/product.dart';


// Product card used in POS product grid
// Handles:
// - Product display
// - Stock status
// - Add product action
class ProductCard extends StatefulWidget {

  final Product product;

  // Callback when user adds product to cart
  final VoidCallback onAdd;


  const ProductCard({
    super.key,
    required this.product,
    required this.onAdd,
  });


  @override
  State<ProductCard> createState() =>
      _ProductCardState();

}



class _ProductCardState extends State<ProductCard> {


  // Used for button press animation
  bool isPressed = false;



  @override
  Widget build(BuildContext context) {


    final Product product = widget.product;


    // Stock checking only applies
    // to products with stock management enabled
    final bool isOutOfStock =
        product.trackStock &&
            product.stock <= 0;



    // Show warning when stock is running low
    final bool isLowStock =
        product.trackStock &&
            product.stock > 0 &&
            product.stock <= 5;



    return GestureDetector(



      // User touches product card
      onTapDown: (_) {


        // Disable press animation
        // if product is unavailable
        if (!isOutOfStock) {

          setState(() {
            isPressed = true;
          });

        }

      },




      // User releases touch
      onTapUp: (_) {


        if (!isOutOfStock) {


          setState(() {
            isPressed = false;
          });


          // Add product to cart
          widget.onAdd();

        }


      },




      // Reset animation if touch cancelled
      onTapCancel: () {

        setState(() {
          isPressed = false;
        });

      },



      child: AnimatedScale(


        // Small scale animation
        scale: isPressed ? 0.96 : 1.0,


        duration:
        const Duration(
          milliseconds: 120,
        ),



        child: Opacity(


          // Fade unavailable products
          opacity:
          isOutOfStock ? 0.5 : 1,



          child: Container(


            padding:
            const EdgeInsets.all(10),



            decoration:
            BoxDecoration(


              color:
              AppColors.surface,



              borderRadius:
              BorderRadius.circular(18),



              border:
              Border.all(
                color:
                AppColors.border,
              ),


            ),




            child: Column(


              crossAxisAlignment:
              CrossAxisAlignment.start,



              children: [





                // ================= PRODUCT IMAGE =================

                Stack(


                  children: [


                    ProductPlaceholder(

                      tone:
                      product.tone,

                      label:
                      product.category,

                      height:96,

                    ),






                    // Stock status badge
                    Positioned(


                      top:8,

                      left:8,



                      child:
                      Container(


                        padding:
                        const EdgeInsets.symmetric(
                          horizontal:8,
                          vertical:3,
                        ),



                        decoration:
                        BoxDecoration(


                          color:
                          Colors.white,



                          borderRadius:
                          BorderRadius.circular(50),


                        ),




                        child:
                        Text(


                          // Unlimited products
                          // don't show stock count
                          !product.trackStock

                              ? "AVAILABLE"


                              : isOutOfStock

                              ? "OUT"

                              : "${product.stock} LEFT",




                          style:
                          TextStyle(


                            fontSize:10,


                            fontWeight:
                            FontWeight.bold,



                            color:
                            !product.trackStock

                                ? Colors.green

                                : isOutOfStock

                                ? Colors.red

                                : isLowStock

                                ? Colors.orange

                                : Colors.green,

                          ),


                        ),


                      ),


                    ),


                  ],


                ),






                const SizedBox(height:10),






                // ================= PRODUCT NAME =================

                Text(


                  product.name,


                  maxLines:1,


                  overflow:
                  TextOverflow.ellipsis,



                  style:
                  const TextStyle(


                    fontSize:14,


                    fontWeight:
                    FontWeight.w600,


                  ),


                ),







                // ================= CATEGORY =================

                Text(


                  product.category,



                  style:
                  const TextStyle(


                    fontSize:11,


                    color:
                    Colors.grey,


                  ),


                ),






                const SizedBox(height:10),






                // ================= PRICE + ADD BUTTON =================

                Row(


                  children: [




                    // Product price
                    Expanded(


                      child:
                      Text(


                        "LKR ${product.price.toStringAsFixed(0)}",



                        style:
                        const TextStyle(


                          fontSize:16,


                          fontWeight:
                          FontWeight.bold,


                        ),



                      ),


                    ),






                    // Add product button
                    Container(


                      width:35,


                      height:35,



                      decoration:
                      BoxDecoration(


                        color:
                        isOutOfStock

                            ? Colors.grey

                            : AppColors.primary,



                        borderRadius:
                        BorderRadius.circular(10),


                      ),



                      child:
                      const Icon(


                        Icons.add,


                        color:
                        Colors.white,


                        size:20,


                      ),



                    ),



                  ],


                ),



              ],


            ),


          ),


        ),


      ),


    );


  }


}