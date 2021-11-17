import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/ui/gm/rog.dart';
import 'package:RoyalBoard_Common_sooq/ui/gm/rog_tow.dart';
import 'package:fluttertoast/fluttertoast.dart';
class RoSwitch extends StatefulWidget{
  String id;
  RoSwitch(this.id);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
return sonRo(id);
  }

}
class sonRo extends State<RoSwitch>{
  String id;
  sonRo(this.id);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/rolab.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(              mainAxisAlignment: MainAxisAlignment.center,


            children: <Widget>[
              ElevatedButton(
                  child: Text(
                      "  لعب  عجلة الحظ والفوز  بالجواهر ".toUpperCase(),
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
                  onPressed: () {
                    print('frjhdfghfdg$id');

                    if(id==null) {
                      Fluttertoast.showToast(
                          msg: 'يجب ان تقوم بتسجيل الدخول اولاً',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white
                      );

                    }
                    else if(id==''){
                      Fluttertoast.showToast(
                          msg: 'يجب ان تقوم بتسجيل الدخول اولاً',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white
                      );
                    }
                    else
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RoGame(id, 'aa')),
                        );
                      }
                  }
              ),
              ElevatedButton(
                  child: Text(
                      "استخارة".toUpperCase(),
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
                    Navigator.pop(context,true);
                  }
              )
            ],
          ),
        ),
      ),
    );
  }

}