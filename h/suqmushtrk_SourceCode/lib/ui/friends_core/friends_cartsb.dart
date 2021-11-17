import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/constant/route_paths.dart';
import 'package:RoyalBoard_Common_sooq/ui/dashboard/core/dashboard_view.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/intent_holder/link_noti_products_holder.dart';
import 'package:RoyalBoard_Common_sooq/viewobject/holder/product_parameter_holder.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class Friends_cartb extends StatefulWidget {
  String friend_id;
  String user_id;

  Friends_cartb(this.friend_id, this.user_id);

  @override
  _Friends_cartbState createState() => _Friends_cartbState(friend_id,user_id);
}

class _Friends_cartbState extends State<Friends_cartb> {
  String friend_id;
  String user_id;

  final ProductParameterHolder productParameterHolder =
  ProductParameterHolder().getLatestParameterHolder();
  _Friends_cartbState(this.friend_id, this.user_id);

  check_transictions()async{
    var mar = {
      'user_id':  user_id,
      'friend_id':friend_id


    };
    String ur = '${RoyalBoardConfig
        .RoyalBoardAppUrl}rest/users/friend_transictions/api_key/${RoyalBoardConfig
        .RoyalBoardServerLanucher}';

    var response= await http.post(ur,body: mar);
    var message=jsonDecode(response.body)['message'];
    return message;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: InkWell(
            onTap:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardView()),
              );
            },
            child: Row(
              children: [

                Icon(Icons.arrow_forward_sharp,color: Colors.pink,),
              ],
            ),
          ),
        ),

      ),
      body: Container(
        child: Center(
          child: FutureBuilder(
            future: check_transictions(),
            builder: (ctx ,index){
              if(index.hasData) {
                if (index.data.length == 0) {
                  return Center(child: Text('لا يمتلك مشتريات حالياً'),);

                }
                else {
                  return ListView.builder(
                      itemCount: index.data.length,
                      itemBuilder: (ctx, i) {
                        return ListTile(
                          onTap: (){
                            productParameterHolder.searchTerm = index.data[i]['pn'];
                            Utils.psPrint(productParameterHolder.searchTerm);
                            Navigator.pushNamed(context, RoutePaths.filterProductList_doublenew,
                                arguments: LinkNotiProductsList(
                                    appBarTitle: Utils.getString(
                                        context, 'home_search__app_bar_title'),
                                    productParameterHolder: productParameterHolder,
                                    prod_id:index.data[i]['id']
                                ));
                          },
                          leading: Icon(Icons.shopping_cart,
                            color: Colors.blue,),
                          title: Text('${index.data[i]['pn']}',
                            style: TextStyle(color: Colors.green),),

                          trailing: Text('وسعر الشراء هو ${index
                              .data[i]['price']} ${index.data[i]['cs']} '),
                        );
                      });
                }
              }
              else {
                return Center(child: CircularProgressIndicator(),);
              }

            },
          )
        ),
      ),
    );
  }
}
