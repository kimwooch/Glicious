// This is my PODO class model to create the object from json file

/* I am able to get the { "time": "10", "obj1":[]}*/
class DateTimer{
  final int date;
  final List<Obj1>  obj1;

  DateTimer({
    this.date,
    this.obj1
});
  factory DateTimer.fromJson(Map<String, dynamic> parsedJson){
    var list = parsedJson['obj1'] as List;
    List<Obj1> typeFoodList = list.map((i) => Obj1.fromJson(i)).toList();
    return new DateTimer(
      date: parsedJson['date'] as int,
      obj1: typeFoodList
    );
  }
}

/* I am now able to fetch {"type" : breakfast, "time" : open at 7pm, "type" : "Lunch", "timeList" :[11.5, 13]*/
class Obj1{
  final String type;
  final String time;
  final List<String> menus;
  final List<double> timeList;

  Obj1({
    this.type,
    this.time,
    this.menus,
    this.timeList
  });

  factory Obj1.fromJson(Map<String, dynamic> parsedJson){
    List<double> timeL=  parsedJson['timeList'].cast<double>();

    List <String> lstring = <String>["1", "2"];
    List <int> lint = lstring.map(int.parse).toList();

    return new Obj1(
        type: parsedJson['type'] as String,
        time: parsedJson['time'] as String,
        menus: parsedJson["menus"].cast<String>(),
        timeList: timeL
    );
  }
}
