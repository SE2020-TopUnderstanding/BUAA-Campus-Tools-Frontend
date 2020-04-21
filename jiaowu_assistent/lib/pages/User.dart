import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class EmptyRoom {
  String _building;
  List<String> _rooms;

  EmptyRoom(String building, List<String> rooms) {
    this._building = building;
    this._rooms = rooms;
  }

  String getBuilding() {
    return _building;
  }

  List<String> getRooms() {
    return _rooms;
  }
}

class Room {
  String room;

  Room(String string) {
    room = string;
  }
}

Future<EmptyRoom> getEmptyRoom(
    String campus, String date, String section, String building) async {
  try {
    Response response = await Dio().get(
        'http://114.115.208.32:8000/classroom/?campus=$campus &date=$date &section=$section',
        options: Options(responseType: ResponseType.plain));    // http://www.mocky.io/v2/5e9a690133000021bf7b3008
    print('Request(http://114.115.208.32:8000/classroom/?campus=$campus &date=$date &section=$section)');
    Map<String, dynamic> data = json.decode(response.data.toString());
    print(response);
    if (data == null) {
      throw FormatException('No Data Response!');
    } else if (!data.containsKey(building)) {
      print("building: $building");
      throw FormatException('The certain building has no empty room!');
    } else {
      List<dynamic> listJson = data['$building'];
      List<String> list =
          listJson.map((value) => value['classroom'].toString()).toList();
      return EmptyRoom(building, list);
    }
  } catch (e) {
    print(e);
    return null;
  }
}

class DDL {
  final String time;
  final String text;
  final String status;

  DDL({this.time, this.text, this.status});

  factory DDL.fromJson(Map<String, dynamic> parsedJson) {
    return DDL(
        time: parsedJson['ddl'],
        text: parsedJson['homework'],
        status: parsedJson['state']);
  }
}
//课程中心用
class Course {
  final String name;
  final List<DDL> content;

  Course({this.name, this.content});

  factory Course.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['content'] as List;
    print(list.runtimeType);
    List<DDL> ddlList = list.map((i) => DDL.fromJson(i)).toList();

    return Course(name: parsedJson['name'], content: ddlList);
  }
}

class CourseCenter {
  final List<Course> courses;

  CourseCenter({this.courses});

  factory CourseCenter.fromJson(List<dynamic> parsedJson) {
    List<Course> courseCenterList =
        parsedJson.map((i) => Course.fromJson(i)).toList();
    return CourseCenter(courses: courseCenterList);
  }

  List<Course> getCourses() {
    return courses;
  }
}

Future<CourseCenter> loadCourseCenter() async {
  final response =
      await http.get('http://114.115.208.32:8000/ddl/?student_id=17373349');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Utf8Decoder decode = new Utf8Decoder();
//    return json.decode(decode.convert(response.bodyBytes));
    return CourseCenter.fromJson(
        json.decode(decode.convert(response.bodyBytes)));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load course center');
  }
}

//课表用
class CourseT {
  final String name;
  final String location;
  final String teacher;
  //final List<int> week;
  final int weekDay;
  final int sectionStart;
  final int sectionEnd;
  //String semester;

  CourseT({
    this.name,
    this.location,
    this.teacher,
    this.weekDay,
    this.sectionStart,
    this.sectionEnd,}
  );

  factory CourseT.fromJson(Map<String,dynamic> parsedJson){
     return CourseT(
       name: parsedJson['name'],
       location: parsedJson['location'],
       teacher: parsedJson['teacher'],
       //week: parsedJson['week'],
       weekDay: parsedJson['weekDay'],
       sectionStart: parsedJson['sectionStart'],
       sectionEnd: parsedJson['sectionEnd'],
    );
  }
}

class WeekCourseTable{
  final List<CourseT> courses;
  WeekCourseTable({this.courses});
  factory WeekCourseTable.fromJson(List<dynamic> jsonList){
    List<CourseT> courseList = jsonList.map((i) => CourseT.fromJson(i)).toList();
    return WeekCourseTable(courses: courseList);
  }
}

Future<WeekCourseTable> getCourse(int week) async{
  //print(week);
  //print("get week:$week");
  String jsonString = await rootBundle.loadString('assets/data/courseTable$week.json');
  //print(jsonString);
  List<dynamic> jsonList = json.decode(jsonString);
  WeekCourseTable temp = WeekCourseTable.fromJson(jsonList);

  //print(temp.toString());
  //print(jsonResult);
  /*
  Dio dio = new Dio();
  try{
    Response response;
    response = await dio.request('http://127.0.0.1:8000/timetable/',
        data:{"student_id":"17373182","semester":"2020_Spring", "week":"8"},
        options: Options(method: "GET", responseType: ResponseType.json));
  }catch(e){
    e.toString();
  }
   */
  return temp;
}

Future<int> getWeek() async{
  //print('there is get week number');
  /*
  Dio dio =  new Dio();

  Response response;
  try{
    response = await dio.request('http://127.0.0.1:8000/timetable/',
    data: {"date":"${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}"},
    options: Options(method: "GET",responseType: ResponseType.json));
  }catch(e){
    e.toString();
    throw "查找当前周号失败";
  }
  int weekNumber = response.data['week'];
   */
  int weekNumber =9;
  return weekNumber;
}




