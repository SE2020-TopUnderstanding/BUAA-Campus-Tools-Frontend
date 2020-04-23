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
  String _response;

  EmptyRoom(String building, List<String> rooms, String response) {
    this._building = building;
    this._rooms = rooms;
    this._response = response;
  }

  String getResPonse() {
    return _response;
  }

  String getBuilding() {
    return _building;
  }

  List<String> getRooms() {
    return _rooms;
  }
}

Future<EmptyRoom> getEmptyRoom(String campus, String date, String section,
    String building) async {
  try {
    Response response = await Dio().get(
        'http://114.115.208.32:8000/classroom/?campus=$campus&date=$date&section=$section',
        options: Options(
            responseType: ResponseType
                .plain)); // http://www.mocky.io/v2/5e9a690133000021bf7b3008
    print(
        'Request(http://114.115.208.32:8000/classroom/?campus=$campus&date=$date&section=$section)');
    Map<String, dynamic> data = json.decode(response.data.toString());
    print(response);
    if (data == null) {
      throw FormatException('No Data Response!');
    } else if (!data.containsKey(building)) {
      print("building: $building");
      print("The certain building has no empty room!");
      return EmptyRoom(building, null, response.data.toString());
//      throw FormatException('The certain building has no empty room!');
    } else {
      List<dynamic> listJson = data['$building'];
      List<String> list = listJson.map((value) => value['classroom'].toString()).toList();
      return EmptyRoom(building, list, response.data);
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
//    print(list.runtimeType);
    List<DDL> ddlList = list.map((i) => DDL.fromJson(i)).toList();

    return Course(name: parsedJson['name'], content: ddlList);
  }
}

class CourseCenter {
  final List<Course> courses;

  CourseCenter({this.courses});

  factory CourseCenter.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['ddl'] as List;
    List<Course> courseCenterList =
    list.map((i) => Course.fromJson(i)).toList();
    return CourseCenter(courses: courseCenterList);
  }

//  factory CourseCenter.fromJson(List<dynamic> parsedJson) {
//    List<Course> courseCenterList =
//        parsedJson.map((i) => Course.fromJson(i)).toList();
//    return CourseCenter(courses: courseCenterList);
//  }
}

Future<CourseCenter> getCourseCenter() async {
  String response =
  await rootBundle.loadString('assets/data/courseCenter.json');
  return CourseCenter.fromJson(json.decode(response));

//  final response =
//      await http.get('http://114.115.208.32:8000/ddl/?student_id=17373349');
//  if (response.statusCode == 200) {
//    // If the server did return a 200 OK response,
//    // then parse the JSON.
//    Utf8Decoder decode = new Utf8Decoder();
//    return CourseCenter.fromJson(
//        json.decode(decode.convert(response.bodyBytes)));
//  } else {
//    // If the server did not return a 200 OK response,
//    // then throw an exception.
//    throw Exception('Failed to load course center');
//  }
}

//成绩查询用
class Grade {
  final String name;
  final double credit;
  final int score;

  Grade({this.name, this.credit, this.score});

  factory Grade.fromJson(Map<String, dynamic> parsedJson) {
    return Grade(
        name: parsedJson['course_name'],
        credit: parsedJson['credit'],
        score: parsedJson['score']);
  }
}

class GradeCenter {
  final List<Grade> grades;

  GradeCenter({this.grades});

  factory GradeCenter.fromJson(List<dynamic> parsedJson) {
    List<Grade> gradeList = parsedJson.map((i) => Grade.fromJson(i)).toList();
    return GradeCenter(grades: gradeList);
  }
}

Future<GradeCenter> getGrade() async {
  String response = await rootBundle.loadString('assets/data/grade.json');
  GradeCenter temp = GradeCenter.fromJson(json.decode(response));
  return temp;

//  final response =
//      await http.get('http://114.115.208.32:8000/ddl/?student_id=17373349');
//  if (response.statusCode == 200) {
//    // If the server did return a 200 OK response,
//    // then parse the JSON.
//    Utf8Decoder decode = new Utf8Decoder();
//    return GradeCenter.fromJson(
//        json.decode(decode.convert(response.bodyBytes)));
//  } else {
//    // If the server did not return a 200 OK response,
//    // then throw an exception.
//    throw Exception('Failed to load course center');
//  }
}

//课表用
class CourseT {
   String name;
   String location;
   //Teachers teachers;
   List<String> week;
   int weekDay;
   int sectionStart;
   int sectionEnd;

  CourseT({
    this.name,
    this.location,
    //this.teachers,
    this.week,
    this.weekDay,
    this.sectionStart,
    this.sectionEnd,
  });

  static CourseT fromJson(Map<String, dynamic> parsedJson) {
    String weeks = parsedJson['week'] as String;
    List<String> weekss= weeks.split(',');
    //var list =json.decode((parsedJson['teacher_course'].toString()));
    //print(list.toString());
    return CourseT(
      name: parsedJson['name'],
      location: parsedJson['place'],
      //teachers: Teachers.fromJson(parsedJson['teacher_course'].toString()),
      week: weekss,
      weekDay: int.parse(parsedJson['time'].toString().substring(0,1)),
      sectionStart: int.parse(parsedJson['time'].toString().substring(2,3)),
      sectionEnd: int.parse(parsedJson['time'].toString().substring(4,5)),
    );
  }
}

class WeekCourseTable {
   List<CourseT> courses;
   WeekCourseTable({this.courses});
   static WeekCourseTable  fromJson(List<dynamic> jsonList) {
      List<CourseT> courseList =
      jsonList.map((i) => CourseT.fromJson(i)).toList();
      return WeekCourseTable(courses: courseList);
  }
}


Future<WeekCourseTable> loadCourse(int week, String studentID) async{
  String jsonString = await rootBundle.loadString('assets/data/courseTable1.json');
  List<dynamic> jsonList = json.decode(jsonString);
  WeekCourseTable temp = WeekCourseTable.fromJson(jsonList);

  //print(temp.toString());
  //print(jsonResult);
  /*
  Dio dio = new Dio();
  try{
    Response response;
    response = await dio.request('http://127.0.0.1:8000/timetable/',
        data:{"student_id":"17373182", "week":"8"},
        options: Options(method: "GET", responseType: ResponseType.json));
  }catch(e){
    e.toString();
  }
   */
  return temp;
}

Future<int> getWeek() async{
  Dio dio =  new Dio();
  Response response;
  DateTime now = DateTime.now();
  try{
    //response = await dio.request('http://114.115.208.32:8000/timetable/?student_id=17373182&week=all');
    //print('my table'+response.toString());
    response = await dio.request(
        'http://114.115.208.32:8000/timetable/?date=${now.year}-${now.month}-${now.day}',
    options: Options(method: "GET",responseType: ResponseType.json));
  }catch(e){
    e.toString();
    print('response:'+response.toString());
    return 9;
  }
  print(response.data.toString());
  int weekNumber = int.parse(response.data[0]['week']);
  return weekNumber;
}



