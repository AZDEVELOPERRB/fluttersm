import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/ui/dashboard/core/dashboard_view_tow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ntp/ntp.dart';

class Firm_Gifts extends StatefulWidget {
  String id;
  Firm_Gifts(this.id);
  @override
  _Firm_GiftsState createState() => _Firm_GiftsState(id);
}

class _Firm_GiftsState extends State<Firm_Gifts> {
  String id;
  _Firm_GiftsState(this.id);
  @override
  void initState() {
    if(id==null||id==''){
      show_id_error();
    }
    // TODO: implement initState
    super.initState();
  }
  show_id_error(){
    Fluttertoast.showToast(
        msg:
        'يجب تسجيل الدخول',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor:Colors.red,
        textColor:Colors.white);
    Navigator.push(context, MaterialPageRoute(builder: (ctx)=>DashboardView()));
  }
  Future get_firm_gifts () async{
    var Timenow=await NTP.now();



    var mar = {
      'user_id': id,
      'now':'${Timenow}'
    };
    String ur = '${RoyalBoardConfig
        .RoyalBoardAppUrl}rest/users/show_me_gift_of_firmprices/api_key/${RoyalBoardConfig
        .RoyalBoardServerLanucher}';

    var response= await http.post(ur,body: mar);
    var message=jsonDecode(response.body)['message'];
    print('messagesdassss${message}');
    return message['data'];


  }
  String image_url = '${RoyalBoardConfig
      .RoyalBoardImagesUrl}';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: get_firm_gifts(),
          builder: (BuildContext, i){
            if(i.hasData){
              if(i.data.length!=0){
                return ListView.builder(
                  itemCount: i.data.length,
                  itemBuilder:(BuildContext ,snap){
                    return ListTile(
                      leading: Container(
                        height: 80,
                        child:
                        CachedNetworkImage(
                          imageUrl: '${image_url}${i.data[snap]['image']}',
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        // Image.network('${image_url}${i.data[snap]['image']}'),
                      ),
                      title: Text('${i.data[snap]['name']}'),
                      subtitle: Text('تاريخ الحصول على الجائزة = ${i.data[snap]['date']}'),
                    );
                  }
                );
              }
              else
                {
                  return Center(child: Text('انت لا تمتلك جائزة الى الآن'),);
                }
            }

            else
              {
                return Center(child: CircularProgressIndicator(),);
              }
          },
        ),
      ),
    );
  }
}
