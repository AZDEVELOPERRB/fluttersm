import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/cupertino.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/ui/dashboard/core/dashboard_view.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:ntp/ntp.dart';
import 'package:RoyalBoard_Common_sooq/api/ENC_RoyalServices.dart';


class RoGameTow extends StatefulWidget{
  String id;
  var rolletua;
  RoGameTow(this.id,this.rolletua);

  @override
  State<StatefulWidget> createState() {
    print('dasdasgsdgs$id');
    // TODO: implement createState
    return sonclass(id);
  }

}
class sonclass extends State<RoGameTow>{
String id;
var rolletua='';
var ua='';

sonclass(this.id);
  String yaya="";
  bool allowTime=false;
  bool earn=false;
  bool toserver=false;
  bool checkper=false;
  bool user_info=false;
  var dada;
  String servnot="";
final AudioPlayer aa=AudioPlayer();


// AudioPlayer audioPlayer =new AudioPlayer();


  @override

  void initState() {



    super.initState();
  }
  @override

  final StreamController _dividerController = StreamController<int>();

  final _wheelNotifier = StreamController<double>();
  // aa()async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   setState(() {
  //
  //     DateTime dateTime = DateTime.parse(prefs.getString('rolletnow'));
  //
  //     DateTime n=DateTime.now();
  //     DateTime fiftyDaysAgo = n.subtract(const Duration(minutes: 5));
  //     final difference = dateTime.difference(n).inMinutes;
  //     if(fiftyDaysAgo.isAfter(dateTime)) {
  //       yaya = ' لقد انتهى الوقت';
  //       allowTime=true;
  //       prefs.setBool('rolletallow', true);
  //
  //
  //     }
  //     else{
  //       prefs.setBool('rolletallow', false);
  //       allowTime=false;
  //       yaya='  لقد مضت فقط $difference دقيقة يجب انت تنتظر دقيقة ';
  //     }
  //   });
  // }

