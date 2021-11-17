import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_colors.dart';
import 'package:RoyalBoard_Common_sooq/ui/dashboard/core/dashboard_view.dart';
import 'package:RoyalBoard_Common_sooq/ui/gm/firm_prices.dart';
import 'package:RoyalBoard_Common_sooq/ui/gm/red_to_play.dart';
import 'package:RoyalBoard_Common_sooq/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:ntp/ntp.dart';

class UnderPlayingFirm extends StatefulWidget {
  String uid;
  String pid;
  UnderPlayingFirm(this.uid,this.pid);
  @override
  _SingleProductPageState createState() => _SingleProductPageState(uid,pid);
}

class _SingleProductPageState extends State<UnderPlayingFirm> {
  String uid;
  String pid;
  _SingleProductPageState(this.uid,this.pid);
  DateTime _dtnet;

  Future<Map> get_pd()async{
    var timenow=await NTP.now();

      _dtnet=DateTime.parse("${timenow}");



    var mar = {
      'user_id': uid,
      'pid': pid,
    };
    String ur = '${RoyalBoardConfig
        .RoyalBoardAppUrl}rest/users/firm_Played/api_key/${RoyalBoardConfig
        .RoyalBoardServerLanucher}';

    var response= await http.post(ur,body: mar);
    var message=jsonDecode(response.body)['message'];

