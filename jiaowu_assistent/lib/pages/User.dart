import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:jiaowuassistent/GlobalUser.dart';

//import 'package:path_provider/path_provider.dart';

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

Future<EmptyRoom> getEmptyRoom(BuildContext context, String campus, String date,
    String section, String building) async {
  try {
    Response response = await Dio().get(
        'http://114.115.208.32:8000/classroom/?campus=$campus &date=$date &section=$section',
        options: Options(
            responseType: ResponseType
                .plain)); // http://www.mocky.io/v2/5e9a690133000021bf7b3008
    print(
        'Request(http://114.115.208.32:8000/classroom/?campus=$campus &date=$date &section=$section)');
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
      List<String> list =
          listJson.map((value) => value['classroom'].toString()).toList();
      return EmptyRoom(building, list, response.data);
    }
  } on DioError catch (e) {
    print(formatError(e));
    showDialog(
        // 设置点击 dialog 外部不取消 dialog，默认能够取消
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                '错误提示',
                textAlign: TextAlign.center,
              ),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
              // 标题文字样式
              content: Text(formatError(e) + "  " + e.type.toString()),
              contentTextStyle: TextStyle(color: Colors.white, fontSize: 17),
              // 内容文字样式
              backgroundColor: CupertinoColors.systemGrey,
              elevation: 8.0,
              // 投影的阴影高度
              semanticLabel: 'Label',
              // 这个用于无障碍下弹出 dialog 的提示
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              // dialog 的操作按钮，actions 的个数尽量控制不要过多，否则会溢出 `Overflow`
              actions: <Widget>[
                // 点击增加显示的值
//            FlatButton(onPressed: increase, child: Text('点我增加')),
//            // 点击减少显示的值
//            FlatButton(onPressed: decrease, child: Text('点我减少')),
//            // 点击关闭 dialog，需要通过 Navigator 进行操作
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      '知道了',
                      style: TextStyle(color: CupertinoColors.white),
                    )),
              ],
            ));
    return null;
  }
}

String formatError(DioError e) {
  if (e.type == DioErrorType.CONNECT_TIMEOUT) {
    // It occurs when url is opened timeout.
    return ("连接超时");
  } else if (e.type == DioErrorType.SEND_TIMEOUT) {
    // It occurs when url is sent timeout.
    return ("请求超时");
  } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
    //It occurs when receiving timeout
    return ("响应超时");
  } else if (e.type == DioErrorType.RESPONSE) {
    // When the server response, but with a incorrect status, such as 404, 503...
    return ("出现异常");
  } else if (e.type == DioErrorType.CANCEL) {
    // When the request is cancelled, dio will throw a error with this type.
    return ("请求取消");
  } else {
    //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
    return ("未知错误");
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

  factory CourseCenter.fromJson(List<dynamic> parsedJson) {
    List<Course> courseCenterList =
        parsedJson.map((i) => Course.fromJson(i)).toList();
    return CourseCenter(courses: courseCenterList);
  }

//  factory CourseCenter.fromJson(List<dynamic> parsedJson) {
//    List<Course> courseCenterList =
//        parsedJson.map((i) => Course.fromJson(i)).toList();
//    return CourseCenter(courses: courseCenterList);
//  }
}

Future<CourseCenter> getCourseCenter(String studentID) async {
//  String response =
//      await rootBundle.loadString('assets/data/courseCenter.json');
//  return CourseCenter.fromJson(json.decode(response));

  final response =
      await http.get('http://114.115.208.32:8000/ddl/?student_id=$studentID');
  print('http://114.115.208.32:8000/ddl/?student_id=$studentID');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Utf8Decoder decode = new Utf8Decoder();
    return CourseCenter.fromJson(
        json.decode(decode.convert(response.bodyBytes)));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load course center');
  }
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
  final String gpa;
  final String averageScore;

  GradeCenter({this.grades, this.gpa, this.averageScore});

  factory GradeCenter.fromJson(
    List<dynamic> parsedJson,
    Map<String, dynamic> avg,
    Map<String, dynamic> gpa,
  ) {
    List<Grade> gradeList = parsedJson.map((i) => Grade.fromJson(i)).toList();
    return GradeCenter(
        grades: gradeList,
        gpa: gpa['gpa'].toStringAsFixed(4),
        averageScore: avg['score'].toStringAsFixed(2));
  }
}

