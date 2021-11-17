import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:ntp/ntp.dart';

class Furjt_List extends StatefulWidget {
  @override
  _Furjt_ListState createState() => _Furjt_ListState();
}
var nu=9647807832184;

class _Furjt_ListState extends State<Furjt_List> {
  int pagess=4;
  bool is_Data_ready=false;
  bool switcher =false;
   Future get_TheFurjt()async{
     var timenow=await NTP.now();
     var mar = {

       'now':'${timenow}',
       'pe':'${pagess}'
     };
     String ur = '${RoyalBoardConfig
         .RoyalBoardAppUrl}rest/users/get_furjt_for_application/api_key/${RoyalBoardConfig
         .RoyalBoardServerLanucher}';

     var response= await http.post(ur,body: mar);
     var message=jsonDecode(response.body)['message'];
     print('ghjtfgjhf${message}');
     return message;
  }
  Future get_TheFurjt_second_switcher()async{
    var timenow=await NTP.now();
    var mar = {

      'now':'${timenow}',
      'pe':'${pagess}'
    };
    String ur = '${RoyalBoardConfig
        .RoyalBoardAppUrl}rest/users/get_furjt_for_application/api_key/${RoyalBoardConfig
        .RoyalBoardServerLanucher}';

    var response= await http.post(ur,body: mar);
    var message=jsonDecode(response.body)['message'];
    print('ghjtfgjhf${message}');
    return message;
  }
  String image_url = '${RoyalBoardConfig
      .RoyalBoardImagesUrl}';
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        future:switcher==false?get_TheFurjt_second_switcher(): get_TheFurjt(),
    builder: (ctx,i){
          if(i.hasData){
 return
        ListView.builder(
          itemCount: i.data['data'].length,
          itemBuilder: (ctx,index){
            List images=[];

           for (String im in i.data['data'][index]['img']){
             images.add(
                 NetworkImage('${im}')
             );
           }

      if(index==0){
        return   Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
              child:  Column(
                children: [
                  RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                      child: Text('رجوع',style: TextStyle(color: Colors.white),),
                      color: Colors.red,
                      onPressed: (){
                        Navigator.pop(context);
                      }),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8)
                      ,
                      child: Text('الراحمون يرحمهم الله'
                          '\n'
                          ' ساعد بتبيض دفتر محتاج',style: TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.center,),

                    ),
                  ),
                ],
              ),
              ),
              Container(
                width: size.width,
                height: size.height/3,
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     image: AssetImage("assets/images/gg.jpg"),
                //     fit: BoxFit.cover,
                //   ),
                // ),
                child:  SizedBox(
                    height: 200.0,
                    width: 350.0,
                    child: Stack(
                      children: [
                        Carousel(
                          images: images,
                          dotSize: 4.0,
                          dotSpacing: 15.0,
                          showIndicator: true,
                          dotColor: Colors.white,
                          indicatorBgPadding: 5.0,
                          autoplay: false,
                          dotBgColor: Colors.purple.withOpacity(0.5),
                          borderRadius: true,

                        ),

                      ],
                    )
                ),
              ),


              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${i.data['data'][index]['name']}',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight:FontWeight.w900 ),),
                  ),

                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(' زين كاش او اسيا'),
                    SizedBox(width: 5,),
                    Text('${i.data['data'][index]['contact']}'),

                    SizedBox(width: 5,),
                    RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        child: Text('نسخ الرقم',style: TextStyle(color: Colors.white),),
                        color: Colors.blue,
                        onPressed: (){
                          FlutterClipboard.copy('${i.data['data'][index]['contact']}');
                          Fluttertoast.showToast(
                              msg: 'لقد قمت بنسخ الرقم بنجاح',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white
                          );

                        })
                  ],
                ),
              ),
              SizedBox(height: 20,),

              Column(
                mainAxisSize: MainAxisSize.max,


                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${i.data['data'][index]['des']}',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight:FontWeight.w600 ),textAlign: TextAlign.right,),
                  ),
                ],
              ),
              if(index!=i.data['data'].length-1)  Center(
                child: Column(
                  children: [
                    Icon(Icons.arrow_downward),
                  ],
                ),
              ),SizedBox(height: 15,),
              if(index==i.data['data'].length-1) if(i.data['data'].length!=i.data['counter']) Center(
                child: Column(
                  children: [
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)
                      ),
                      color: Colors.blue,
                      child:  Text('تحميل المزيد',style: TextStyle(color: Colors.white),),
                      onPressed: (){
                        setState(() {
                          pagess+=4;
                          if(switcher==false) {
                            switcher == true;
                          }
                          else{
                            switcher==false;
                          }
                        });
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }
      else{
        return   Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: size.width,
                height: size.height/3,
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     image: AssetImage("assets/images/gg.jpg"),
                //     fit: BoxFit.cover,
                //   ),
                // ),
                child:  SizedBox(
                    height: 200.0,
                    width: 350.0,
                    child: Carousel(
                      images: images,
                      dotSize: 4.0,
                      dotSpacing: 15.0,
                      showIndicator: true,
                      dotColor: Colors.white,
                      indicatorBgPadding: 5.0,
                      autoplay: false,
                      dotBgColor: Colors.purple.withOpacity(0.5),
                      borderRadius: true,

                    )
                ),
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${i.data['data'][index]['name']}',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight:FontWeight.w900 ),),
                  ),

                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(' زين كاش او اسيا'),
                    SizedBox(width: 5,),
                    Text('${i.data['data'][index]['contact']}'),

                    SizedBox(width: 5,),
                    RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        child: Text('نسخ الرقم',style: TextStyle(color: Colors.white),),
                        color: Colors.blue,
                        onPressed: (){
                          FlutterClipboard.copy('${i.data['data'][index]['contact']}');
                          Fluttertoast.showToast(
                              msg: 'لقد قمت بنسخ الرقم بنجاح',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white
                          );

                        })
                  ],
                ),
              ),
              SizedBox(height: 20,),

              Column(
                mainAxisSize: MainAxisSize.max,


                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${i.data['data'][index]['des']}',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight:FontWeight.w600 ),textAlign: TextAlign.right,),
                  ),
                ],
              ),
              if(index!=i.data['data'].length-1)  Center(
                child: Column(
                  children: [
                    Icon(Icons.arrow_downward),
                  ],
                ),
              ),SizedBox(height: 15,),
              if(index==i.data['data'].length-1) if(i.data['data'].length!=i.data['counter']) Center(
                child: Column(
                  children: [
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)
                      ),
                      color: Colors.blue,
                      child:  Text('تحميل المزيد',style: TextStyle(color: Colors.white),),
                      onPressed: (){
                        setState(() {
                          pagess+=4;
                          if(switcher==false) {
                            switcher == true;
                          }
                          else{
                            switcher==false;
                          }
                        });
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }
        );


    }
    else{
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator()
          ],
        ),
      ),
    );
    }


  }
      )
    );
  }
}
