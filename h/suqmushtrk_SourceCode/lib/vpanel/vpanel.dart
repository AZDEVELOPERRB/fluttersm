import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/constant/RoyalBoard_dimens.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:ntp/ntp.dart';

class Vpanel extends StatefulWidget {


  @override
  _VpanelState createState() => _VpanelState();

}

class _VpanelState extends State<Vpanel> {
  bool connection=true;
  bool _isloading=false;
  bool _isloadingweb=false;
setConnection(){
  setState(() {
    connection=false;
  });
}
   check_enternet()async{
     var timenow=await NTP.now();
setState(() {
  _isloading==true;
});
    var mar = {

      'hour_clicked':'${timenow}'
    };
    String ur = '${RoyalBoardConfig
        .RoyalBoardAppUrl}rest/users/check_vpanel/api_key/${RoyalBoardConfig
        .RoyalBoardServerLanucher}';
    var response= await http.post(ur,body: mar);
    var message=jsonDecode(response.body)['message'];
    if(message=='success_connection'){
     setState(() {
       connection==true;
     });
    }


setState(() {
  _isloading=false;
});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        child:connection==true?Stack(
          children:<Widget> [
            WebView(
            initialUrl: 'google.com',

              onWebResourceError:  (error){
              setState(() {
                connection=false;
              });
              },

    ),

            WebviewScaffold(
              url: '${RoyalBoardConfig.RoyalBoardAppUrl}',
              appBar: new AppBar(
                title: Text('لوحة ادارة متجرك',style: TextStyle(color: Colors.blue),),
                actions: [
                  InkWell(
                      onTap:(){
                        Navigator.pop(context);                      },
                      child: Icon(Icons.exit_to_app,color: Colors.blue,))
                ],

              ),
              withZoom: false,
              withLocalStorage: true,
              clearCookies:false,
              appCacheEnabled:true,
              invalidUrlRegex:'false',
              hidden: true,
              initialChild: Container(
                color: Colors.white,
                child: const Center(
                    child: CircularProgressIndicator()
                ),
              ),
            ),
            _isloadingweb==false?Container():   Container(
              child: Center(
                child: Stack(
                  children: [
                    CircularProgressIndicator()
                  ],
                ),
              ),
            )
          ],
        ):  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/gg.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            const SizedBox(
                              height: PsDimens.space16,
                            ),
                            Text(
                              Utils.getString(context, 'app_name'),
                              style: Theme.of(context).textTheme.headline6.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: RoyalBoardColors.white),
                            ),
                            const SizedBox(
                              height: PsDimens.space8,
                            ),
                            Text(
                              'يبدو ان الانترنت ليس بجيد لاتقلق جاري تجهيز اعدادات السرعة',
                              // Utils.getString(context, 'app_info__splash_name'),
                              style: Theme.of(context).textTheme.subtitle2.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white),
                            ),
                            Text(
                              'يرجى التاكد من الاتصال بالانترنت',
                              // Utils.getString(context, 'app_info__splash_name'),
                              style: Theme.of(context).textTheme.subtitle2.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white),
                            ),
                            SizedBox(height: 15,),
                          _isloading==true?CircularProgressIndicator(): InkWell(
                             onTap: ()async{
                               var timenow=await NTP.now();
                               setState(() {
                                 _isloading=true;
                               });


                               var mar = {

                                 'hour_clicked':'${timenow}'
                               };
                               String ur = '${RoyalBoardConfig
                                   .RoyalBoardAppUrl}rest/users/check_vpanel/api_key/${RoyalBoardConfig
                                   .RoyalBoardServerLanucher}';
                               var response= await http.post(ur,body: mar);
                               print('asfdasf');
                               var message=jsonDecode(response.body)['message'];
                               print('frsfhsdhs${message}');
                               if(message=='success_connection'){
                                 setState(() {
                                   connection=true;
                                 });
                               }
                               else{
                                 Fluttertoast.showToast(
                                     msg: 'يبدو ان الاتصال مقطوع  ',
                                     toastLength: Toast.LENGTH_SHORT,
                                     gravity: ToastGravity.BOTTOM,
                                     backgroundColor: Colors.red,
                                     textColor: Colors.white

                               );
                               }



                               setState(() {
                                 _isloading=false;
                               });
                             },
                             child:

                             RaisedButton(
                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                 child: Text('جهز لي الاتصال السريع والمحاولة مجدداً الآن',style: TextStyle(color: Colors.white),)),
                           )

                          ],
                        )
                      ],
                    )

                )));



        // WebView(
        //   initialUrl: RoyalBoardConfig.RoyalBoardAppUrl,
        // ),


  }
}
