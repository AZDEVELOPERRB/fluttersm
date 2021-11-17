import 'dart:async';

import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/repo.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/product_repo.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/orders/all_Orders_ui.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/models/Tajer_Model.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/product_contents/add_Product.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/product_contents/all_product_page.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/shop.dart';
import 'package:RoyalBoard_Common_sooq/vpanel/chose_your_heading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/constant/files_names.dart';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/product_contents/product_page.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/Shipping/Shipping_All.dart';
import 'edit_vendor.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/shop.dart';
import 'package:RoyalBoard_Common_sooq/Offers/add_offer.dart';





class Vendor_Dashboard extends StatefulWidget {
  String User_id;

  Vendor_Dashboard(this.User_id);

  @override
  _Vendor_DashboardState createState() => _Vendor_DashboardState();
}

class _Vendor_DashboardState extends State<Vendor_Dashboard> {
  Markets_repo Market_helper=Markets_repo();
  Products_repo _products_repo=Products_repo();
  String Image_file=Files_Names.Market_ingo;
  String product_filename=Files_Names.products_list_limitted;

  Shop _s=Shop();
  String d;
  Color yellow=Color(0xfff9a825);
  String urlofimage = '${RoyalBoardConfig
      .RoyalBoardImagesUrl}';
  TextStyle font_description=TextStyle(color: Colors.white,fontSize: 13);
  Timer _timer;
  int counter=1;
  @override
  void initState() {

    Market_helper.check_permission_for_shop(widget.User_id);

    super.initState();


  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  get_vendor_image(String shop_id)async{
   var check_inside_data=await Market_helper.read_all_data_model(Image_file);
   print('dsfghklsjdglksdjg${check_inside_data}');



   if(check_inside_data=='false'){
     var new_img=await Market_helper.get_shop_image(shop_id);


     return new_img;

   }
   else
     {
       var new_img= Market_helper.get_shop_image(shop_id);

       print('dsglhsdlkgj${check_inside_data}');

     return check_inside_data;

   }


  }
  Product_list_limitted_func(String shop_id)async{

   var shop_product_list_limit= await Market_helper.read_all_data_model(product_filename);
   if(shop_product_list_limit is String||shop_product_list_limit==null){
     var letget=await  Markets_repo().getproducts_listlimit(shop_id, );
     return letget;
   }

     return shop_product_list_limit;

  }
  getdata()async{
    Vendor_Model second_data=null;
    var a =await Market_helper.read_data_model();
    if(a is Map){
      if(a.containsKey("nono")){
        if(a['nono']=="nono"){

         Navigator.pop(context);

        }

      }
    }

  Future.delayed(Duration(seconds:3)).then((value) async{
 var secondary=await Market_helper.update_vendor_informations(widget.User_id);
setState(() {

});

second_data=Vendor_Model.fromjson(secondary);
return second_data;


});

if(a is Map ){



    Vendor_Model data=Vendor_Model.fromjson(a);



    return data;
}
else{
  Fluttertoast.showToast(msg: "يجب ان يتحقق النظام من صلاحيتك حتى يتيح لك الدخول الى المتجر",backgroundColor: Colors.red);
  Navigator.pop(context);
  Navigator.pop(context);
}


  }
  @override
  Widget build(BuildContext context) {


    // var d= Market_helper.check_permission_for_shop(widget.User_id);

    var size=MediaQuery.of(context).size;

    Color c_white=Colors.white;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Center(child:
           FutureBuilder(
             future: getdata(),
             builder: (ctx,i){
               if(i.hasData){
                   Vendor_Model data = i.data;
                   var letget=  Markets_repo().getproducts_listlimit(data.id, );
                   final updater=_products_repo.get_all_products_right_now(data.id);
                   var a =  Market_helper.getCategories(data.id);
                   // var subca =  Market_helper.getSubCategories(data.id);

                   return Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [

                            FutureBuilder(
                           future: get_vendor_image(data.id),
                           builder: (context, snapshot) {
                             if (snapshot.hasData) {



                               return Container(
                                 width: size.width,
                                 height: size.height / 2.8,
                                 decoration: BoxDecoration(
                                   image: DecorationImage(
                                       fit: BoxFit.fill,

                                       image: CachedNetworkImageProvider(

                                           '${urlofimage}${snapshot.data['img_path']}'

                                       )
                                   )
                                 ),

                               );
                             }
                             else{
                               return Container(
                                 width: size.width,
                                 height: size.height / 2.8,
                                 decoration: BoxDecoration(
                                     image: DecorationImage(
                                         fit: BoxFit.fill,

                                         image: AssetImage('assets/images/bb.jpg')
                                     )
                                 ),
                               );
                             }
                           }

                         ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right:1.0,top: 1),
                            child: Container(
                              width: size.width/1.4,
                              height: size.height/4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black87,

                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,

                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(data.name,style: font_description,),
                                  ),
                                  Text('رقم الهاتف : '+data.phone,style: font_description,),
                                  Text(' اقل مبلغ مبيعات : '+data.mini_money,style: font_description,),

                                  Text('  ايام العطل : '+data.holiday,style: font_description,),


                                ],
                              ),

                            ),
                          ),SizedBox(width: 10,),
                          Column(
                            children: [
                              RaisedButton(onPressed: ()async{
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (ctx)=>Editting_vendor(widget.User_id,data)
                                ));


                              },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)
                                ),
                                color: Color(0xfff9a825),

                              child: Text('تعديل',style: TextStyle(color: Colors.white),),),

                            ],
                          )
                        ],
                      ),
               Row(
                 children: [
                   Padding(
                   padding: const EdgeInsets.only(right:1.0,top: 1),
                   child: Container(
                   width: size.width/1.5,
                   height: size.height/14,
                   decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(10),
                   color: Colors.green,

                   ),
                   child: Row(
                     children: [
                       Padding(
                         padding: const EdgeInsets.only(right:10.0),
                         child: Text('معرف المتجر : '+'${data.shop_i}',style: TextStyle(color: Colors.black87),),

                       ),SizedBox(width: 30,),
                       InkWell(
                         onTap: ()async{
                           FlutterClipboard.copy('${data.shop_i}');
                           Fluttertoast.showToast(
                               msg:
                               'تم نسخ المعرف بنجاح',
                               toastLength: Toast.LENGTH_SHORT,
                               gravity: ToastGravity.BOTTOM,
                               timeInSecForIosWeb: 1,
                               backgroundColor:Colors.green,
                               textColor:Colors.white);

                         },
                         child: Container(
                           child: Text('نسخ',style: TextStyle(color: Colors.yellow),),
                         ),
                       )
                     ],
                   ),
                   )

                   ),
                   SizedBox(width: 5,),
                   Container(
                     width: size.width/4,
                     child: RaisedButton(onPressed: ()async{
                       Navigator.push(context, MaterialPageRoute(
                         builder: (ctx)=>Shipping_All(widget.User_id,data.id)
                       ));
                     },
                       shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(25)
                       ),
                       color: Color(0xfff9a825),

                       child: Text('مناطق التوصيل',style: TextStyle(color: Colors.white,fontSize: 11),),),
                   ),
                 ],
               ),
                     Row(
                     children: [
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Container(
                       width: size.width/1.2,
               height: size.width/12,
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                  RaisedButton(
                    onPressed:(){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context)=>all_vendor_products(data.id,widget.User_id)
                      ));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    color: Colors.blue,
                    child: Center(child: Text('* منتجاتي ',style: TextStyle(color: Colors.white),)),
                  ),
                   RaisedButton(
                     onPressed: (){

                       Navigator.push(context, MaterialPageRoute(
                           builder: (context)=>All_Orders_Ui(data.id,widget.User_id,is_notification: false,)
                       ));
                     },
                     shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(8)
                     ),
                     color: Colors.redAccent,
                     child:  Center(child: Text('* الطلبات الواردة ',style: TextStyle(color: Colors.white),)),
                   ),
                 ],
               ),
               ),
                     )
                     ],
                     ),FutureBuilder(
                       future: Product_list_limitted_func(data.id),
                       builder: (context, snapshot) {
                        if(snapshot.hasData){
                          return Container(
                            width: size.width,
                            child: Row(
                              children: [
                                Container(
                                  height: size.height/5.5,
                                  width: size.width/1.6,
                                  child: GridView.count(
                                    // Create a grid with 2 columns. If you change the scrollDirection to
                                    // horizontal, this produces 2 rows.
                                    crossAxisCount: 2,

                                    childAspectRatio: 1.5,
                                    padding: const EdgeInsets.all(4.0),
                                    mainAxisSpacing: 4.0,
                                    crossAxisSpacing: 4.0,


                                    // Generate 100 widgets that display their index in the List.
                                    children:[
                                      for(var product in snapshot.data)
                                        Stack(
                                          children: [
                                            InkWell(
                                              onTap:(){
                                                Navigator.push(context, MaterialPageRoute(
                                                    builder: (ctx)=>Product_Single_Screen(product_all_data: product,User_id:widget.User_id,Shop_id: data.id,)
                                                ));
                                              },
                                              child: Container(
                                                width:size.width/3,
                                                height: size.height/11,


                                                child: CachedNetworkImage(
                                                imageUrl: '${RoyalBoardConfig.RoyalBoardImagesUrl}${product['img']}',
                                                placeholder: (context, url) => CircularProgressIndicator(),
                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                              ),

                                              ),
                                            ),
                                           Positioned(
                                             bottom: 0,
                                             child: Container(

                                               color: Colors.black45,
                                               child: SingleChildScrollView(
                                                 scrollDirection: Axis.horizontal,
                                                 child: Center(child: Text(product['prod_data']['name'],style: TextStyle(color: Colors.white
                                                 ,fontSize: 13,
                                                 ),textAlign: TextAlign.center,),),
                                               ),
                                             ),
                                           )


                                          ],
                                        )
                                    ]
                                  ),
                                ),
                                SizedBox(width: 1,),
                                RaisedButton(onPressed: ()async{
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context)=>all_vendor_products(data.id,widget.User_id)
                                  ));



                                },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25)
                                    ),
                                    color: Color(0xfff9a825),

                                    child: Text('جميع المنتجات',style: TextStyle(color: Colors.white),))
                              ],
                            ),
                          );
                        }
                        else{
                          return Container();
                        }
                       }
                     ),
                     Row(
                     children: [
                     Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Container(
                     width: size.width/1.2,
                     height: size.width/12,
                     child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       RaisedButton(
                         onPressed:(){
                           Navigator.push(context, MaterialPageRoute(
                           builder:(ctx)=>Add_new_product_by_venor(data.id,widget.User_id,joomla: data.jomla,)
                           ));
                         },
                         shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(8)
                         ),
                         color: Colors.blue,
                         child: Container(
                             color:Colors.blue,
                             padding:const EdgeInsets.all(3.0),
                             child:Text('اضف منتج جديد +',style: TextStyle(color: Colors.white),)
                         ),
                       ),
                       RaisedButton(
                           color:Colors.blue,
                           padding:const EdgeInsets.all(3.0),
                           shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(8)
                           ),
                           onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context)=> Add_New_Offer(data.id,widget.User_id)
                            ));

                           },
                           child:Text('اضف عرض جديد +',style: TextStyle(color: Colors.white),)
                       ),
               ],
               ),
               ),
               )
               ],),

                     FutureBuilder(
                       future: get_dollar_price_and_product_count(data.id),
                       builder: (ctx,index){
                         if(index.hasData){

                           return Column(
                             children: [
                               Row(
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Container(
                                       width: size.width/1.2,
                                       height: size.width/12,
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Container(
                                               color:Colors.blue,
                                               padding:const EdgeInsets.all(3.0),
                                               child:Text('عدد المنتجات في متجرك الآن : ${index.data['message']['prod_count']}',style: TextStyle(color: Colors.white),)
                                           ),

                                         ],
                                       ),
                                     ),
                                   )
                                 ],),
                               Row(
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Container(
                                       width: size.width/1.2,
                                       height: size.width/12,
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Container(
                                               color:Colors.red,
                                               padding:const EdgeInsets.all(3.0),
                                               child:Text('سعر صرف الدولار لهذا اليوم  ${index.data['message']['dollar']}',style: TextStyle(color: Colors.white),)
                                           ),

                                         ],
                                       ),
                                     ),
                                   )
                                 ],),
                             ],
                           );
                         }
                         else{
                           return Container(
                             child: Text('جاري تحضير البيانات من الانترنت'),
                           );
                         }
                       },
                     ),








                     ],
                   );

               }

               else{
                 return Container(
                     height: size.height,
                     width: size.width,
                     child: Center(child: CircularProgressIndicator()));
               }
             },
           )),
        ),
      ),
    );

  }
  get_dollar_price_and_product_count(String shop_id)async{
    var data=await Market_helper.read_all_data_model(Files_Names.dollarPrice);

    if(data is Map){
      if(data.containsKey('message')){
        if(data['message'] is Map) {
          Map dollar=data['message'];
          if(dollar.containsKey('dollar')){

          var x = Market_helper.Dollar_Price(shop_id);
          return data;


        }}
      }
    }
var x=await Market_helper.Dollar_Price(shop_id);
await Market_helper.save_data_all_model(x,Files_Names.dollarPrice);
  return x;
  }
}
