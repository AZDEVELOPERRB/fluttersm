import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/ui/dashboard/core/dashboard_view.dart';
import 'dart:convert';
import 'package:RoyalBoard_Common_sooq/ui/friends_core/friends_cartsb.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
class Send_FRequest extends StatefulWidget {
  String user_id;

  Send_FRequest(this.user_id);

  @override
  _Send_FRequestState createState() => _Send_FRequestState(user_id);
}

class _Send_FRequestState extends State<Send_FRequest> {
  String user_id;

  _Send_FRequestState(this.user_id);
TextEditingController code_id =new TextEditingController();
bool _isLoading=false;
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
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Container(width: 100,
        height: 150,
        child: Image.asset('assets/images/friend_avatar.png'),
    ),
  Container(
    width: MediaQuery.of(context).size.width,
      child: new TextField(
         controller: code_id,
      decoration: InputDecoration(
      hintText: 'اكتب هنا معرف صديقك',
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
    ),
          SizedBox(height: 25,),
          _isLoading==true?Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ):  RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              child: Text('ارسال طلب صداقة',style: TextStyle(color: Colors.white),),
              color: Colors.blue,
              onPressed: ()async{
                setState(() {
                  _isLoading=true;
                });
                if(code_id.text.isEmpty){
                  Fluttertoast.showToast(
                      msg:
                      'يجب كتابة المعرف ',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor:Colors.red,
                      textColor:Colors.white);                }
                else{

                  var mar = {
                    'user_id':  user_id,
                    'fid':code_id.text


                  };
                  String ur = '${RoyalBoardConfig
                      .RoyalBoardAppUrl}rest/users/friends_send/api_key/${RoyalBoardConfig
                      .RoyalBoardServerLanucher}';

                  var response= await http.post(ur,body: mar);
                  var message=jsonDecode(response.body)['message'];
                  print('mssdddfgds${message}');
                  if(message=='no_user'){
                    Fluttertoast.showToast(
                        msg:
                        'لايوجد مستخدم بهكذا معرف',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor:Colors.red,
                        textColor:Colors.white);
                  }
                  else if(message=='sended_before'){
                    Fluttertoast.showToast(
                        msg:
                        'طلب الصداقة مع هذا المستخدم موجود فعلاً',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor:Colors.red,
                        textColor:Colors.white);
                  }
                  else if(message=='inserted'){
                    Fluttertoast.showToast(
                        msg:
                            'تم ارسال طلب الصداقة بنجاح',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor:Colors.green,
                        textColor:Colors.white);
                  }

                }
                setState(() {
                  _isLoading=false;
                });

              })
          ])
      ),
    );
  }
}
