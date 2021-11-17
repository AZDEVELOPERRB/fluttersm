import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Red_To_Blue extends StatefulWidget {
  String id;
  String pid;  Red_To_Blue(this.id,);
  @override
  _ProductComplaimentState createState() => _ProductComplaimentState(id);
}

class _ProductComplaimentState extends State<Red_To_Blue> {
  bool _isLoading=false;
  String id;

  _ProductComplaimentState(this.id,);
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
              child: Image.asset('assets/images/jawhara.png'),
            ),
            Text('سعر الجوهرة الحمراء تساوي 3 جواهر زرقاء'),
            new TextField(
                controller:comp ,
                keyboardType: TextInputType.number,


                decoration: InputDecoration(
                  hintText: 'كم عدد الجواهر الحمراء التي تريد شرائها؟',
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
              child: Text('شراء الآن ',style: TextStyle(color: Colors.white),),
              onPressed: ()async{
                setState(() {
                  _isLoading=true;
                });
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

                    Fluttertoast.showToast(
                        msg:
                        'يجب  اخبارنا بعدد الجواهر',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor:Colors.red,
                        textColor:Colors.white);
                  }
                  else
                  {

                    var mar = {
                      'user_id': id,
                      'applied_jawahr':comp.text,

                    };
                    String ur = '${RoyalBoardConfig
                        .RoyalBoardAppUrl}rest/users/buy_red_jawahr/api_key/${RoyalBoardConfig
                        .RoyalBoardServerLanucher}';




                    var response= await http.post(ur,body: mar);
                    var message=jsonDecode(response.body)['message'];
                   if(message=='no_money'){
                     Fluttertoast.showToast(
                         msg:
                         ' انت لا تمتلك الجواهر الكافية للشراء',
                         toastLength: Toast.LENGTH_SHORT,
                         gravity: ToastGravity.BOTTOM,
                         timeInSecForIosWeb: 1,
                         backgroundColor:Colors.red,
                         textColor:Colors.white);
                   }
                   else if(message=='success_save'){
                     Fluttertoast.showToast(
                         msg:
                         'لقد تم شراء الجواهر الحمر بنجاح',
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
