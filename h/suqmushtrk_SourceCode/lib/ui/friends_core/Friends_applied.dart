import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/ui/dashboard/core/dashboard_view.dart';
import 'dart:convert';
import 'package:RoyalBoard_Common_sooq/ui/friends_core/friends_cartsb.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
class Friends_Apllied extends StatefulWidget {
  String user_id;

  Friends_Apllied(this.user_id);

  @override
  _Friends_AplliedState createState() => _Friends_AplliedState(user_id);
}

class _Friends_AplliedState extends State<Friends_Apllied> {
  String user_id;

  _Friends_AplliedState(this.user_id);
  friends_applied()async{
    var mar = {
      'user_id':  user_id,


    };
    String ur = '${RoyalBoardConfig
        .RoyalBoardAppUrl}rest/users/get_friends_applied/api_key/${RoyalBoardConfig
        .RoyalBoardServerLanucher}';

    var response= await http.post(ur,body: mar);
    var message=jsonDecode(response.body)['message'];
    print('fjfagjfghj${message}');
    return message;


  }
  friends_applied_tow()async{
    var mar = {
      'user_id':  user_id,


    };
    String ur = '${RoyalBoardConfig
        .RoyalBoardAppUrl}rest/users/get_friends_applied/api_key/${RoyalBoardConfig
        .RoyalBoardServerLanucher}';

    var response= await http.post(ur,body: mar);
    var message=jsonDecode(response.body)['message'];
    print('fjfagjfghj${message}');
    return message;


  }
  bool siwtcher=false;
  bool del_lod=false;
  bool ac_lod=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     //  appBar: AppBar(
     // leading: Center(
     //   child: InkWell(
     //     onTap:(){
     //       Navigator.push(
     //         context,
     //         MaterialPageRoute(builder: (context) => DashboardView()),
     //       );
     //     },
     //     child: Row(
     //       children: [
     //
     //         Icon(Icons.arrow_forward_sharp,color: Colors.pink,),
     //       ],
     //     ),
     //   ),
     // ),
     //
     //  ),
      body: Container(
        child: Center(
          child:
            FutureBuilder(
              future:siwtcher==true?friends_applied_tow(): friends_applied(),
              builder: (BuildContext ,data){
                if(data.hasData){
                 if(data.data['msg']=='yes'){
                   return ListView.builder(
                       itemCount: data.data['data'].length,
                       itemBuilder: (ctx,i){
                         return ListTile(
                           title: Text('${data.data['data'][i]['name']}'),
                           subtitle: Row(
                             children: [
                               SingleChildScrollView(
                                 child:    ac_lod==true?Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: CircularProgressIndicator(),
                                 ): RaisedButton(
                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                     color: Colors.green,
                                     child: Text('قبول طلب الصداقة',style: TextStyle(color: Colors.white),),
                                     onPressed: ()async{
                                     setState(() {
                                       ac_lod=true;
                                     });

                                       var mar = {
                                         'user_id':  user_id,
                                         'friend_id':data.data['data'][i]['id']



                                       };
                                       String ur = '${RoyalBoardConfig
                                           .RoyalBoardAppUrl}rest/users/accept_friendship/api_key/${RoyalBoardConfig
                                           .RoyalBoardServerLanucher}';

                                       var response= await http.post(ur,body: mar);
                                       var message=jsonDecode(response.body)['message'];
                                       print('asdasdfasfd${message}');
                                       if(message=='friended'){

                                         Fluttertoast.showToast(
                                             msg:
                                                 'لقد اصبح ${data.data['data'][i]['name']} صديقك ',
                                             toastLength: Toast.LENGTH_SHORT,
                                             gravity: ToastGravity.BOTTOM,
                                             timeInSecForIosWeb: 1,
                                             backgroundColor:Colors.green,
                                             textColor:Colors.white);
                                       }
                                       else if(message=='af'){
                                         Fluttertoast.showToast(
                                             msg:'انتم اصدقاء بالفعل',
                                             toastLength: Toast.LENGTH_SHORT,
                                             gravity: ToastGravity.BOTTOM,
                                             timeInSecForIosWeb: 1,
                                             backgroundColor:Colors.red,
                                             textColor:Colors.white);
                                       }
                                       else if(message=='nono'){
                                         Fluttertoast.showToast(
                                             msg:'خطأ في الاتصال',
                                             toastLength: Toast.LENGTH_SHORT,
                                             gravity: ToastGravity.BOTTOM,
                                             timeInSecForIosWeb: 1,
                                             backgroundColor:Colors.red,
                                             textColor:Colors.white);
                                       }
                                     setState(() {
                                       if(siwtcher==false){
                                         siwtcher=true;
                                       }
                                       else{
                                         siwtcher=false;
                                       }
                                       ac_lod=false;
                                     });
                                     }),
                               ),
                               SizedBox(width: 35,),
                               del_lod==true?Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: CircularProgressIndicator(),
                               ):  RaisedButton(
                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                   color: Colors.red,
                                   child:Text('حذف طلب الصداقة',style: TextStyle(color: Colors.white),),
                                   onPressed: ()async{
                                     setState(() {
                                       del_lod=true;
                                     });
                                     var mar = {
                                       'user_id':  user_id,
                                       'friend_id':data.data['data'][i]['id']


                                     };
                                     String ur = '${RoyalBoardConfig
                                         .RoyalBoardAppUrl}rest/users/reject_friendship/api_key/${RoyalBoardConfig
                                         .RoyalBoardServerLanucher}';

                                     var response= await http.post(ur,body: mar);
                                     var message=jsonDecode(response.body)['message'];
                                     print('afdsgdsfg${message}');
                                     if(message=='success_deleted'){
                                       Fluttertoast.showToast(
                                           msg:
                                           'تم حذف طلب الصداقة بنجاح',
                                           toastLength: Toast.LENGTH_SHORT,
                                           gravity: ToastGravity.BOTTOM,
                                           timeInSecForIosWeb: 1,
                                           backgroundColor:Colors.green,
                                           textColor:Colors.white);
                                     }
                                     else{
                                       Fluttertoast.showToast(
                                           msg:
                                           'هنالك خطأ في الاتصال',
                                           toastLength: Toast.LENGTH_SHORT,
                                           gravity: ToastGravity.BOTTOM,
                                           timeInSecForIosWeb: 1,
                                           backgroundColor:Colors.red,
                                           textColor:Colors.white);
                                     }
                                     setState(() {
                                       if(siwtcher==false){
                                         siwtcher=true;
                                       }
                                       else{
                                         siwtcher=false;
                                       }
                                       del_lod=false;
                                     });

                                      (context as Element).reassemble();


                                   }),
                             ],
                           ),
                         );
                       });
                 }
                 else
                   {
                     return Center(child: Text('لاتوجد اي طلبات صداقة'),);
                   }
                }
                else{
                  return Center(child: CircularProgressIndicator(),);
                }
              },
            )
        ),
      ),
    );
  }
}