Future<GradeCenter> getGrade(String studentID, String semester) async {
//  String response = await rootBundle.loadString('assets/data/grade.json');
//  GradeCenter temp = GradeCenter.fromJson(json.decode(response));
//  return temp;

  final response = await http.get(
      'http://114.115.208.32:8000/score/?student_id=$studentID&semester=$semester');
  print(
      'http://114.115.208.32:8000/score/?student_id=$studentID&semester=$semester');
  final averageScore = await http
      .get('http://114.115.208.32:8000/score/avg_score/?student_id=$studentID');
  print('http://114.115.208.32:8000/score/avg_score/?student_id=$studentID');
  final gpa = await http
      .get('http://114.115.208.32:8000/score/gpa/?student_id=$studentID');
  print('http://114.115.208.32:8000/score/gpa/?student_id=$studentID');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Utf8Decoder decode = new Utf8Decoder();
    return GradeCenter.fromJson(
        json.decode(decode.convert(response.bodyBytes)),
        json.decode(decode.convert(averageScore.bodyBytes)),
        json.decode(decode.convert(gpa.bodyBytes)));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load course center');
  }
}

//课表用
class TeacherCourse {
  String name;

  TeacherCourse({this.name});

  TeacherCourse.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return name;
  }
}

class CourseT {
  String name;
  String location;
  List<TeacherCourse> teacherCourse;
  List<String> week;
  int weekDay;
  int sectionStart;
  int sectionEnd;

  CourseT({
    this.name,
    this.location,
    this.teacherCourse,
    this.week,
    this.weekDay,
    this.sectionStart,
    this.sectionEnd,
  });

  CourseT.fromJson(Map<String, dynamic> json) {
    try{
      name = json['name'];
      if (json['teacher_course'] != null) {
        teacherCourse = new List<TeacherCourse>();
        json['teacher_course'].forEach((v) {
          teacherCourse.add(new TeacherCourse.fromJson(v));
        });
      } else {
        teacherCourse = new List<TeacherCourse>();
        teacherCourse.add(TeacherCourse(name: "未知"));
      }
      String weeks = json['week'] as String;
      List<String> weekss = weeks.split(',');
      String times = json['time'] as String;
      List<String> timess = times.split('_');
      if (json['place'] == null) {
        location = '未知';
      } else {
        location = json['place'];
      }
      week = weekss;
      weekDay = int.parse(timess[0]);
      sectionStart = int.parse(timess[1]);
      sectionEnd = int.parse(timess[2]);
    }catch(e){
      throw "解析课程出错";
    }

  }
}

class WeekCourseTable {
  List<CourseT> courses;

  WeekCourseTable(List<CourseT> courses) {
    this.courses = courses;
  }

  WeekCourseTable.fromJson(List<dynamic> jsonList) {
    try{
      courses = jsonList.map((i) => CourseT.fromJson(i)).toList();
      //throw "error";
    }catch(e){
      throw "解析课程列表出错";
    }

  }
}

Future<WeekCourseTable> loadCourse(int week, String studentID) async {
  /*
  Directory dir = await getApplicationDocumentsDirectory();
  File file;
  if(file==null){
    file = new File('${dir.path}/courseTableAll.json');
  }else{
    file = File('${dir.path}/courseTableAll.json');
  }
  //更新策略：本次学号和上次不同或者间隔时间大于6天
  DateTime now = DateTime.now();
  // ignore: unrelated_type_equality_checks
  DateTime lastModified = file.lastModifiedSync();
  */
  CancelToken _can = new CancelToken();
  Timer(Duration(milliseconds: 5),(){_can.cancel("定时");});
  String ss;
  //暂定先直接用网络请求
  print('get course table from http');
  Dio dio = new Dio();
  Response response;
  response = await dio.request(
      'http://114.115.208.32:8000/timetable/?student_id=$studentID&week=all',
      options: Options(method: "GET", responseType: ResponseType.plain),);
      //cancelToken: _can);
  if (response.statusCode == 200) {
    ss = response.data;
    //file.writeAsStringSync(response.data.toString());
  } else {
    throw "网络错误";
  }
  try {
    //String ss = file.readAsStringSync();
    List<dynamic> jsonList = json.decode(ss);
    WeekCourseTable temp = new WeekCourseTable.fromJson(jsonList);
    return temp;
  } catch (e) {
    throw "文件读取错误";
  }
}

Future<int> getWeek() async {
  //获取当前周
  Dio dio = new Dio();
  Response response;
  DateTime now = DateTime.now();
  try {
    response = await dio.request(
        'http://114.115.208.32:8000/timetable/?date=${now.year}-${now.month}-${now.day}',
        options: Options(method: "GET", responseType: ResponseType.json));
  } catch (e) {
    e.toString();
    print('response:' + response.toString());
    return 9;
  }
  print(response.data.toString());
  int weekNumber = int.parse(response.data[0]['week']);
  return weekNumber;
}
