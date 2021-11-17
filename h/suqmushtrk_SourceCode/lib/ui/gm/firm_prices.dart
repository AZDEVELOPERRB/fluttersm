import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/ui/gm/Firm/underPlaying.dart';
import 'package:RoyalBoard_Common_sooq/ui/gm/constant.dart';
import 'package:charts_flutter/flutter.dart'as charts;
import 'package:RoyalBoard_Common_sooq/ui/gm/Firm/SingleProductPage.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:RoyalBoard_Common_sooq/ui/dashboard/core/dashboard_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ntp/ntp.dart';


class Firm_prices extends StatefulWidget {
 String id;
 List product;
Firm_prices(@required this.id,{this.product});

  @override
  _ProductListWithFilterViewState createState() =>
      _ProductListWithFilterViewState(id,product: product);
}

class _ProductListWithFilterViewState extends State<Firm_prices>{
  String id;
  List product;

  _ProductListWithFilterViewState(@required this.id,{this.product});
  final CategoriesScroller categoriesScroller = CategoriesScroller();
  bool checkstate=false;
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  bool _isloading=false;

  List<Widget> itemsData = [];

  String urlofimage = '${RoyalBoardConfig
      .RoyalBoardImagesUrl}';
  void getPostsData() {

    List<dynamic> responseList = product;
    List<Widget> listItems = [];

    responseList.forEach((post) {
      // List<charts.Series<dynamic ,String>>chartlist=[
      //   charts.Series(
      //     id:'subscribers',
      //     data: FOOD_DATA,
      //     domainFn: (dynamic int,_)=> post["name"],
      //     measureFn:(dynamic int,_)=> post["RDP"],
      //       labelAccessorFn: (dynamic sales, _) => post["pr"]
      //   )
      //
      // ];
      listItems.add(SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
            height: 250,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: [
                      Container(
                        width: 120,
                        decoration: BoxDecoration(
                          boxShadow: []

                        ),
                        child: RaisedButton(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                          child: Text('العب',style: TextStyle(color: Colors.black),),
                          onPressed: (){
                            Navigator.pushReplacement(context,  MaterialPageRoute(
                                builder: (context)=>SingleProductPage(id,post['id'])
                            ));

                          },
                        )
                      ),
                      Text('${post['desc']}',style: TextStyle(color:Colors.black),)
                    ],

                  ),
                  SizedBox(width: 30,),
                  // Container(
                  //     height: 100,
                  //     width: 100,
                  //     child: charts.BarChart(chartlist,animate: true,animationDuration: Duration(seconds: 2),      vertical: false,
                  //     )),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(

                          child: Text(
                            post["name"],
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),
                          ),
                        ),
                        // Text(
                        //   post["name"],
                        //   style: const TextStyle(fontSize: 10, color: Colors.white),
                        // ),
                        Row(
                          children: <Widget>[
                            Text(' السعر ${post['RDP']}',style: TextStyle(color: Colors.black),),
                            Container(
                              height: 60,
                              child: Image.asset('assets/images/red_jawhara.png'),
                            )

                          ],
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Text(
                        //   "\$ ${post["unit_price"]}",
                        //   style: const TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
                        // ),
                        Container(
                          height: 120,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),

                              child:
                              CachedNetworkImage(
                                imageUrl: '${urlofimage}${post['image']}',
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),

                             )
                              // Image.network('${urlofimage}${post['image']}')),
                        )
                      ],
                    ),
                  ),

                  // Image.asset(
                  //   "assets/images/${post["image"]}",
                  //   height: double.infinity,
                  // )
                ],
              ),
            )),
      ));
    });
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  void initState() {
    getPostsData();
    super.initState();
    controller.addListener(() {

      double value = controller.offset/119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height*0.30;
    return Scaffold(

      body: Container(
        color: Colors.white54,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage('assets/images/firm_background.jpg'),
        //         fit: BoxFit.cover
        //     )
        // ),
        height: size.height,
        child: Column(
          children: <Widget>[
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: <Widget>[
            //     Text(
            //       "Loyality Cards",
            //       style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20),
            //     ),
            //     Text(
            //       "Menu",
            //       style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
            //     ),
            //   ],
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            // AnimatedOpacity(
            //   duration: const Duration(milliseconds: 200),
            //   opacity: closeTopContainer?0:1,
            //   child: AnimatedContainer(
            //       duration: const Duration(milliseconds: 200),
            //       width: size.width,
            //       alignment: Alignment.topCenter,
            //       height: closeTopContainer?0:categoryHeight,
            //       child: categoriesScroller),
            // ),

            Expanded(
                child: ListView.builder(
                    // controller: controller,
                    itemCount: itemsData.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      double scale = 1.0;
                      if (topContainer > 0.5) {
                        scale = index + 0.5 - topContainer;
                        if (scale < 0) {
                          scale = 0;
                        } else if (scale > 1) {
                          scale = 1;
                        }
                      }
                      return  index==0? Column(
                        children: [
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)

                            ),
                            color:Colors.black12,
                            child: Text('رجوع',style: TextStyle(color: Colors.white),),

                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DashboardView()),
                              );
                            },
                          ),
                          Text(''
                        '  اختر هديتك لهذا اليوم حتى تقوم بفرم سعرها'
                          '',style: TextStyle(color: Colors.black87),),
                          Text(' للصفر بالمشاركة ومساندة الاصدقاء حتى تحصل عليها مجاناً ',style: TextStyle(color: Colors.black87),),
                          Text('( كل يوم يحق لك اختيار هدية واحدة) حظاً سعيد',style: TextStyle(color: Colors.black87),),
                          Opacity(
                            opacity: scale,
                            child: Transform(
                              transform:  Matrix4.identity()..scale(scale,scale),
                              alignment: Alignment.bottomCenter,
                              child: Align(
                                  heightFactor: 0.9,
                                  alignment: Alignment.topCenter,
                                  child: itemsData[index]),
                            ),
                          )
                        ],
                      ): Opacity(
                        opacity: scale,
                        child: Transform(
                          transform:  Matrix4.identity()..scale(scale,scale),
                          alignment: Alignment.bottomCenter,
                          child: Align(
                              heightFactor: 0.9,
                              alignment: Alignment.topCenter,
                              child: itemsData[index]),
                        ),
                      );
                    })),
          ],
        ),
      ),
    );
  }
}

