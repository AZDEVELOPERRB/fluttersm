import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/ui/map/current_location_view.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/Markets_class/Jomla_Register.dart';
import 'package:RoyalBoard_Common_sooq/Mhellper/Markets_class/Mufrad_Register.dart';
class Market_Reg extends StatefulWidget {
  String user_id;

  Market_Reg(this.user_id);
  @override
  _Market_RegState createState() => _Market_RegState();
}

class _Market_RegState extends State<Market_Reg> {

  @override
  Widget build(BuildContext context) {
    SizedBox divider=SizedBox(height: 20,);
    var size=MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Center(
          child: Stack(
            children: [
              Container(
                height: size.height/5,
                child: Center(
                  child: Positioned(
                    top: 1,
                    child:  Container(
                      width: size.width/2.8,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue
                      ),

                      child: Center(child: Text('منصة التاجر',style: TextStyle(fontSize:19,color: Colors.white),)),

                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  divider,
                  Container(
                    width: size.width/2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey
                    ),
                    child: Center(child: Text('هل انت تاجر جملة ام مفرد ؟',style: TextStyle(color: Colors.white),)),
                  ),
                  divider,
                  divider,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),

                        ),
                        color: Colors.blue,
                        child: Text('جملة / شركة',style: TextStyle(color: Colors.white),),
                        onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=>Jomla_Register(widget.user_id)));
                        },
                      ),
                      SizedBox(width: 20,),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),

                        ),
                        color: Colors.blue,
                        child: Text('مفرد',style: TextStyle(color: Colors.white),),
                        onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=>Mufrad_Register(widget.user_id)));

                        },
                      )
                    ],

                  ),
                  divider,

                ],

              ),
              Positioned(
                bottom: size.height/8,
                child: Container(
                  width: size.width,
                  height: 20,
                  child: Center(
                    child: Container(
                      width: size.width/1.07,
                      height: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.green
                      ),
                      child: Center(child: Text('السوق المشترك حيث تزدهر تجارتك وتتواصل مع عملاء اكثر',style: TextStyle(color: Colors.white),)),
                    ),
                  ),
                ),
              )

            ],
          ),
        )
      ),
    );
  }
}
