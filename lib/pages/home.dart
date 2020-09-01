import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar_week/calendar_week.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'breakfast.dart' as first;
import 'lunch.dart' as second;
import 'dinner.dart' as third;

import 'menuObject.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  //SingleTickerProvideStateMixin is navigating with animation
  //can't create tabbar controller without it

  //url to api
  String url = "https://glicious.herokuapp.com/api/v1/menus/all";

  static int date = new DateTime.now().day;
  static int pressedDate = new DateTime.now().day;

  //timer date
  static int timerday = new DateTime.now().day;
  static int timerHour = new DateTime.now().hour;
  static int timerMinute = new DateTime.now().minute;

  //storing today's date
  DateTime _selectedDate;

  static String breakfastHour;
  static String lunchHour;
  static String dinnerHour;

  static List<double> breakfastHour1;
  static List<double> lunchHour1;
  static List<double> dinnerHour1;

  //tabController where I will store the controllers for TabBar and TabBarView
  TabController controller;

  //list where I will store the menus for breakfast, lunch, and dinner
  static List<String> dataBreakfast = List<String>();
  static List<String> dataLunch = List<String>();
  static List<String> dataDinner = List<String>();

  //storing the created object from json data
  List dateTime;

  //dates that we have info
  var knowndates = Set().cast<int>();

  var colorChange;

  @override
  void initState() {
    super.initState();
    //setting today's date
    _selectedDate = DateTime.now();
    pressedDate = new DateTime.now().day;
    //to find the hour to switch the tabs for breakfast, lunch, and dinner
    var time = _selectedDate.hour;
    //breakfast from 8pm ~ 10am
    //lunch from 10 am~ 1:30pm
    //dinner from 1:30 ~ 8pm
    var indexInitial = 0;
    if (time > 20 && time < 24 || time >= 0 && time < 10) {
      indexInitial = 0;
    } else if (time >= 10 && time <= 13) {
      indexInitial = 1;
    } else {
      indexInitial = 2;
    }
    updateTime();
    //get the json data from the webservice and get today's breakfast, lunch, and dinner
    // menu before content is displayed
    this.getJsonData();
    //create three tab controller
    //Needs to have vsync :this  for animation to work correctly
    controller =
        TabController(vsync: this, length: 3, initialIndex: indexInitial);
  }
  //updating count for open close feature
  void updateTime() {
    Future.delayed(Duration(seconds: 1), () {
      updateTime();
      setState(() {
        timerday = new DateTime.now().day;
        timerHour = new DateTime.now().hour;
        timerMinute = new DateTime.now().minute;
      });
    });
  }
  //get the json data from the webservice and get today's breakfast, lunch, and dinner
  // menu before content is displayed

  Future<String> getJsonData() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    //convertsDataToJson
    var convertJsontoData = jsonDecode(response.body);
    dateTime = convertJsontoData.map((i) => DateTimer.fromJson(i)).toList();

    setState(() {
    for (var i = 0; i < dateTime.length; i++) {
      var num = dateTime[i].date;
      if (num == _selectedDate.day) {
        var jsonTypeFoodList = dateTime[i].obj1;
        for (var j = 0; j < jsonTypeFoodList.length; j++) {
          if (jsonTypeFoodList[j].type == "BREAKFAST") {
            dataBreakfast = jsonTypeFoodList[j].menus;
            breakfastHour = jsonTypeFoodList[j].time;
            breakfastHour1 = jsonTypeFoodList[j].timeList;
          }
          else if (jsonTypeFoodList[j].type == "LUNCH") {
            dataLunch = jsonTypeFoodList[j].menus;
            lunchHour = jsonTypeFoodList[j].time;
            lunchHour1 = jsonTypeFoodList[j].timeList;
          }
          else if (jsonTypeFoodList[j].type == "DINNER") {
            dataDinner = jsonTypeFoodList[j].menus;
            dinnerHour = jsonTypeFoodList[j].time;
            dinnerHour1 = jsonTypeFoodList[j].timeList;
          }
        }
      }
    }
    return "Success";
    });
  }

  @override
  void dispose() {
    //when app is closed controller, jsonObject are also removed.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          elevation: 0.1,
          backgroundColor: Color(0xFFBC90016),
          //Title of the App with Glicious logo
          title: Image.asset('assets/gliciouslogo.png',
              fit: BoxFit.cover, height: 38)),
      body: Theme(
          data: ThemeData(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: 8.0, top: 13.0, right: 8.0, bottom: 2.0),
                height: 80,
                color: Colors.white54,
                child: CalendarWeek(
                  height: 80,
                  minDate: DateTime.now().add(
                    Duration(days: 0),
                  ),
                  maxDate: DateTime.now().add(
                    Duration(days: 6),
                  ),
                  onDateLongPressed: (DateTime datetime) {
                    setState(() {
                      pressedDate = datetime.day;
                      if (DateTime.now().day == datetime.day) {
                        colorChange = Colors.black87;
                      } else {
                        colorChange = Colors.grey;
                      }
                      _selectedDate = datetime;
                      for (var i = 0; i < dateTime.length; i++) {
                        knowndates.add(dateTime[i].date);
                      }
                      //if there is no data for that day return None
                      if (!(knowndates.contains(_selectedDate.day))) {
                        dataBreakfast = [];
                        dataLunch = [];
                        dataDinner = [];
                      }
                      //compare the today's day with the json day if it matches then store the breakfast and lunch and dinner menu in a list.
                      for (var i = 0; i < dateTime.length; i++) {
                        var num = dateTime[i].date;
                        if (num == _selectedDate.day) {
                          var jsonTypeFoodList = dateTime[i].obj1;
                          for (var j = 0; j < jsonTypeFoodList.length; j++) {
                            if (jsonTypeFoodList[j].type == "BREAKFAST") {
                              dataBreakfast = jsonTypeFoodList[j].menus;
                              breakfastHour = jsonTypeFoodList[j].time;
                            }
                            if (jsonTypeFoodList[j].type == "LUNCH") {
                              dataLunch = jsonTypeFoodList[j].menus;
                              lunchHour = jsonTypeFoodList[j].time;
                            }
                            if (jsonTypeFoodList[j].type == "DINNER") {
                              dataDinner = jsonTypeFoodList[j].menus;
                              dinnerHour = jsonTypeFoodList[j].time;
                            }
                          }
                        }
                      }
                    });
                  },
                  //date pressed selectedDate is changed and updated in the screen
                  onDatePressed: (DateTime datetime) {
                    setState(() {
                      pressedDate = datetime.day;
                      if (DateTime.now().day == datetime.day) {
                        colorChange = Colors.black87;
                      } else {
                        colorChange = Colors.grey;
                      }
                      _selectedDate = datetime;
                      for (var i = 0; i < dateTime.length; i++) {
                        knowndates.add(dateTime[i].date);
                      }
                      //if data is not available set the menu empty
                      if (!(knowndates.contains(_selectedDate.day))) {
                        dataBreakfast = [];
                        dataLunch = [];
                        dataDinner = [];
                      }
                      //compare the today's day with the json day if it matches then store the breakfast and lunch and dinner menu in a list.
                      for (var i = 0; i < dateTime.length; i++) {
                        var num = dateTime[i].date;
                        if (num == _selectedDate.day) {
                          var jsonTypeFoodList = dateTime[i].obj1;
                          for (var j = 0; j < jsonTypeFoodList.length; j++) {
                            if (jsonTypeFoodList[j].type == "BREAKFAST") {
                              dataBreakfast = jsonTypeFoodList[j].menus;
                              breakfastHour = jsonTypeFoodList[j].time;
                            }
                            if (jsonTypeFoodList[j].type == "LUNCH") {
                              dataLunch = jsonTypeFoodList[j].menus;
                              lunchHour = jsonTypeFoodList[j].time;
                            }
                            if (jsonTypeFoodList[j].type == "DINNER") {
                              dataDinner = jsonTypeFoodList[j].menus;
                              dinnerHour = jsonTypeFoodList[j].time;
                            }
                          }
                        }
                      }
                    });
                  },
                  //MON, TUES, WEDS, THURS, FRI color and font
                  dayOfWeekStyle: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Product Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                  dayOfWeekAlignment: FractionalOffset.bottomCenter,
                  //6,7,8,9,  etc date color and font
                  dateStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Product Sans',
                      fontWeight: FontWeight.w600,
                      fontSize: 30),
                  dateAlignment: FractionalOffset.topCenter,
                  //today's date color, font and effects
                  todayDateStyle: TextStyle(
                      color: colorChange,
                      fontWeight: FontWeight.w600,
                      fontSize: 30),
                  todayBackgroundColor: Colors.transparent,
                  pressedDateBackgroundColor: Colors.transparent,
                  //other date's preseed color, font, and effects
                  pressedDateStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 30),
                  dateBackgroundColor: Colors.white54,
                  backgroundColor: Colors.white54,
                  dayOfWeek: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                  spaceBetweenLabelAndDate: 0,
                  dayShapeBorder: CircleBorder(),
                ),
              ),
              // navigation bar for breakfast, lunch, and dinner represented with sun, moon icon
              Container(
                alignment: Alignment.center,
                width: double.infinity,
              padding: EdgeInsets.only(
                      left: 6.0, top: 0.0, right: 6.0, bottom: 0.0),
                  height: 40,
                  color: Colors.white54,
                  child:
                        TabBar(
                    isScrollable: false,
                    indicatorColor: Colors.white54,
                    controller: controller,
                          tabs: [
                      Tab(icon: Text("BREAKFAST")),
                      Tab(icon: Text("LUNCH")),
                      Tab(icon: Text("DINNER")),
                    ],
                    labelStyle: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Product Sans',
                        fontWeight: FontWeight.w400),
                    labelColor: Color(0xFFBC90016),
                    unselectedLabelColor: Colors.grey,
                  )),
              Expanded(
                  child: TabBarView(
                controller: controller,
                children: <Widget>[
                  new first.Breakfast(),
                  new second.Lunch(),
                  new third.Dinner(),
                ],
              )),
            ],
          )),
    );
  }
}
