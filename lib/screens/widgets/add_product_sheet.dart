import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_string.dart';
import '../../../model/product.dart';


class AddProductSheet extends StatefulWidget {

  final Function(Product) onSave;


  const AddProductSheet({
    super.key,
    required this.onSave,
  });


  @override
  State<AddProductSheet> createState() =>
      _AddProductSheetState();

}



class _AddProductSheetState extends State<AddProductSheet> {


  final _nameCtrl = TextEditingController();

  final _priceCtrl = TextEditingController();

  final _stockCtrl = TextEditingController();


  final _formKey = GlobalKey<FormState>();


  String _category = 'Bun & Buggers ';


  bool _trackStock = true;



  static const Map<String,String> _categoryTones = {


    'Bun & Buggers ':
    '#E8B383',


    'Desert & Beverages':
    '#C7E5B5',


    'Rice':
    '#FCD9A6',


    'Kottu':
    '#A7B98C',


    'Rice & Curry':
    '#FFD59A',


  };





  @override
  void dispose(){

    _nameCtrl.dispose();

    _priceCtrl.dispose();

    _stockCtrl.dispose();

    super.dispose();

  }







  void _save(){


    if(!_formKey.currentState!.validate()){
      return;
    }



    final toneHex =
        _categoryTones[_category] ?? '#FCD9A6';



    final tone =
    Color(
      int.parse(
        'FF${toneHex.replaceAll('#','')}',
        radix:16,
      ),
    );




    final product = Product(


      id: '',


      name:
      _nameCtrl.text.trim(),



      price:
      double.parse(
        _priceCtrl.text.trim(),
      ),




      stock:
      _trackStock
          ? int.parse(
          _stockCtrl.text.trim()
      )
          : 0,



      trackStock:
      _trackStock,



      category:
      _category,



      tone:
      tone,


    );




    widget.onSave(product);


    Navigator.pop(context);


  }









  @override
  Widget build(BuildContext context){



    final bottomInset =
        MediaQuery.of(context).viewInsets.bottom;



    return Container(


      decoration: const BoxDecoration(


        color: Colors.white,


        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(24),
        ),


      ),



      padding:
      EdgeInsets.fromLTRB(
        20,
        14,
        20,
        28 + bottomInset,
      ),



      child: Form(


        key:_formKey,



        child: Column(


          mainAxisSize:
          MainAxisSize.min,



          crossAxisAlignment:
          CrossAxisAlignment.start,



          children:[





            Center(

              child: Container(

                width:40,

                height:4,

                decoration:
                BoxDecoration(

                  color:
                  AppColors.border,

                  borderRadius:
                  BorderRadius.circular(5),

                ),

              ),

            ),




            const SizedBox(height:18),






            Row(

              children:[


                const Text(

                  "Add Product",

                  style:
                  TextStyle(

                    fontSize:19,

                    fontWeight:
                    FontWeight.w700,

                  ),

                ),



                const Spacer(),




                IconButton(

                  onPressed:
                      (){
                    Navigator.pop(context);
                  },


                  icon:
                  const Icon(
                    Icons.close,
                  ),

                )


              ],

            ),





            const SizedBox(height:20),






            _label("Product Name"),



            _field(

              controller:_nameCtrl,

              hint:"e.g. Egg Rice",


              validator:(v){


                if(v==null ||
                    v.trim().isEmpty){

                  return
                    "Product name required";

                }

                return null;

              },


            ),







            const SizedBox(height:14),








            Row(

              children:[



                Expanded(

                  child:Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,


                    children:[


                      _label("Price (LKR)"),



                      _field(

                        controller:_priceCtrl,

                        hint:"0",


                        keyboard:
                        TextInputType.number,



                        validator:(v){


                          if(v==null ||
                              v.isEmpty){

                            return "Required";

                          }


                          if(double.tryParse(v)==null){

                            return "Invalid";

                          }


                          return null;


                        },

                      )



                    ],

                  ),

                ),




                const SizedBox(width:12),







                Expanded(

                  child:Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,


                    children:[


                      _label("Stock"),



                      _trackStock

                          ? _field(

                        controller:
                        _stockCtrl,


                        hint:"0",


                        keyboard:
                        TextInputType.number,



                        validator:(v){


                          if(!_trackStock){
                            return null;
                          }



                          if(v==null ||
                              v.isEmpty){

                            return "Required";

                          }



                          if(int.tryParse(v)==null){

                            return "Invalid";

                          }


                          return null;

                        },


                      )


                          :

                      Container(

                        height:50,

                        alignment:
                        Alignment.center,

                        decoration:
                        BoxDecoration(

                          color:
                          AppColors.bg,

                          borderRadius:
                          BorderRadius.circular(12),

                        ),


                        child:
                        const Text(
                          "Unlimited",
                        ),


                      )



                    ],

                  ),

                ),


              ],

            ),









            const SizedBox(height:15),






            Container(


              decoration:
              BoxDecoration(

                color:
                AppColors.bg,

                borderRadius:
                BorderRadius.circular(12),

              ),



              child:
              SwitchListTile(


                title:
                const Text(
                  "Track Stock",
                ),



                subtitle:
                Text(

                  _trackStock

                      ?

                  "Stock reduces after sale"

                      :

                  "Unlimited product",

                ),



                value:
                _trackStock,



                onChanged:(value){


                  setState((){

                    _trackStock=value;

                  });


                },


              ),


            ),










            const SizedBox(height:15),







            _label("Category"),






            Container(

              padding:
              const EdgeInsets.symmetric(
                horizontal:14,
              ),


              decoration:
              BoxDecoration(

                color:
                AppColors.bg,


                borderRadius:
                BorderRadius.circular(12),


              ),



              child:
              DropdownButtonHideUnderline(


                child:
                DropdownButton<String>(


                  value:_category,


                  isExpanded:true,



                  items:
                  AppString.productCategories
                      .map(

                          (c)=>

                          DropdownMenuItem(

                            value:c,

                            child:
                            Text(c),

                          )

                  ).toList(),



                  onChanged:(v){


                    setState((){

                      _category=v!;

                    });


                  },



                ),


              ),


            ),








            const SizedBox(height:25),









            SizedBox(

              width:
              double.infinity,



              height:52,



              child:
              ElevatedButton(



                onPressed:
                _save,



                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  AppColors.primary,


                  shape:
                  RoundedRectangleBorder(

                    borderRadius:
                    BorderRadius.circular(14),

                  ),

                ),



                child:
                const Text(

                  "Save Product",

                  style:
                  TextStyle(

                    color:Colors.white,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),



              ),

            )




          ],


        ),


      ),


    );

  }








  Widget _label(String text){


    return Padding(

      padding:
      const EdgeInsets.only(
        bottom:6,
      ),


      child:
      Text(

        text,


        style:
        const TextStyle(

          fontSize:12,

          fontWeight:
          FontWeight.w600,

          color:
          AppColors.textSec,

        ),


      ),


    );


  }








  Widget _field({


    required TextEditingController controller,


    required String hint,


    TextInputType keyboard =
        TextInputType.text,



    String? Function(String?)? validator,



  }){


    return TextFormField(


      controller:
      controller,



      keyboardType:
      keyboard,



      validator:
      validator,



      decoration:
      InputDecoration(


        hintText:
        hint,



        filled:true,


        fillColor:
        AppColors.bg,



        border:
        OutlineInputBorder(

          borderRadius:
          BorderRadius.circular(12),

          borderSide:
          BorderSide.none,

        ),


      ),



    );


  }


}