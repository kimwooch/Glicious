import 'package:flutter/material.dart';
import 'home.dart';

class Breakfast extends StatelessWidget {
  var open;
  @override
  Widget build(BuildContext context) {
    var breakfastLength = HomePageState.dataBreakfast.length;
    var timetocompare = HomePageState.timerHour.toDouble() + (HomePageState.timerMinute.toDouble()/60);
    if (HomePageState.timerday == HomePageState.pressedDate && breakfastLength == 0) {
      /*if there is no menu return closed else the store is open*/
      open = Padding(
          padding: const EdgeInsets.only(
              bottom: 0, top: 5, left: 10, right: 15),
          child: RichText(
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Product Sans",
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.27,
                    color: Colors.black87,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Closed ',
                        style: new TextStyle(color: Color(0xFFBC90016))),
                  ])));
    } else if (HomePageState.timerday == HomePageState.pressedDate && breakfastLength != 0) {
      open = Padding(
          padding: const EdgeInsets.only(
              bottom: 0, top: 5, left: 10, right: 15),
          child: RichText(
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Product Sans",
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.27,
                    color: Colors.black87,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: (()
                    {if (timetocompare >= HomePageState.breakfastHour1[0] && timetocompare < HomePageState.breakfastHour1[1]){ return "Open ";} return "Closed ";})(),
                        style: (()
                        {if (timetocompare >= HomePageState.breakfastHour1[0] && timetocompare < HomePageState.breakfastHour1[1]){ return new TextStyle(color: Colors.green);} return new TextStyle(color: Color(0xFFBC90016));})())
                    ,
                    TextSpan(text: (()
                    {if (timetocompare >= HomePageState.breakfastHour1[0] && timetocompare < HomePageState.breakfastHour1[1]){ return "";} return "Open ";})()),
                    TextSpan(text: (()
                    {if (HomePageState.breakfastHour == null){ return "";}
                    return 'from ${HomePageState.breakfastHour}';})())
                  ])));
    }else if (HomePageState.timerday != HomePageState.pressedDate && breakfastLength != 0) {
      open = Padding(
          padding: const EdgeInsets.only(
              bottom: 0, top: 5, left: 10, right: 15),
          child: RichText(
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Product Sans",
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.27,
                    color: Colors.black87,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Open ',),
                    TextSpan(text: (()
                    {if (HomePageState.breakfastHour == null || HomePageState.breakfastHour == ""){ return "";}
                    return 'from ${HomePageState.breakfastHour}';})())
                  ])));
    }
    else if (HomePageState.timerday != HomePageState.pressedDate && breakfastLength == 0)  {
      open = Padding(
          padding: const EdgeInsets.only(
              bottom: 0, top: 5, left: 10, right: 15),
          child: RichText(
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Product Sans",
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.27,
                    color: Colors.black87,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: (()
                    {if (HomePageState.breakfastHour == "" || HomePageState.breakfastHour == null){ return "Closed";} return 'Open from ${HomePageState.breakfastHour}';})())
                  ])));
    }

    return Container(
        color: Colors.transparent,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount:
          HomePageState.dataBreakfast == null ? 0 : breakfastLength + 1,
          itemBuilder: (context, index) {
            //displays dinner with (open, close statement) and a line
            if (index == 0) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 0, top: 10, left: 10, right: 15),
                    child: Text(
                      "Breakfast",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 25,
                          letterSpacing: 0.27),
                    ),
                  ),
                  open,
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: 5, top: 5, left: 10, right: 15),
                      child: Divider(
                          color: Color(0xFFBC90016), thickness: 1.2)),
                ],
              );
            } else {
              //returns the menus
              index -= 1;
              return Container(
                color: Colors.transparent,
                child: ListTile(
                  contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                  title: Text(HomePageState.dataBreakfast[index],
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54),),
                  dense: true,),
              );
            }
          },
        ));
  }}