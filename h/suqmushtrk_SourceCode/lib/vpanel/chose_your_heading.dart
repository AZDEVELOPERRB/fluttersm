import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/vpanel/vpanel.dart';
import 'package:RoyalBoard_Common_sooq/vpanel/registerpanel.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/Markets_class/Register.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/repo.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/models/Tajer_Model.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/Markets_class/vendor_dashboard.dart';
import 'dart:convert';
import 'package:RoyalBoard_Common_sooq/Mhellper/dataHelper/repo.dart';
import 'package:RoyalBoard_Common_sooq/constant/files_names.dart';
class ChoseYourHeading extends StatefulWidget {
  String user_id;
  ChoseYourHeading(this.user_id);
  @override
  _ChoseYourHeadingState createState() => _ChoseYourHeadingState();

}

class _ChoseYourHeadingState extends State<ChoseYourHeading> {
  bool Create_shop_permission=false;
  @override
  Markets_repo _markets_repo=Markets_repo();

  getinitial_info()async{

    // _markets_repo.check_shop_exist(widget.user_id);
    var checker_data= await _markets_repo.read_data_model();

  return checker_data;

  }
  bool enterLoading=false;
  ch_SVI()async{
    var d=await _markets_repo.ch_SVI();return d;
  }
  Widget build(BuildContext context) {

    var size=MediaQuery.of(context).size;

    Widget chose_heading=Container(
      color: Colors.white70,
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: size.width / 2.8,
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue
                ),

                child: Center(
                    child: Text('منصة التاجر', style: TextStyle(
                        fontSize: 19, color: Colors.white),)),

              ),
              SizedBox(height: 20,),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 2,
                child:FutureBuilder(
                  future: ch_SVI(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){

                     if(snapshot.data=='false'){}
                     else{
                       return Text('${snapshot.data}',
                           style: TextStyle(fontSize: 14

                       ), textAlign: TextAlign.center,);
                     }
                    }
                    return Text(
                      'التاجر مطالب بعمل توثيق'
                          ' بعمل اتصال فيديو بواسطة الواتساب من داخل مقر عملهم'
                          ' لتوثيق نشاطهم'
                          '    ان فائدة التوثيق هي حماية التاجر من المقلدين والانتهازيين'
                          '    واوقات التوثيق من الساعة ال ٩ صباحاً الى الساعة ٦ مساءاً بتوقيت بغداد'
                          '    ارقام التوثيق'
                          '     07705500087'
                          '  ايميل'
                          '   Suqmshtrk@gmail.com',
                      style: TextStyle(fontSize: 14

                      ), textAlign: TextAlign.center,
                    );
                  }
                ),
              ),

              Create_shop_permission==true?Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ):RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: Text('اضافة شركة او متجر جديد',
                    style: TextStyle(color: Colors.white)),
                color: Colors.green,
                onPressed: () async{

                  Fluttertoast.showToast(
                      msg:
                      'جاري فحص تراخيصك',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor:Colors.brown,
                      textColor:Colors.white);
                  setState(() {
                    Create_shop_permission=true;
                  });
                  var d=await _markets_repo.check_permission_for_shop(widget.user_id);
                  if(d==null){
                    setState(() {
                      Create_shop_permission=false;
                    });
                    return;
                  }
                  if(d['message']['point']=='deleted') {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (ctx) => Market_Reg(widget.user_id)));
                  }
                  else{
                    Fluttertoast.showToast(
                        msg:
                        'انت لا تمتلك الحق بانشاء متجر لانك تمتلكه بالفعل',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor:Colors.red,
                        textColor:Colors.white);
                  }
                  setState(() {
                    Create_shop_permission=false;
                  });

                }

              ),
            enterLoading==true?Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ):  RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: Text(
                  'الدخول الى متجري ', style: TextStyle(color: Colors
                    .white),),
                color: Colors.blue,
                onPressed: () async {
                  setState(() {
                    enterLoading=true;
                  });
                  var read_d = await _markets_repo.read_all_data_model(Files_Names.Market_info_checker);
                  if(read_d=='false'){
                    await    check_vendor_abaility();
                  }
                  if(read_d is Map){if (read_d['point'] == 'deleted') {await    check_vendor_abaility();} else if(read_d['point']=='success') {if (read_d['user_id'] == widget.user_id) {Navigator.push(context, MaterialPageRoute(builder: (ctx) => Vendor_Dashboard(widget.user_id)));} else{await   check_vendor_abaility();}}} else{await    check_vendor_abaility();}setState(() {enterLoading=false;});}),
              RaisedButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), child: Text('رجوع', style: TextStyle(color: Colors.white)), color: Colors.black12, onPressed: () => Navigator.pop(context)),
              Container(width: size.width / 1.07, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.green), child: Center(child: Text('السوق المشترك حيث تزدهر تجارتك وتتواصل مع عملاء اكثر', style: TextStyle(color: Colors.white),)),)
            ]
        ),
      ),
    );
    return Scaffold(
      body: chose_heading
    );

  }
  check_vendor_abaility()async{
    var d=await _markets_repo.check_permission_for_shop(widget.user_id);
    if(d['message']['point']=='deleted') {
      Fluttertoast.showToast(
          msg:
          'يبدو انك لاتمتلك متجر '
              'يرجى انشاء واحد',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:Colors.red,
          textColor:Colors.white);

    }
    else{
      Navigator.push(context, MaterialPageRoute(
          builder: (ctx) => Vendor_Dashboard(widget.user_id)));
    }
  }

}

