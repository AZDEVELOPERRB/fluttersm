import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:RoyalBoard_Common_sooq/constant/files_names.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/repo.dart';
import 'package:RoyalBoard_Common_sooq/api/RoyalBoard_url.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'dart:io';
import 'dart:async';
class Products_repo extends ChangeNotifier{
  Markets_repo MH=Markets_repo();

  String product_ft_url=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.getProducts_for_first_time;
  String delete_product_url=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.delete_products_url;
  String product_detail_url=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.getProducts_Detail_url;
  String product_pool_url=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.getProducts_for_pool;
  String Update_Order_detail_url=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.Update_Order_detail_url;
  String All_orders_url=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.getOrdersForVendor;
  String ShippingArea_url=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.ShippingArea_url;
  String CreateShipping_url=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.Create_shipping_area;
  String Single_orders_url=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.Single_Order_url;
  String all_products_url=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.getAll_vendor_products;
  String Shipping_detail_url=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.Shipping_detail_single;
  String delete_ship_area_url=RoyalBoardConfig.RoyalBoardAppUrl+PsUrl.delete_ship_area;
  String product_file=Files_Names.all_products_file;


  getproductforfirsttime(String shop_id)async{
    var source=await http.post(product_ft_url,body: {
      'shop_id':shop_id
    });
    var res=json.decode(source.body);
    get_all_products_right_now(shop_id);
    return res;


  }
  All_Orders_for_vendor(String shop_id,String limit,bool isnoti,String order_id)async{
    var response=await http.post(All_orders_url,body: {
      'shop_id':shop_id,
      'limit':limit,
      'isnoti':'${isnoti}',
      'order_id':'${order_id}'
    });
    var res=json.decode(response.body);
    print('sdfgjkldlsgdasgjsadadslkgj${res}');
   return res;

  }
  products_pool_geter(String cat_id,int counter)async{
    var response=await http.post(product_pool_url,body: {
      'cat_id':cat_id,
      'counter':'${counter}'
    });
    var res=json.decode(response.body);
    print('gasfgasfsdasda${res}');

    return res['message'];

  }
  bringShipping(String shipping_id)async{
    var response=await http.post(Shipping_detail_url,body: {
      'd':shipping_id
    });
    var res=json.decode(response.body);
    return res;
  }
  deleteShip_area(String id)async{
    var response=await http.post(delete_ship_area_url,body: {
      'd':id
    });
    var res=json.decode(response.body);
    return res;
  }
  delete_product(String product_id)async{
    var response=await http.post(delete_product_url,body: {
      'pid':product_id,
    });
    var res=json.decode(response.body);

    return res;
  }
  SingleOrderDetails(String Product_id,String delivery)async{
    var response=await http.post(Single_orders_url,body: {
      'prod_id':Product_id,
      'delivery':delivery
    });
    var res=json.decode(response.body);
return res;
  }
  getProductDetail(String Product_id)async{
    var source=await http.post(product_detail_url,body: {'pid':Product_id});
    var response=json.decode(source.body);
    print('fdasffasfasf$response');
    return response;

  }
  getAllShippingArea(String user_id,String shop_id)async{
    var source=await http.post(ShippingArea_url,body: {'sid':shop_id,'uid':user_id});
    var response=json.decode(source.body);
    return response;
  }
  Create_ShippingArea(String user_id,String Shop_id,String name,String price,int is_new,String id)async{
    var res=await http.post(CreateShipping_url,body: {
      'sid':Shop_id,
      'uid':user_id,
      'name':name,
      'price':'${price}',
      'is_new':'${is_new}','id':id
    });
    var response=json.decode(res.body);
    print('dfshsdgasdgsagasgfasgg${response}');
    return response;
  }
  UpdateOrderDetails(String trans_header,String trans_status)async{
    print('hfdshsdghsd$trans_status');
    var source=await http.post(Update_Order_detail_url,body: {'trans_header':trans_header,'trans_status':trans_status});
    var response=json.decode(source.body);
    print('gadfgjedfhdfsh${response}');

    return response;
  }
  get_all_products_right_now(String shop_id)async{
    var source=await http.post(all_products_url,body: {
      'shop_id':shop_id
    });
    var res=json.decode(source.body);

    await MH.save_data_all_model(res['message']['data'], product_file);



  }




}