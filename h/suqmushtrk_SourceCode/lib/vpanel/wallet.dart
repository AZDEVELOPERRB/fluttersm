import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/vpanel/vpanel.dart';
import 'package:RoyalBoard_Common_sooq/vpanel/registerpanel.dart';
class WalletPanel extends StatefulWidget {
  String ua;
  WalletPanel(this.ua);
  @override
  _ChoseYourHeadingState createState() => _ChoseYourHeadingState(ua);
}

class _ChoseYourHeadingState extends State<WalletPanel> {
  String ua;

  _ChoseYourHeadingState(this.ua);
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Container(
        color: Colors.white,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/images/ramdan.jpg')
        //         ,fit: BoxFit.cover
        //   )
        //
        //
        // ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[

              Container(
                height: 180,
                child:Image.asset('assets/images/aa.jpg'),
              ),
              SizedBox(height: 25,),
              Text('رصيد حساب محفظتك ${ua}'),
              SizedBox(height: 25,),

              RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  child: Text('  تفضل كل اربع ساعات هديتك موجودة',style: TextStyle(color: Colors.white)),
                  color: Colors.red,
                onPressed: ()=>null

              ),
              SizedBox(height: 4,),

              RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  child: Text('رجوع',style: TextStyle(color: Colors.white)),
                  color: Colors.black12,
                  onPressed: ()=>Navigator.pop(context)

              ),

              SizedBox(height: 25,),
              Text(' رصيدك يتم شحنه كل اربع ساعات بمبلغ قيمته 500 عملة ',style: TextStyle(fontSize: 14),),
              Container(
                width: MediaQuery.of(context).size.width-20,
                child: Text('احرص على جمع هذا الرصيد بوقته سيختفي الرصيد ',style: TextStyle(fontSize: 14),          textAlign: TextAlign.center,
                ),
              ),
              Text('في حال عدم  جمعه في الوقت المحدد',style: TextStyle(fontSize: 14),          textAlign: TextAlign.center,),
              Text(' لكن لاتقلق سيتوفر الرصيد في الاربع ',style: TextStyle(fontSize: 14),          textAlign: TextAlign.center,),
              Text(' ساعات الأخرى مجموع    الرصيد الممكن جمعه',style: TextStyle(fontSize: 14),          textAlign: TextAlign.center,),
              Text(' خلال اليوم هو 3000 عملة نقدية',style: TextStyle(fontSize: 14),          textAlign: TextAlign.center,),
              Text('احرص على جمعها جميعاً',style: TextStyle(fontSize: 14),          textAlign: TextAlign.center,),
              Container(
                  width: MediaQuery.of(context).size.width-10,
                  child: Text('اوقات الجمع من (ال8 لغاية ال12)ً',style: TextStyle(),          textAlign: TextAlign.center,)),
              Text('  ومن (ال12 لغاية ال4) ا',style: TextStyle(fontSize: 14),          textAlign: TextAlign.center,),
              Text('ومن (ال4 لغاية ال12) صباحاً ومسائا',style: TextStyle(fontSize: 14),          textAlign: TextAlign.center,),



            ]
      ),
        ),
    ));
  }
}
