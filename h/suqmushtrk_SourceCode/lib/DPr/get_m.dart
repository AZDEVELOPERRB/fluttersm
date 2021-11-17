import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/ui/dashboard/core/dashboard_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/gm/rog_tow.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:ntp/ntp.dart';

class GetMoney extends StatefulWidget{
  String id;
  GetMoney(this.id);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return sonRo(id);
  }

}
class sonRo extends State<GetMoney>{
  String id;
  sonRo(this.id);
  bool show_gift=false;
  bool _isloading;
  bool _isloading_tow;
  Future <bool> WPOP()async{

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardView()),
      );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: WPOP,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/shorollet.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(              mainAxisAlignment: MainAxisAlignment.start,


              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height/12,),

                Text(' رصيدك يتم شحنه كل اربع ساعات بمبلغ قيمته 500 عملة ',style: TextStyle(fontSize: 14,color: Colors.pink),),
                Container(
                  width: MediaQuery.of(context).size.width-20,
                  child: Text('احرص على جمع هذا الرصيد بوقته سيختفي الرصيد ',style: TextStyle(fontSize: 14,color: Colors.pink),          textAlign: TextAlign.center,
                  ),
                ),
                Text('في حال عدم  جمعه في الوقت المحدد',style: TextStyle(fontSize: 14,color: Colors.pink),          textAlign: TextAlign.center,),
                Text(' لكن لاتقلق سيتوفر الرصيد في الاربع ',style: TextStyle(fontSize: 14,color: Colors.pink),          textAlign: TextAlign.center,),
                Text(' ساعات الأخرى مجموع    الرصيد الممكن جمعه',style: TextStyle(fontSize: 14,color: Colors.pink),          textAlign: TextAlign.center,),
                Text(' خلال اليوم هو 3000 عملة نقدية',style: TextStyle(fontSize: 14,color: Colors.pink),          textAlign: TextAlign.center,),
                Text('احرص على جمعها جميعاً',style: TextStyle(fontSize: 14,color: Colors.pink),          textAlign: TextAlign.center,),
                Container(
                    width: MediaQuery.of(context).size.width-10,
                    child: Text('اوقات الجمع من (ال8 لغاية ال12)ً',style: TextStyle(color: Colors.pink),          textAlign: TextAlign.center,)),
                Text('  ومن (ال12 لغاية ال4) ا',style: TextStyle(fontSize: 14,color: Colors.pink),          textAlign: TextAlign.center,),
                Text('ومن (ال4 لغاية ال12) صباحاً ومسائا',style: TextStyle(fontSize: 14,color: Colors.pink),          textAlign: TextAlign.center,),
               SizedBox(height: 25,),
               show_gift==false?SizedBox():_isloading==true?CircularProgressIndicator():ElevatedButton(
                    child: Text(
                        "الحصول على الجائزة الآن".toUpperCase(),
                        style: TextStyle(fontSize: 14)
                    ),
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.black)
                            )
                        )
                    ),
                    onPressed: ()async{

                      setState(() {
                        _isloading=true;
                      });
                      var timenow=await NTP.now();
                      var mar = {
                        'user_id': id,
                        'hour_clicked':'${timenow}'
                      };
                      String ur = '${RoyalBoardConfig
                          .RoyalBoardAppUrl}rest/users/get_gift_now/api_key/${RoyalBoardConfig
                          .RoyalBoardServerLanucher}';

                      var response= await http.post(ur,body: mar);
                      var message=jsonDecode(response.body)['message'];
                      if(message=='success_dataTaken'){

                        setState(() {
                          show_gift=false;
                        });
                        Fluttertoast.showToast(
                            msg:
                            'مبروك لقد حصلت على  500 عملة نقدية الآن بمحفظتك',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor:Colors.green,
                            textColor:Colors.white);
                      }
                      else
                        {
                          Fluttertoast.showToast(
                              msg:
                              'لقد حصل خطأ في الاتصال   ',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor:Colors.red,
                              textColor:Colors.white);
                        }
                      setState(() {
                        _isloading=false;
                      });




                    }
                ),
                _isloading_tow==true?CircularProgressIndicator():  ElevatedButton(
                    child: Text(
                        "فحص تراخيص الجائزة".toUpperCase(),
                        style: TextStyle(fontSize: 14)
                    ),
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xfff9a825)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.black)
                            )
                        )
                    ),
                    onPressed: ()async {

                      setState(() {
                        _isloading_tow = true;
                      });
                      var timenow=await NTP.now();
                      var mar = {
                        'user_id': id,
                      };

                      String ur = '${RoyalBoardConfig
                          .RoyalBoardAppUrl}rest/users/check_hourclicked/api_key/${RoyalBoardConfig
                          .RoyalBoardServerLanucher}';

                      var response = await http.post(ur, body: mar);
                      var message = jsonDecode(response.body)['message'];
                      print('gfjfgjhfgjfgjda${message}');


                      if (message !=null&&message != '0'&&message!='') {
                        print('hdfdffd');
                        DateTime time_clicked = DateTime.parse(message);
                        DateTime permission_time = DateTime.parse('${timenow}').subtract(
                            const Duration(hours: 4));
                        if (permission_time.isAfter(time_clicked)) {
                          print('dfhdfhdf');
                          Fluttertoast.showToast(
                              msg:
                              'انت تمتلك ترخيص الجائزة',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white);

                          setState(() {
                            show_gift = true;
                          });
                        }


                        else {
                          Fluttertoast.showToast(
                              msg:
                              'انت لا تمتلك ترخيص الحصول على الجائزة سيكون متوفر كل اربع ساعات',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 4,
                              backgroundColor: Colors.red,
                              textColor: Colors.white);
                        }

                      }
                      else {

                        DateTime time_clicked = DateTime.parse('${timenow}').subtract(
                            Duration(hours: 5));
                        DateTime permission_time = DateTime.parse('${timenow}').subtract(
                            const Duration(hours: 4));
                        if (permission_time.isAfter(time_clicked)) {
                          Fluttertoast.showToast(
                              msg:
                              'انت تمتلك ترخيص الجائزة',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white);

                          setState(() {
                            show_gift = true;
                          });
                        }
                        else {
                          Fluttertoast.showToast(
                              msg:
                              'انت لا تمتلك ترخيص الحصول على الجائزة سيكون متوفر كل اربع ساعات',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 4,
                              backgroundColor: Colors.red,
                              textColor: Colors.white);
                        }
                      }
                      setState(() {
                        _isloading_tow = false;
                      });
                    }),
                ElevatedButton(
                    child: Text(
                        " رجوع ".toUpperCase(),
                        style: TextStyle(fontSize: 14)
                    ),
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white70),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.black)
                            )
                        )
                    ),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DashboardView()),
                      );
                    }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}