  @override
  dispose(){

    _dividerController.close();
    _wheelNotifier.close();
    super.dispose();
  }
  final Map<int, String> va = {
    1: '0',
    2: '1',
    3: '0',
    4: '2',
    5: 'sahb',
    6: '2',
    7: '0',
    8: '2',
    // 1: 'نتمنى لك حظ سعيد',
    // 2: 'جوهرة واحدة',
    // 3: 'نتمنى لك حظ سعيد',
    // 4: 'جوهرتان',
    // 5: 'مبروك على فرصة الفوز بسحبة واحدة',
    // 6: 'جوهرتان',
    // 7: 'نتمنى لك حظ سعيد',
    // 8: 'جوهرتان',
  };
  AnimationController animationController;
bool circ=false;
 Future<bool> _willPopCallback()async{
aa.stop();
Navigator.pop(context,true);
  }
  @override
  Widget build(BuildContext context) {



    return WillPopScope(
    onWillPop: _willPopCallback,
      child: new Scaffold(

        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/rolab.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 25,),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 25,),
                      InkWell(
                        onTap: () {
                          aa.stop();

                          Navigator.pop(context,true);
                        },
                        child: DecoratedBox(
                            decoration: const BoxDecoration(color: Colors.white70
                                ,borderRadius: BorderRadius.all(Radius.circular(10))),


                            child:Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.exit_to_app,color: Colors.black,),
                            )
                        ),
                      ),

                    ],
                  ),
                user_info==true? Container(
                    width: 200,
                    height: 40,
                    child: DecoratedBox(
                        decoration: const BoxDecoration(color: Colors.white70
                            ,borderRadius: BorderRadius.all(Radius.circular(10))),


                        child: Container(
                          margin: EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Text(
                                ' الرصيد :',
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.subtitle1.copyWith(
                                    color: Colors.black, fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),SizedBox(width: 5,),

                              Text(
                                '   ${ua} عملة نقدية ',
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.subtitle1.copyWith(
                                    color: Colors.black, fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              )

                            ],
                          ),
                        )
                    ),
                  ):Container(width:200 ,height: 40,),
                 SizedBox(height: 10,),
                user_info==true? Container(
                    width: 130,
                    height: 40,
                    child: DecoratedBox(
                        decoration: const BoxDecoration(color: Colors.white70
                            ,borderRadius: BorderRadius.all(Radius.circular(10))),


                        child: Container(
                        margin: EdgeInsets.all(3),
                    child: Row(
                      children: [
                        Text(
                          ' النقاط :',
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Colors.black, fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),SizedBox(width: 5,),

                        Text(
                          '   ${rolletua}',
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Colors.black, fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ), Container(width: 20,
                          child: Image.asset('assets/images/jawhara.png'),)

                      ],
                    ),
                  )
                    ),
                  ):Container(height: 40,width: 200,),
                  SizedBox(height: 10,),

                  SpinningWheel(
                    Image.asset('assets/images/roltow.png'),
                    width: 310,
                    height: 310,
                    initialSpinAngle: _generateRandomAngle(),
                    spinResistance: 0.999,
                    canInteractWhileSpinning: false,
                    dividers: 8,

                    onUpdate: _dividerController.add,
                    onEnd:(value)async{


                      await aa.stop();





                      //end saving points
                    },
                    secondaryImage:
                    Image.asset('assets/images/rolcenter.png'),
                    secondaryImageHeight: 110,
                    secondaryImageWidth: 110,
                    shouldStartOrStop: _wheelNotifier.stream,
                  ),
                  SizedBox(height: 15),
                  circ==true?Theme(
                    data: Theme.of(context).copyWith(accentColor: RoyalBoardColors.white),
                    child: new CircularProgressIndicator(),
                  ):Container(),
                  circ==true?Text('يرجى الانتظار جاري حفظ ارباحك ', style: TextStyle(backgroundColor: Colors.blue,color: Colors.white),):Container(),
                  circ==true?Text('في خوادم الشركة لضمان حقوقك', style: TextStyle(backgroundColor: Colors.blue,color: Colors.white),):Container(),
                  SizedBox(height: 30),
                  earn==true? Text('لقد حصلت على',
                  style:TextStyle(color:RoyalBoardColors.white) ,):Text(''),

                 StreamBuilder(
                    stream: _dividerController.stream,

                    builder: (context, snapshot) {
                      if(snapshot.hasData){



                          print('asdasdasdasdasd${snapshot.data}');

                          return RouletteScore(snapshot.data);


                        }



                      else{
                        return Container();
                      }
                 }

                  ),
                  SizedBox(height: 1),
                  Text(servnot),
                  allowTime==true?new ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      child: new Text("  1000 الف عملة نقدية للبدأ "),
                      onPressed: ()async{
                        setState(() {
                          toserver=true;
                        });

                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        print('asdsfrgsdsfdl${prefs.getString('rolletnow')}');

                        DateTime dateTime = DateTime.parse(prefs.getString('rolletnow'));


                        DateTime n=await NTP.now();
                        DateTime fiftyDaysAgo = n.subtract(const Duration(milliseconds: 1));
                        final difference = dateTime.difference(n).inMilliseconds;
                        await  prefs.setString('rolletnow', '${n}');
                        if(fiftyDaysAgo.isAfter(dateTime)) {


                          setState(() {
                            earn=true;
                            allowTime=false;

                          });

                          _wheelNotifier.sink.add(_generateRandomVelocity());


                          yaya = '   عليك ان تنتظر ساعتان  حتى تستطيع اللعب مجدداً';








                        }

                        else{
                        allowTime=false;
                        yaya='  لقد مضت فقط $difference دقيقة يجب انت تنتظر دقيقة ';
                        }

                      }
                  ):Text('$yaya',style:TextStyle(color: RoyalBoardColors.white,backgroundColor:Colors.cyan ),),
                 SizedBox(height: 4,),
                 checkper==false?ElevatedButton(
                    child: Text("لعب الآن"),
                    onPressed: (){
                      AudioCache player = new AudioCache(prefix: 'images/audio/', fixedPlayer:aa );

                      player.play('wav.wav');

                      print('dfhdhedrhgred');
                      _wheelNotifier.sink.add(_generateRandomVelocity());


                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white70,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  )
         : Theme(
                   data: Theme.of(context).copyWith(accentColor: Colors.white),
                   child: new CircularProgressIndicator(),
                 )
            // ElevatedButton(
            //   child: Text("فحص  "),
            //   onPressed: ()async{
            //
            //   },
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.green,
            //     onPrimary: Colors.white,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(32.0),
            //     ),
            //   ),
            // )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _generateRandomVelocity() => (Random().nextDouble() * 6000) + 60000;

  double _generateRandomAngle() => Random().nextDouble() * pi * 2;

}
class RouletteScore extends StatelessWidget {
  final int selected;

  final Map<int, String> labels = {
    1: ENC_Royal_Services.da,
    2: ENC_Royal_Services.net,
    3: ENC_Royal_Services.pdgdet,
    4: ENC_Royal_Services.da,
    5: ENC_Royal_Services.net,
    6: ENC_Royal_Services.pdgdet,
    7: ENC_Royal_Services.da,
    8: ENC_Royal_Services.net,
  };

  RouletteScore(this.selected);

  @override
  Widget build(BuildContext context) {
    return Text('${labels[selected]}',
        style: TextStyle(color:RoyalBoardColors.white,fontStyle: FontStyle.italic, fontSize: 24.0));
  }


}
