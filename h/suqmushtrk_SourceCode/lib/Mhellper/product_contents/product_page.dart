import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/repo.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/models/Tajer_Model.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/product_contents/edit_product.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/shop.dart';
import 'package:RoyalBoard_Common_sooq/vpanel/chose_your_heading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/constant/files_names.dart';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/product.dart';
import 'dart:convert';

class Product_Single_Screen extends StatefulWidget {
  String product_id;
  String Shop_id;
  String User_id;
  Map product_all_data;

  Product_Single_Screen({this.product_id, this.product_all_data,this.Shop_id
  ,this.User_id});

  @override
  _Product_Single_ScreenState createState() => _Product_Single_ScreenState();
}

class _Product_Single_ScreenState extends State<Product_Single_Screen> {
  return_product_data()async{
    if(widget.product_id!=null){
      return {'id':'true','prod_id':widget.product_id};

    }
    else{
      return {'id':'false','prod_id':widget.product_all_data};
    }
  }
  @override
  Widget build(BuildContext context) {
    String dropdownValue='';
    bool choosen=false;
    var size=MediaQuery.of(context).size;

  return Scaffold(
    body: Container(
      child: FutureBuilder(
        future: return_product_data(),
        builder: (ctx,dat){
          if(dat.hasData){
            if(dat.data['id']=='true'){
              return Container(child: Text('hfd'),);
            }
            else{
            Product _prod=Product().fromMap(widget.product_all_data['prod_data']);

              return Container(
                width: size.width,
                height: size.height,
                child:Edit_product(
                    user_id:widget.User_id,
                  product_id:_prod.id,
                  shop_id: widget.Shop_id,
                )
              );
            }


          }
          else{
            return Container();
          }
        },
      ),
    ),
  );
  }

}
