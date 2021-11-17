import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ntp/ntp.dart';

class ProductComplaiment extends StatefulWidget {
  String id;
  String pid;
  ProductComplaiment(this.id,this.pid);
  @override
  _ProductComplaimentState createState() => _ProductComplaimentState(id,pid);
}

class _ProductComplaimentState extends State<ProductComplaiment> {
  bool _isLoading=false;
  String id;
  String pid;
  _ProductComplaimentState(this.id,this.pid);
  TextEditingController comp=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(width: 100,
            height: 150,
              child: Image.asset('assets/images/baseline_empty_item_grey_24.png'),
            ),
        new TextField(
          controller:comp ,

        decoration: InputDecoration(
          hintText: 'سبب تقديم الشكوة',
        enabledBorder: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(35.0),
    borderSide:  BorderSide(color: Colors.indigoAccent ),

    ),
    focusedBorder: new OutlineInputBorder(
    borderRadius: new BorderRadius.circular(35.0),
    borderSide:  BorderSide(color: Colors.indigoAccent ),

    ),
        )
        ),
            SizedBox(height: 15,),
            _isLoading==true?CircularProgressIndicator():  RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              color: Colors.red,
              child: Text('تقديم الآن',style: TextStyle(color: Colors.white),),
              onPressed: ()async{
                print('dfhsdhf${id}');
                setState(() {
                  _isLoading=true;
                });
                var timenow=await NTP.now();
                DateTime _ntp=DateTime.parse("${timenow}");
                if(id==null){
                  Fluttertoast.showToast(
                      msg:
                      'يجب تسجيل الدخول',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor:Colors.red,
                      textColor:Colors.white);
                }
                else
                 if(id=='') {
                   Fluttertoast.showToast(
                       msg:
                       'يجب تسجيل الدخول',
                       toastLength: Toast.LENGTH_SHORT,
                       gravity: ToastGravity.BOTTOM,
                       timeInSecForIosWeb: 1,
                       backgroundColor:Colors.red,
                       textColor:Colors.white);
                  }
                 else if(id!=null){

                   if(comp.text==null||comp.text==''){

                     print('dhdfhfd');
                   }
                   else
                     {

                       var mar = {
                         'user_id': id,
                         'product_id':pid,
                         'why':comp.text,
                         'time_now':'${timenow}',
                         'is_shop':0
                       };
                       String ur = '${RoyalBoardConfig
                           .RoyalBoardAppUrl}rest/users/complaiment_applay/api_key/${RoyalBoardConfig
                           .RoyalBoardServerLanucher}';




                       var response= await http.post(ur,body: mar);
                       var message=jsonDecode(response.body)['message'];
                       print('fsdhdfhggfsdgdfsdfs${message}');
                       if(message=='successfully_saved'){

                         Fluttertoast.showToast(
                             msg:
                             'تم تسجيل الشكوى بنجاح',
                             toastLength: Toast.LENGTH_SHORT,
                             gravity: ToastGravity.BOTTOM,
                             timeInSecForIosWeb: 1,
                             backgroundColor:Colors.green,
                             textColor:Colors.white);
                         Navigator.pop(context);

                       }
                     }

                 }


                 setState(() {
                   _isLoading=false;
                 });


              },
            )
          ],

        )),
      ),
    );
  }
}
