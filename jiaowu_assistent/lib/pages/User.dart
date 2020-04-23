import 'dart:convert';
import 'package:flutter/cupertino.dart';
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

Future<EmptyRoom> getEmptyRoom(BuildContext context, String campus, String date, String section,
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
      print("No data response!");
      return null;
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
  }on DioError catch(e) {
    print(formatError(e));
    showDialog(
      // 设置点击 dialog 外部不取消 dialog，默认能够取消
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: Text('错误提示', textAlign: TextAlign.center,),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20), // 标题文字样式
          content: Text(formatError(e) + "  " + e.type.toString()),
          contentTextStyle: TextStyle(color: Colors.white, fontSize: 17), // 内容文字样式
          backgroundColor: CupertinoColors.systemGrey,
          elevation: 8.0, // 投影的阴影高度
          semanticLabel: 'Label', // 这个用于无障碍下弹出 dialog 的提示
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          // dialog 的操作按钮，actions 的个数尽量控制不要过多，否则会溢出 `Overflow`
          actions: <Widget>[
            // 点击增加显示的值
//            FlatButton(onPressed: increase, child: Text('点我增加')),
//            // 点击减少显示的值
//            FlatButton(onPressed: decrease, child: Text('点我减少')),
//            // 点击关闭 dialog，需要通过 Navigator 进行操作
            FlatButton(onPressed: () => Navigator.pop(context),
                child: Text('知道了', style: TextStyle(color: CupertinoColors.white),)),
          ],
        )
    );
    return null;
  }
}

String formatError(DioError e) {
  if (e.type == DioErrorType.CONNECT_TIMEOUT) {
    // It occurs when url is opened timeout.
    return("连接超时");
  } else if (e.type == DioErrorType.SEND_TIMEOUT) {
    // It occurs when url is sent timeout.
    return("请求超时");
  } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
    //It occurs when receiving timeout
    return("响应超时");
  } else if (e.type == DioErrorType.RESPONSE) {
    // When the server response, but with a incorrect status, such as 404, 503...
    return("出现异常");
  } else if (e.type == DioErrorType.CANCEL) {
    // When the request is cancelled, dio will throw a error with this type.
    return("请求取消");
  } else {
    //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
    return("未知错误");
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
    this.sectionEnd,
  });

  factory CourseT.fromJson(Map<String, dynamic> parsedJson) {
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

class WeekCourseTable {
  final List<CourseT> courses;

  WeekCourseTable({this.courses});

  factory WeekCourseTable.fromJson(List<dynamic> jsonList) {
    List<CourseT> courseList =
    jsonList.map((i) => CourseT.fromJson(i)).toList();
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