    return message;
  }
  bool isload=false;
  bool wichstate=false;
  bool winners=false;
  Future<bool> _onwillpop(){
    Navigator.pushAndRemoveUntil(context,   MaterialPageRoute(builder: (context) => DashboardView()), (route) => false);
  }
  String image_url = '${RoyalBoardConfig
      .RoyalBoardImagesUrl}';
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;

    return     WillPopScope(
      onWillPop: _onwillpop,
      child: FutureBuilder(
        future: get_pd(),
        builder: (context, snapshot) {
          List <String> images_slider=[];

          if(snapshot.hasData&&_dtnet!=null){
            for(var i in  snapshot.data['images']){
              images_slider.add('${image_url}${i['img_path']}');

            }

            double urw=double.parse('${snapshot.data['user']['RDP']}');
            DateTime rest_time=DateTime.parse('${snapshot.data['user']['firm_time']}').add(Duration(days: 1));
            var difference=rest_time.difference(_dtnet).inHours;

            double prw=double.parse('${snapshot.data['ps']['RDP']}');
            double percent=urw*100/prw;
            return WillPopScope(
              onWillPop: _onwillpop,
              child: Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: Container(

                      // decoration: BoxDecoration(
                      //     image: DecorationImage(
                      //         image: AssetImage('assets/images/firm_background.jpg'),
                      //         fit: BoxFit.cover
                      //     )
                      // ),
                      height: size.height,
                      padding: EdgeInsets.all(8),
                      child:  SingleChildScrollView(
                        child: Column(
                          children:<Widget>[
                            SizedBox(height: 40,),
                            RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                                child: Text('رجوع',style: TextStyle(color: Colors.white),),
                                color: Colors.red,
                                onPressed: (){
                                  Navigator.pushAndRemoveUntil(context,   MaterialPageRoute(builder: (context) => DashboardView()), (route) => false);
                                }),
                            Text('فرم الاسعار',style: TextStyle(color: Colors.black),),
                            Text('احصل على منتجات مجانية عند جمعك لفريق',style: TextStyle(color: Colors.black,fontSize: 17),),
                            SizedBox(height: 15,),

                            Row(
                              children: <Widget>[
                                SizedBox(width: 1,),
                                Container(
                                  height: 40,
                                  child: Image.asset('assets/images/red_jawhara.png'),
                                ),
                                Text('= ${snapshot.data['user']['RDP']}',style: TextStyle(color: Colors.black),)
                              ],
                            ),

                            Row(
                              children: <Widget>[
                                SizedBox(width: 1,),
                                Text('احصل على المزيد 1',style: TextStyle(color: Colors.black),),

                                Container(
                                  height: 40,
                                  child: Image.asset('assets/images/red_jawhara.png'),
                                ),
                                Text('= 3',style: TextStyle(color: Colors.black),)
                                ,SizedBox(width: 4,),
                                Container(
                                  height: 20,
                                  child: Image.asset('assets/images/jawhara.png'),
                                ),
                              ],
                            ),
                            double.parse('${snapshot.data['user']['RDP']}')>=double.parse('${snapshot.data['ps']['RDP']}') ?   Row(
                              children: [
                                Text('مبروك لقد حققت سعر المنتج بالجواهر اضغط هنا لربح المنتج',style: TextStyle(color: Colors.lightGreen,fontWeight: FontWeight.w800),)
                              ],
                            ):Container(),
                            Row(
                              children: [
                           double.parse('${snapshot.data['user']['RDP']}')<=double.parse('${snapshot.data['ps']['RDP']}') ?   RaisedButton(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    child: Text('شراء جواهر حمراء الآن',style: TextStyle(color: Colors.black),),
                                    color: Colors.black12,
                                    onPressed: (){

                                      Navigator.push(context, MaterialPageRoute(builder: (ctx)=>Red_To_Blue(uid)));
                                    }
                                    ):

                           winners==true?CircularProgressIndicator():RaisedButton(
                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                               child: Text('حصد المنتج الآن',style: TextStyle(color: Colors.black),),
                               color: Colors.lightGreen,
                               onPressed: ()async{
                                 setState(() {
                                   winners=true;
                                 });
                                 var mar = {
                                   'user_id': uid,
                                   'pid': snapshot.data['ps']['id'],
                                   'now':'${_dtnet}',
                                   'nowbefor':'${_dtnet.subtract(Duration(days: 2))}'
                                 };
                                 String ur = '${RoyalBoardConfig
                                     .RoyalBoardAppUrl}rest/users/firm_save_winners/api_key/${RoyalBoardConfig
                                     .RoyalBoardServerLanucher}';

                                 var response= await http.post(ur,body: mar);
                                 var message=jsonDecode(response.body)['message'];
                                 print('dfhdfhd');
                                if(message=='success_winner'){
                                  Fluttertoast.showToast(
                                      msg:
                                      'لقد تم ربح الجائزة بنجاح',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:Colors.green,
                                      textColor:Colors.white);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => DashboardView()),
                                  );


                                }
                                 setState(() {
                                   winners=false;
                                 });
                               }
                           )
                                ,


                              ],
                            ),

                            SizedBox(height: 10,),
                            Text('اسم المنتج : ${snapshot.data['ps']['name']}',style: TextStyle(color: Colors.black),),

                            SizedBox(height: 10,),


                            SizedBox(height: 20,),



                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 1,),

                                Text('سعر المنتج = ${snapshot.data['ps']['RDP']}',style: TextStyle(color: Colors.black),),
                                Container(
                                  height: 40,
                                  child: Image.asset('assets/images/red_jawhara.png'),
                                ),
                              ],
                            ),

                            SizedBox(height: 30,),
                            Text('وصف المنتج : ${snapshot.data['ps']['description']}',style: TextStyle(color: Colors.black),),
                            SizedBox(height: 10,),
                           Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Container(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width/3,
                                  child: Column(
                                    children: <Widget>[
                                     Container(
                                       margin: EdgeInsets.all(6),
                                       child: InkWell(
                                         onTap: ()async{

                                           String refid=''
                                               'عاجبتني هذي الهدية بتطبيق السوق المشترك'
                                               "\n"
                                               "\n"
                                               "https://play.google.com/store/apps/details?id=com.common.sooq "
                                               "\n"
                                               "ساعدني حب بالحصول عليها بالتصويت لي في قسم #فرم_الاسعار عن طريق ادخال الكود هذا في ايقونة التصويت لصديق"
                                               "  "
                                               ' والكود '
                                               'هو'
                                               "\n"
                                               '${snapshot.data['user']['ref_id']}  '
                                               ' ';
                                           await FlutterShare.share(
                                             title: 'تطبيق السوق المشترك',
                                             text: refid,
                                             chooserTitle:'تطبيق السوق المشترك',
                                           );
                                           //
                                           // Share.text('Referal_ID', ''
                                           //     'عاجبتني هذي الهدية بتطبيق السوق المشترك ساعدني حب بالحصول عليها بالتصويت لي في قسم #فرم_الاسعار عن طريق ادخال الكود هذا في ايقونة التصويت لصديق '
                                           //     ' الكود (  ${snapshot.data['user']['ref_id']}  )'
                                           //     '', 'file/text');

                                         },
                                         child: Row(
                                           children: <Widget>[
                                             Text('مشاركة الكود',style: TextStyle(color: Colors.black),),
                                             Icon(Icons.share,color: Colors.black,)

                                           ],
                                         ),
                                       ),
                                     ),
                                      SizedBox(height: 8,),
                                      Container(
                                        margin: EdgeInsets.all(4),
                                        child: InkWell(
                                          onTap: (){
                                            FlutterClipboard.copy(''
                                                'عاجبتني هذي الهدية بتطبيق السوق المشترك'
                                                "\n"
                                                "\n"
                                                "https://play.google.com/store/apps/details?id=com.common.sooq "
                                                "\n"
                                                "ساعدني حب بالحصول عليها بالتصويت لي في قسم #فرم_الاسعار عن طريق ادخال الكود هذا في ايقونة التصويت لصديق"
                                                "  "
                                                ' والكود '
                                                'هو'
                                                "\n"
                                            '${snapshot.data['user']['ref_id']}'
                                            ''
                                                '').then(( value ) =>
                                                Fluttertoast.showToast(
                                                    msg: 'لقد قمت بنسخ المعرف بنجاح',
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    backgroundColor: Colors.green,
                                                    textColor: Colors.white
                                                )
                                            );
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Text('نسخ الكود',style: TextStyle(color: Colors.black),),
                                              Icon(Icons.copy_sharp,color: Colors.black,)

                                            ],
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),


                                ),
                                Container(
                                  height: 40,
                                 width: MediaQuery.of(context).size.width/2.3,
                                 child:   LinearProgressIndicator(
                                   valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),

                                   value: percent/100,

                                      backgroundColor: Colors.black,
                                    )
                                ),
                                SizedBox(width: 20,),
                                Container(
                                    height:40,child: Center(child: Text('100%',style: TextStyle(color: Colors.black),)))
                              ],
                            ),


                            Text('الوقت المتبقي ${difference} ساعة',style: TextStyle(color: Colors.red,fontSize: 18,fontWeight:FontWeight.w900 )),
                            // InkWell(
                            //   onTap: (){
                            //     print('sdgsdgsdgggd${image_url}${snapshot.data['images'][0]['img_path']}');
                            //
                            //   },
                            //   child: Text('asdsd',style: TextStyle(color: Colors.black),),
                            // )
                            Container(
                              child: CarouselSlider(options: CarouselOptions(
                                scrollDirection: Axis.horizontal,
                                enlargeCenterPage: true,
                                autoPlay: false,
                                height: 420,
                              ),
                                items: images_slider.map((i){
                                  return Builder(builder: (BuildContext context){
                                    return Column(

                                      children: <Widget>[
                                        Container(
                                          height:200,
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(60),
                                              child: Image.network(i)),
                                        )
                                      ],
                                    );

                                  },);

                                }).toList()
                                ,),
                            ),









                          ],
                        ),
                      ),
                    ),
                  )
              ),
            );
          }
          else {
            return  Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Container(
                    // decoration: BoxDecoration(
                    //   image: DecorationImage(
                    //     image: AssetImage('assets/images/firm_background.jpg'),
                    //     fit: BoxFit.cover
                    //   )
                    // ),
                    height: size.height,
                    padding: EdgeInsets.all(8),
                    child:  Column(
                      children:<Widget>[
                        SizedBox(height: 40,),
                        Text('فرم الاسعار',style: TextStyle(color: Colors.black),),
                        Text('احصل على منتجات مجانية عند جمعك لفريق',style: TextStyle(color: Colors.black,fontSize: 17),),
                        SizedBox(height: 15,),

                        Row(
                          children: <Widget>[
                            SizedBox(width: 1,),
                            Container(
                              height: 40,
                              child: Image.asset('assets/images/red_jawhara.png'),
                            ),
                            Text('= عندما تكون مسجل دخول ستظهر النتيجة',style: TextStyle(color: Colors.black),)
                          ],
                        ),

                        Row(
                          children: <Widget>[
                            SizedBox(width: 1,),
                            Text('احصل على المزيد 1',style: TextStyle(color: Colors.black),),

                            Container(
                              height: 40,
                              child: Image.asset('assets/images/red_jawhara.png'),
                            ),
                            Text('= 3',style: TextStyle(color: Colors.black),)
                            ,SizedBox(width: 4,),
                            Container(
                              height: 20,
                              child: Image.asset('assets/images/jawhara.png'),
                            ),
                          ],
                        ),
                        SizedBox(height: 40,),
                        Center(child: CircularProgressIndicator(),)
                        , SizedBox(height: 40,),
                        Text(' جاري تحضير بياناتك من الانترنت ...',style: TextStyle(color: Colors.black),),

                      ],
                    ),
                  ),
                )
            );
          }
        }
      ),
    )
    ;
  }
}