class CategoriesScroller extends StatelessWidget {
  const CategoriesScroller();

  @override
  Widget build(BuildContext context) {
    final double categoryHeight = MediaQuery.of(context).size.height * 0.30 - 50;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
          child: Row(
            children: <Widget>[
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(color: Colors.orange.shade400, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "رصيد جواهرك",
                        style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children:<Widget> [
                          Text(
                            "20",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Container(
                            height: 20,
                            child: Image.asset('assets/images/jawhara.png'),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(color: Colors.blue.shade400, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "وقت بدأ اللعبة",
                          style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "20 متبقي ساعه",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(color: Colors.lightBlueAccent.shade400, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Super\nSaving",
                        style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "20 Items",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class checkpoiint extends StatefulWidget {
  String id;
  checkpoiint(@required this.id);
  @override
  _checkpoiintState createState() => _checkpoiintState(id);
}

class _checkpoiintState extends State<checkpoiint> {
  bool _isloading=false;
  String id;
  TextEditingController ref_id=new TextEditingController();
  _checkpoiintState(@required this.id);
bool voit=false;
  @override
  Widget build(BuildContext context) {
    return Container(
    color: Colors.white70,
      child: voit==false?Center(child:
      _isloading==true?CircularProgressIndicator():Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
            color: Colors.indigoAccent,
            child: Text('فحص تراخيصك للعب',style: TextStyle(color: Colors.white),),
            onPressed: ()async{
              setState(() {
                _isloading=true;
              });
              var timenow=await NTP.now();
              DateTime _ntp=DateTime.parse("${timenow}");
              print('ghdfsdsf${id}');
              var mar = {
                'user_id': id,
              };
              String ur = '${RoyalBoardConfig
                  .RoyalBoardAppUrl}rest/users/check_firm/api_key/${RoyalBoardConfig
                  .RoyalBoardServerLanucher}';


              var response= await http.post(ur,body: mar);
              var message=jsonDecode(response.body)['message'];
              print('dfsghsghsdg${message}');
              if(int.parse('${  message['msg']}')==1){
                // getPostsData(message['data']);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Firm_prices(id,product: message['data'],
                  )),
                );
              }
              else if(int.parse('${  message['msg']}')==2){
                print('sdfgdsgfagag${message['data']}');
                DateTime firm_time =DateTime.parse('${message['data']['firm_time']}');

                DateTime checken_time =_ntp.subtract(Duration(hours: 24));
                print('dfjhdfghdf${checken_time}');
                if(checken_time.isBefore(firm_time)){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UnderPlayingFirm(message['data']['user_id'],message['data']['Firm_product'])),
                  );
                }
                else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Firm_prices(id,product: message['product_data'],
                    )),
                  );
                }

              }

              setState(() {
                _isloading=false;
              });
            },
          ),
          RaisedButton(
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              child: Text('تصويت الى صديق'),
              onPressed: ()async{
                setState(() {
                  _isloading=true;
                });
                setState(() {
                  voit=true;
                });
               //  var mar =
               //  {
               //    'user_id': id,
               //  };
               //  String ur = '${RoyalBoardConfig
               //      .RoyalBoardAppUrl}rest/users/voit_firm/api_key/${RoyalBoardConfig
               //      .RoyalBoardServerLanucher}';
               //  var response= await http.post(ur,body: mar);
               //  var message=jsonDecode(response.body)['message'];
               //  print('sdgaga${message}');
               // if(message=='Time_null'){
               //
               //   setState(() {
               //     voit=true;
               //   });
               //
               // }
               // else{
               //   DateTime fromserver=DateTime.parse('${message}');
               //   if(difference.isAfter(fromserver)){
               //     setState(() {
               //       voit=true;
               //     });
               //   }
               //   else{
               //
               //     Fluttertoast.showToast(
               //         msg: 'لا تمتلك الحق في التصويت يجب ان تنتظر اكمال يوم كامل',
               //         toastLength: Toast.LENGTH_SHORT,
               //         gravity: ToastGravity.BOTTOM,
               //         backgroundColor: Colors.red,
               //         textColor: Colors.white
               //
               //     );
               //   }
               //
               // }



                setState(() {
                  _isloading=false;
                });
              }),
    RaisedButton(
    shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),

    child: Text('رجوع'),
    onPressed:(){Navigator.pop(context);}
    )
        ],
      )
      ):
      Scaffold(
        body: Container(
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage('assets/images/firm_background.jpg'),
          //         fit: BoxFit.cover
          //     )
          //
          // ),
          child: _isloading==true?Center(child: CircularProgressIndicator()):Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: ref_id,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15.0),

                      ),

                    ),
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.black),
                    hintText: "اكتب هنا معرف صديقك ",
                    fillColor: Colors.white),
              ),
            ),
            RaisedButton(
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                child: Text('تصويت الآن ',style: TextStyle(color: Colors.white),),
                color: Colors.blue,
                onPressed: ()async{
                  setState(() {
                    _isloading=true;
                  });
                  var timenow=await NTP.now();
                  DateTime _ntp=DateTime.parse("${timenow}");
                  var mar = {
                    'user_id': id,
                    'ref_id':ref_id.text,
                    'Firm_voit_time':'${_ntp}',
                    'before_day':'${_ntp.subtract(Duration(days: 1))}'
                  };
                  String ur = '${RoyalBoardConfig
                      .RoyalBoardAppUrl}rest/users/voit_firm_now/api_key/${RoyalBoardConfig
                      .RoyalBoardServerLanucher}';
                  var response= await http.post(ur,body: mar);
                  var message=jsonDecode(response.body)['message'];
                print('dfhgdghgasfasdfhgdf${message}');
                if(message=='no_user'){
                  Fluttertoast.showToast(
                      msg: 'لايوجد هكذا معرف',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white

                  );
                }
                else if (message=='you_are_same_user'){
                  Fluttertoast.showToast(
                      msg: 'لايجوز التصويت الى حسابك نفسه',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white

                  );
                }
                else if (message=='cannot_same_ft'){
                  Fluttertoast.showToast(
                      msg: 'لايجوز التصويت الى نفس الحساب خلال نفس اليوم',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white

                  );
                }
                else if (message=='he_dont_play'){
                  Fluttertoast.showToast(
                      msg: 'هذا الحساب لم يلعب اليوم',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white

                  );
                }
                else if (message=='data_savd_tenly'){
                  Fluttertoast.showToast(
                      msg: 'تم التصويت بنجاح شكراً لك',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.green,
                      textColor: Colors.white

                  );
                  setState(() {
                    voit=false;

                  });
                }
                else if (message=='data_savd_not_tenly'){
                  Fluttertoast.showToast(
                      msg: 'تم التصويت بنجاح شكراً لك',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.green,
                      textColor: Colors.white

                  );
                  setState(() {
                    voit=false;
                  });
                }


                  setState(() {
                    _isloading=false;
                  });
                })
          ],
      ),
        ),),
    );
  }
}

