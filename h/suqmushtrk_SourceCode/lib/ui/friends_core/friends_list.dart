import 'package:flutter/material.dart';
import 'package:RoyalBoard_Common_sooq/config/RoyalBoard_config.dart';
import 'package:RoyalBoard_Common_sooq/ui/dashboard/core/dashboard_view.dart';
import 'dart:convert';
import 'package:RoyalBoard_Common_sooq/ui/friends_core/friends_cartsb.dart';
import 'package:http/http.dart' as http;

class Friends_List extends StatefulWidget {
  String user_id;
  Friends_List(@required this.user_id);
  @override
  _Friends_ListState createState() => _Friends_ListState(user_id);
}

class _Friends_ListState extends State<Friends_List> {
  String user_id;
  int pagess=40;
  bool switcher=false;
  _Friends_ListState(@required this.user_id);
  get_friends_pagination()async{
    var mar = {
      'user_id':  user_id,
      'pe':'${pagess}'


    };
    String ur = '${RoyalBoardConfig
        .RoyalBoardAppUrl}rest/users/friends_pagination/api_key/${RoyalBoardConfig
        .RoyalBoardServerLanucher}';

    var response= await http.post(ur,body: mar);
    var message=jsonDecode(response.body)['message'];
    print('hgjfghdfhgf${ur}');
    return message;


  }
  get_more_friends_pagination()async{
    var mar = {
      'user_id':  user_id,
      'pe':'${pagess}'


    };
    String ur = '${RoyalBoardConfig
        .RoyalBoardAppUrl}rest/users/friends_pagination/api_key/${RoyalBoardConfig
        .RoyalBoardServerLanucher}';

    var response= await http.post(ur,body: mar);
    var message=jsonDecode(response.body)['message'];
    print('hgjfghdfhgf${ur}');
    return message;


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: InkWell(
            onTap:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardView()),
              );
            },
            child: Row(
              children: [

                Icon(Icons.arrow_forward_sharp,color: Colors.pink,),
              ],
            ),
          ),
        ),

      ),
      body: Container(
        child: Center(child:
          Stack(
            children: [
              FutureBuilder(
                future: switcher==true?get_friends_pagination():get_more_friends_pagination(),
                builder: (BuildContext ,i){
                  if(i.hasData){


                    return
                      Column(
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                              itemCount: i.data['data'].length+1,
                              itemBuilder: (BuildContext ,index){
                                return (index == i.data['data'].length ) ?
                            i.data['counte']!=i.data['data'].length?    Container(
                                  color: Colors.pinkAccent,
                                  child: FlatButton(
                                    child:Text(" ${i.data['counte']}ارني بعد ان وجد",style: TextStyle(color: Colors.white),),
                                    onPressed: () {

                                      setState(() {
                                        pagess+=20;
                                        if(switcher==true){
                                          switcher=false;
                                        }
                                        else{switcher=true;}
                                      });

                                    },
                                  ),
                                ):Container()
                                    :ListTile(
                                  leading: Icon(Icons.people),
                                  title: Text('${i.data['data'][index]['name']}'),
                                  trailing: RaisedButton(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                    color: Colors.indigoAccent,
                                    child: Text('ارني مشترياته',style: TextStyle(color: Colors.white),),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context)=>Friends_cartb(i.data['data'][index]['id'],user_id)
                                      ));


                                    },

                                  ),
                                );
                              },

                            ),
                          ),

                        ],
                      );
                  }
                  else
                    {
                      return CircularProgressIndicator();
                    }
                },
              ),
            ],
          )
          ,

        ),
      ),
    );
  }
}
