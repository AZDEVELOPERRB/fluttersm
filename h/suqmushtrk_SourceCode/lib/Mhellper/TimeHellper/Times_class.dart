import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePickerWidget extends StatefulWidget {

  String a;
  String Time_Type;
  String amtype;



  TimePickerWidget(this.Time_Type,{this.amtype,this.a});

  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();

}

class _TimePickerWidgetState extends State<TimePickerWidget> {

  TimeOfDay time;
  String s;
  String s_server;
  String am;


  String getText() {
    if (time == null) {
      return 'Select Time';
    } else {
      final hours = time.hour.toString().padLeft(2, '0');
      final minutes = time.minute.toString().padLeft(2, '0');
      setState(() {
        s='${time.hour}:${time.minute}';
      });

      return '${time.hour}:${time.minute}';
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      RaisedButton(
        shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)


        ) ,
        color: s==null?Colors.teal:Colors.lightGreen,

        child:s!=null?Container(
          width: 80,

          child: Row(

            children: [
              Text('${am}',style: TextStyle(color: Colors.white),),
              SizedBox(width: 10,),
              Text('${s}',style: TextStyle(color: Colors.white),),



            ],
          ),
        ): Text('${widget.Time_Type}',style: TextStyle(color: Colors.white),),
        onPressed: ()=>pickTime(context),
      ),
      widget.amtype!=null?    Text('الوقت المحدد'):Container(),
     widget.amtype!=null? RaisedButton(
        shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25)


        ) ,
        color:Colors.teal,

        child:Container(
          width: 50,

          child: Row(

            children: [
              Text('${widget.a}',style: TextStyle(color: Colors.white),)




            ],
          ),
        ),
        onPressed: (){


        },
      ):Container(),
    ],
  );

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: time ?? initialTime,
    );

    if (newTime == null) return;
int hours_int=int.parse(newTime.hour.toString());
String da=hours_int<12?"AM":"PM";


    setState(() {
      s = "${newTime.minute} : ${hours_int<12?newTime.hour:hours_int-12==0?12:hours_int-12}";
      s_server= "  ${hours_int<12?newTime.hour:hours_int-12} : ${newTime.minute}";

      am=da;
      widget.a="${hours_int<12?newTime.hour:hours_int-12}${da}";
    }
      );
  }


}

