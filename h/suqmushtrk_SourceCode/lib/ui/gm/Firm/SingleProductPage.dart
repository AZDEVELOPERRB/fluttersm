import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/ui/gm/Firm/underPlaying.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/ui/dashboard/core/dashboard_view.dart';
import 'package:ntp/ntp.dart';
class SingleProductPage extends StatefulWidget {
  String uid;
  String pid;
  SingleProductPage(this.uid,this.pid);
  @override
  _SingleProductPageState createState() => _SingleProductPageState(uid,pid);
}

class _SingleProductPageState extends State<SingleProductPage> {
  String uid;
  String pid;
  _SingleProductPageState(this.uid,this.pid);

  Future<Map> get_pd()async{
    var mar = {
      'user_id': uid,
      'pid': pid,
    };
    String ur = '${RoyalBoardConfig
        .RoyalBoardAppUrl}rest/users/firm_Played/api_key/${RoyalBoardConfig
        .RoyalBoardServerLanucher}';

    var response= await http.post(ur,body: mar);
    var message=jsonDecode(response.body)['message'];
    print('ghfghfghfghgf${message}');
    return message;
  }
  bool isload=false;
  bool wichstate=false;
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return     FutureBuilder(
      future: get_pd(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          double urw=double.parse('${snapshot.data['user']['RDP']}');
          double prw=double.parse('${snapshot.data['ps']['RDP']}');
          double percent=urw*100/60;
          return Scaffold(
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
                  child:  Column(
                    children:<Widget>[
                      SizedBox(height: 40,),
                      RaisedButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                          child: Text('رجوع',style: TextStyle(color: Colors.white),),
                          color: Colors.red,
                          onPressed: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (ctx)=>DashboardView()
                            ));
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
                      SizedBox(height: 40,),
                      Text('اسم المنتج : ${snapshot.data['ps']['name']}',style: TextStyle(color: Colors.black),),

                      SizedBox(height: 10,),
                      isload==true?CircularProgressIndicator(): InkWell(
                       onTap: ()async{


                         setState(() {
                           isload=true;
                         });
                         var timenow=await NTP.now();
                         var mar = {
                           'user_id': uid,
                           'pid': pid,
                           'user_time':'${timenow}'
                         };
                         String ur = '${RoyalBoardConfig
                             .RoyalBoardAppUrl}rest/users/firm_go/api_key/${RoyalBoardConfig
                             .RoyalBoardServerLanucher}';

                         var response= await http.post(ur,body: mar);
                         var message=jsonDecode(response.body)['message'];

                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => UnderPlayingFirm(uid,pid)),
                         );

                         setState(() {
                           isload=false;
                         });

                       },
                       child: Container(
                         width: 60,
                         height: 60,

                         decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           color: Colors.green
                         ),
                         child: Center(child: Text('البدأ',style: TextStyle(color: Colors.white,fontSize: 16),)),
                       ),
                     ),

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
                      wichstate==false?Container(): Row(
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
                              height:40,child: Center(child: Text('%100',style: TextStyle(color: Colors.black),)))
                        ],
                      )









                    ],
                  ),
                ),
              )
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
                          Text('= 5',style: TextStyle(color: Colors.black),)
                        ],
                      ),

                      Row(
                        children: <Widget>[
                          SizedBox(width: 1,),
                          Text('حصل على المزيد 1',style: TextStyle(color: Colors.black),),

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
                      Text(' جاري تحضير بياناتك من الانترنت ...',style: TextStyle(color: Colors.black),)


                    ],
                  ),
                ),
              )
          );
        }
      }
    )
    ;
  }
}
