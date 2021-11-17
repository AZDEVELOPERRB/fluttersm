import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/cupertino.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:ntp/ntp.dart';
import 'package:RoyalBoard_Common_sooq/api/ENC_RoyalServices.dart';




class RoGame extends StatefulWidget{
  String id;
  var rolletua;
  RoGame(this.id,this.rolletua);
  @override
  State<StatefulWidget> createState() {
    print('dasdasgsdgs$id');
    // TODO: implement createState
    return sonclass(id);
  }

}
class sonclass extends State<RoGame>{
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
    1: ENC_Royal_Services.nl,
    2: ENC_Royal_Services.Adeen,
    3: ENC_Royal_Services.nl,
    4: ENC_Royal_Services.dva,
    5: ENC_Royal_Services.proxidit,
    6: ENC_Royal_Services.dva,
    7: ENC_Royal_Services.nl,
    8: ENC_Royal_Services.dva,
  };
  AnimationController animationController;
bool circ=false;
Future<bool>backm()async{

    aa.stop();
    Navigator.pop(context,true);


}

  @override
  Widget build(BuildContext context) {



    return WillPopScope(
      onWillPop: backm,
      child: Scaffold(

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


                        child: Container(margin: EdgeInsets.all(3), child: Row(children: [Text(' النقاط :', textAlign: TextAlign.start, style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),),SizedBox(width: 5,), Text('   ${rolletua}', textAlign: TextAlign.start, style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),), Container(width: 20, child: Image.asset('assets/images/jawhara.png'),)],),)),):Container(height: 40,width: 200,),




                  SizedBox(height: 10,),
                  SpinningWheel(
                    Image.asset('assets/images/rol.png'),
                    width: 310,
                    height: 310,
                    initialSpinAngle: _generateRandomAngle(),
                    spinResistance: 0.999,
                    canInteractWhileSpinning: false,
                    dividers: 8,
                    onUpdate: _dividerController.add,
                    onEnd:(value)async{
                      var timenow=await NTP.now();
                      DateTime _ntp=DateTime.parse("${timenow}");
                      setState(() {circ=true;});
                      if(toserver==true) {
                        if(value!=5){var mar = {'user_id': id, 'rolletua': '${va[value]}', 'rolltime': '${_ntp}'};String ur = '${RoyalBoardConfig.RoyalBoardAppUrl}rest/users/rolletua_update/api_key/${RoyalBoardConfig.RoyalBoardServerLanucher}';await http.post(ur,body: mar);}
                      setState(() {toserver=false;});}
                      setState(() {circ=false;});await aa.stop();},
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
                        if(earn==true){


                          print('asdasdasdasdasd${snapshot.data}');

                          return RouletteScore(snapshot.data);


                        }
                        else{
                          return Container();
                        }
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
                        if(rolletua==null){
                          Fluttertoast.showToast(msg: "لايمكنك اللعب بدون معرفة رصيد الجواهر",backgroundColor: Colors.red);

                          return ;
                        }
                        if(int.parse("${rolletua}")>30){
                          Fluttertoast.showToast(msg: "لايمكنك اللعب لان جواهرك اكثر من 30 جوهرة",backgroundColor: Colors.red);
                          return;
                        }
                        if(int.parse("${rolletua}")==30){
                          Fluttertoast.showToast(msg: "لايمكنك اللعب لان جواهرك  30 جوهرة",backgroundColor: Colors.red);
                          return;
                        }
                        setState(() {
                          toserver=true;
                        });
                        var timenow=await NTP.now();
                        DateTime _ntp=DateTime.parse("${timenow}");
                        AudioCache player = new AudioCache(prefix: 'images/audio/', fixedPlayer:aa );

                        player.play('wav.wav');

                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        print('asdsfrgsdsfdl${prefs.getString('rolletnow')}');

                        DateTime dateTime = DateTime.parse(prefs.getString('rolletnow'));

                        DateTime n=_ntp;
                        DateTime fiftyDaysAgo = n.subtract(const Duration(milliseconds: 1));
                        final difference = dateTime.difference(n).inMilliseconds;
                        await  prefs.setString('rolletnow', '${_ntp}');
                        if(fiftyDaysAgo.isAfter(dateTime)) {


                          setState(() {
                            earn=true;
                            allowTime=false;

                          });

                          _wheelNotifier.sink.add(_generateRandomVelocity());


                          // yaya = '   عليك ان تنتظر ساعتان  حتى تستطيع اللعب مجدداً';








                        }

                        else{
                        allowTime=false;
                        yaya='  لقد مضت فقط $difference دقيقة يجب ان تنتظر دقيقة ';
                        }

                      }
                  ):Text('$yaya',style:TextStyle(color: RoyalBoardColors.white,backgroundColor:Colors.cyan ),),
                 SizedBox(height: 4,),
                 checkper==false?ElevatedButton(
                    child: Text("فحص ترخيصك للعب"),
                    onPressed: ()async{
                      //check time from server start
setState(() {
  checkper=true;
});
var timenow=await NTP.now();
DateTime _ntp=DateTime.parse("${timenow}");
                    if(id!=null){
                      String url = '${RoyalBoardConfig
                          .RoyalBoardAppUrl}rest/users/rollettime_get/api_key/${RoyalBoardConfig
                          .RoyalBoardServerLanucher}';
                      var toserver={
                        'user_id':id
                      };
                      var response= await http.post(url,body: toserver);
                      print('rdthrtshsehrst${response.body}');
                      if(response.body.isEmpty){

                        setState(() {
                          servnot='حطأ في الاتصال';
                        });
                      }
                      else{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        var checkdata=jsonDecode(response.body)['message']['message'];

                        setState(() {
                          jsonDecode(response.body)['message']['ua']!=null?ua=jsonDecode(response.body)['message']['ua']
                          :ua='0';
                          jsonDecode(response.body)['message']['ra']!=null?rolletua=jsonDecode(response.body)['message']['ra']
                          :rolletua='0';
                          user_info=true;
                        });

                        if(checkdata==null){

                          DateTime fiftyDaysAgoo = _ntp.subtract(const Duration(milliseconds: 1));

                          await  prefs.setString('rolletnow', '${fiftyDaysAgoo}');
                           checkdata=await prefs.getString('rolletnow');
                          String urlup = '${RoyalBoardConfig
                              .RoyalBoardAppUrl}rest/users/rollettime_update/api_key/${RoyalBoardConfig
                              .RoyalBoardServerLanucher}';
                          var toservertime={
                            'user_id':id,
                            'nowtime':'${fiftyDaysAgoo}'
                          };
                          var response= await http.post(urlup,body: toservertime);
                          if(jsonDecode(response.body)['message']=='success_update_time') {
                            checkdata='${fiftyDaysAgoo}';
                          }
                          else{
                          }



                        }


                        await  prefs.setString('rolletnow', '${checkdata}');
                        DateTime dateTime = DateTime.parse(checkdata);





                        DateTime n=_ntp;
                        DateTime fiftyDaysAgo = n.subtract(const Duration(milliseconds: 1));
                        final difference = dateTime.difference(n).inMilliseconds;





                        if(fiftyDaysAgo.isAfter(dateTime)) {
                          if(jsonDecode(response.body)['message']['ua']!=null) {
                            if (double.parse(
                                jsonDecode(response.body)['message']['ua']) >=
                                1000) {
                              setState(() {
                                allowTime = true;
                                earn = false;
                                yaya = '';
                              });
                            }
                            else {
                              Fluttertoast.showToast(
                                  msg: 'رصيدك غير كافي للعب على الاقل تحتاج الف عملة نقدية',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white
                              );
                            }
                          }else {
                            Fluttertoast.showToast(
                                msg: 'رصيدك غير كافي للعب على الاقل تحتاج الف عملة نقدية',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white
                            );
                          }

                          // earn=true;



                        }
                        else{
                          setState(() {

                            allowTime=false;
                            earn=false;
                            yaya='  لقد مضت فقط $difference ساعة يجب انت تنتظر ساعتان  ';
                          });

                        }
                      }
                      //check time end
                    }
                    else{
                      setState(() {

                      yaya='يبدو انك لم تقم بتسجيل الدخول';
                      });
                    }

                        setState(() {
                          checkper=false;
                        });

                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  )
         : Theme(
                   data: Theme.of(context).copyWith(accentColor: Colors.white),
                   child: new CircularProgressIndicator(),
                 )

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
    1: ENC_Royal_Services.wgl,
    2: ENC_Royal_Services.odinJ,
    3: ENC_Royal_Services.wgl,
    4: ENC_Royal_Services.dvaJ,
    5: ENC_Royal_Services.cong,
    6: ENC_Royal_Services.dvaJ,
    7: ENC_Royal_Services.wgl,
    8: ENC_Royal_Services.dvaJ,
  };

  RouletteScore(this.selected);

  @override
  Widget build(BuildContext context) {

    print('gdasfasgasgfasfg${ENC_Royal_Services.proxidit}');
    return Text('${labels[selected]}',
        style: TextStyle(color:RoyalBoardColors.white,fontStyle: FontStyle.italic, fontSize: 24.0));
  }


}
