import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/ui/gm/rog.dart';
import 'package:RoyalBoard_Common_sooq/ui/gm/rog_tow.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Congratulation extends StatefulWidget{
  String id;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return sonRo();
  }

}
class sonRo extends State<Congratulation>{
  String id;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/congratulation.gif"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(              mainAxisAlignment: MainAxisAlignment.center,


            children: <Widget>[
              SizedBox(height: 40,),

              ElevatedButton(
                  child: Text(
                      "غلق هذا الاشعار دائماً".toUpperCase(),
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
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RoGameTow(id,'aa')),
                    );
                  }
              ),

            ],
          ),
        ),
      ),
    );
  }

}