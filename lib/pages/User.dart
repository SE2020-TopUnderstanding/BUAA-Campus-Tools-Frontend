import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:jiaowuassistent/encrypt.dart';
import 'package:jiaowuassistent/GlobalUser.dart';

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

//课程中心用
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
  final response = await http.get(
      'http://114.115.208.32:8000/ddl/?student_id=${Encrypt.encrypt(studentID)}');
  print(
      'http://114.115.208.32:8000/ddl/?student_id=${Encrypt.encrypt(studentID)}');
//  throw 401;
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Utf8Decoder decode = new Utf8Decoder();
    CourseCenter temp =
        CourseCenter.fromJson(json.decode(decode.convert(response.bodyBytes)));

//    final JPush jpush = new JPush();
//    for (int i = 0; i < temp.courses.length; i++) {
//      for (int j = 0; j < temp.courses[i].content.length; j++) {
//        /*两小时前发本地推送*/
//        var fireDate = DateTime.fromMillisecondsSinceEpoch(
//            DateTime.parse(temp.courses[i].content[j].time)
//                    .millisecondsSinceEpoch -
//                7200000);
//        var localNotification = LocalNotification(
//          id: 234,
//          title: 'DDL提醒',
//          buildId: 1,
//          content:
//              '${temp.courses[i].content[j].text}，截止时间${temp.courses[i].content[j].time}',
//          fireTime: fireDate,
//        );
//        jpush.sendLocalNotification(localNotification);
//      }
//    }

    return temp;
    //json.decode('[]'));//测试空list
  } else {
    throw response.statusCode;
    // If the server did not return a 200 OK response,
    // then throw an exception.
//    throw Exception('Failed to load grade center');
  }
}

//成绩查询用
class Grade {
  final String name;
  final double credit;
  final String score;

  Grade({this.name, this.credit, this.score});

  factory Grade.fromJson(Map<String, dynamic> parsedJson) {
    return Grade(
        name: parsedJson['course_name'],
        credit: parsedJson['credit'],
        score: parsedJson['origin_score']);
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
      'http://114.115.208.32:8000/score/?student_id=${Encrypt.encrypt(studentID)}&semester=$semester');
  print(
      'http://114.115.208.32:8000/score/?student_id=${Encrypt.encrypt(studentID)}&semester=$semester');
  final averageScore = await http.get(
      'http://114.115.208.32:8000/score/avg_score/?student_id=${Encrypt.encrypt(studentID)}');
  print(
      'http://114.115.208.32:8000/score/avg_score/?student_id=${Encrypt.encrypt(studentID)}');
  final gpa = await http.get(
      'http://114.115.208.32:8000/score/gpa/?student_id=${Encrypt.encrypt(studentID)}');
  print(
      'http://114.115.208.32:8000/score/gpa/?student_id=${Encrypt.encrypt(studentID)}');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Utf8Decoder decode = new Utf8Decoder();
    return GradeCenter.fromJson(
        json.decode(decode.convert(response.bodyBytes)),
        json.decode(decode.convert(averageScore.bodyBytes)),
        json.decode(decode.convert(gpa.bodyBytes)));
  } else {
    throw response.statusCode;
    // If the server did not return a 200 OK response,
    // then throw an exception.
//    throw Exception('Failed to load course center');
  }
}

//更新用
class UpdateInfo {
  final String version;
  final String date;
  final String info;
  final String address;

  UpdateInfo({this.version, this.date, this.info, this.address});

  factory UpdateInfo.fromJson(Map<String, dynamic> parsedJson) {
    return UpdateInfo(
        version: parsedJson['version_number'],
        date: parsedJson['update_date'],
        info: parsedJson['announcement'],
        address: parsedJson['download_address']);
  }
}

Future<UpdateInfo> getUpdateInfo() async {
  final response = await http.get('http://114.115.208.32:8000/version');
  print('http://114.115.208.32:8000/version');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Utf8Decoder decode = new Utf8Decoder();
    return UpdateInfo.fromJson(json.decode(decode.convert(response.bodyBytes)));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load update info');
  }
}

Future<void> postMessage(String kind, String content) async {
  final response =
      await http.post('http://114.115.208.32:8000/feedback/', body: {
    "student_id": "${Encrypt.encrypt2(GlobalUser.studentID)}",
    "kind": "$kind",
    "content": "$content"
  });
  print('post -> http://114.115.208.32:8000/feedback/');
  print('student_id: ${Encrypt.encrypt2(GlobalUser.studentID)}');
  print('kind: $kind');
  print('content: $content');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('post success');
    return;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print(response.statusCode);
    throw Exception('Failed to post message');
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
  int color = 1;
  String bid;

  CourseT({
    this.name,
    this.location,
    this.teacherCourse,
    this.week,
    this.weekDay,
    this.sectionStart,
    this.sectionEnd,
    this.bid,
  });

  CourseT.fromJson(Map<String, dynamic> json) {
    try {
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
      bid = json['bid'];
    } catch (e) {
      throw "解析课程出错";
    }
  }

  @override
  int get hashCode {
    return name.hashCode;
  }

  @override
  bool operator ==(other) {
    if (other is! CourseT) {
      return false;
    }
    final CourseT temp = other;
    return (name.compareTo(temp.name) == 0) ? true : false;
  }

  void setColor(int color) {
    this.color = color;
  }
}

class WeekCourseTable {
  List<CourseT> courses;

  WeekCourseTable(List<CourseT> courses) {
    this.courses = courses;
  }

  WeekCourseTable.fromJson(List<dynamic> jsonList) {
    try {
      courses = jsonList.map((i) => CourseT.fromJson(i)).toList();
//      print("before map");
      Map<String, List<CourseT>> map = new Map.fromIterable(courses,
          key: (key) => key.name,
          value: (value) {
            return courses.where((item) {
              return (value.name.compareTo(item.name) == 0) ? true : false;
            }).toList();
          });
      int i = 1;
      map.forEach((k, v) {
        v.forEach((value) => value.setColor(i));
        i++;
      });
//      print("after map");
      //throw "error";
    } catch (e) {
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
  // print('course: ${Encrypt.encrypt(studentID)}');
  CancelToken _can = new CancelToken();
  Timer(Duration(milliseconds: 10), () {
    _can.cancel("定时");
  }); //测试错误
  String ss;
  //暂定先直接用网络请求
  Dio dio = new Dio();
  Response response;
  print(
      'http://114.115.208.32:8000/timetable/?student_id=${Encrypt.encrypt(studentID)}&week=all');
  try {
    response = await dio.request(
      'http://114.115.208.32:8000/timetable/?student_id=${Encrypt.encrypt(studentID)}&week=all',
      options: Options(method: "GET", responseType: ResponseType.plain),
    );
    //cancelToken: _can);//测试错误
  } on DioError catch (e) {
    //throw 401;//测试
    if (e.type == DioErrorType.RESPONSE) {
      if (e.response.statusCode == 401) {
        throw 401;
      } else if (e.response.statusCode == 402) {
        throw 402;
      } else {
        throw "网络请求出错";
      }
    } else {
      throw "网络请求出错";
    }
  }
  ss = response.data;
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

class TeacherInfo {
  int id;
  String teacherName;
  int upNum;
  bool hasUp;

  TeacherInfo({this.id, this.teacherName, this.upNum, this.hasUp});

  factory TeacherInfo.fromJson(Map<String, dynamic> parsedJson) {
    return TeacherInfo(
        id: parsedJson['id'],
        teacherName: parsedJson['teacher_name'],
        upNum: parsedJson['up'],
        hasUp: parsedJson['has_up']);
  }
}

class TeacherInfoList {
  final List<TeacherInfo> teacherInfoList;

  TeacherInfoList(this.teacherInfoList);

  factory TeacherInfoList.fromJson(List<dynamic> parsedJson) {
    return TeacherInfoList(
        parsedJson.map((i) => TeacherInfo.fromJson(i)).toList());
  }
}

class Info {
  int id;
  String studentId;
  var score;
  String updateTime;
  String content;
  int upNum;
  int downNum;
  bool hasUp;
  bool hasDown;

  Info(
      {this.id,
      this.studentId,
      this.score,
      this.updateTime,
      this.content,
      this.upNum,
      this.downNum,
      this.hasUp,
      this.hasDown});

  factory Info.fromJson(Map<String, dynamic> parsedJson) {
    return Info(
        id: parsedJson['id'],
        studentId: parsedJson['student'],
        score: parsedJson['score'],
        updateTime: parsedJson['updated_time'],
        content: parsedJson['evaluation'],
        upNum: parsedJson['up'],
        downNum: parsedJson['down'],
        hasUp: parsedJson['has_up'],
        hasDown: parsedJson['has_down']);
  }
}

class InfoList {
  final List<Info> infoList;

  InfoList(this.infoList);

  factory InfoList.fromJson(List<dynamic> parsedJson) {
    return InfoList(parsedJson.map((i) => Info.fromJson(i)).toList());
  }
}

class ScoreInfoList {
  final List<int> scoreInfoList;

  ScoreInfoList(this.scoreInfoList);

  factory ScoreInfoList.fromJson(List<dynamic> parsedJson) {
    return ScoreInfoList(parsedJson.cast<int>());
  }
}

class EvaluationDetail {
  String courseName;
  int evaluationNum;
  var averageScore;
  TeacherInfoList teacherInfo;
  InfoList info;
  ScoreInfoList scoreInfo;

  EvaluationDetail(
      {this.courseName,
      this.evaluationNum,
      this.averageScore,
      this.teacherInfo,
      this.info,
      this.scoreInfo});

  factory EvaluationDetail.fromJson(Map<String, dynamic> parsedJson) {
    return EvaluationDetail(
      courseName: parsedJson['course_name'],
      evaluationNum: parsedJson['evaluation_num'],
      averageScore: parsedJson['avg_score'],
      teacherInfo: TeacherInfoList.fromJson(parsedJson['teacher_info']),
      info: InfoList.fromJson(parsedJson['info']),
      scoreInfo: ScoreInfoList.fromJson(parsedJson['score_info']),
    );
  }
}

Future<EvaluationDetail> getEvaluationDetail(
    String bid, String studentID) async {
  final response = await http.get(
      'http://114.115.208.32:8000/timetable/evaluation/student/?bid=$bid&student_id=${Encrypt.encrypt(studentID)}');
  print(
      'GET http://114.115.208.32:8000/timetable/evaluation/student/?bid=$bid&student_id=${Encrypt.encrypt(studentID)}');
  print(response.statusCode);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    Utf8Decoder decode = new Utf8Decoder();
    return EvaluationDetail.fromJson(
        json.decode(decode.convert(response.bodyBytes)));
  } else {
    throw response.statusCode;
    // If the server did not return a 200 OK response,
    // then throw an exception.
//    throw Exception('Failed to load course center');
  }
}

Future<void> postAgree(String student, String bid, int type) async {
  var response;
  if (type == 0) {
    response = await http.post(
        'http://114.115.208.32:8000/timetable/evaluation/student/up/',
        body: {
          "student_id": "$student",
          "actor": "${Encrypt.encrypt2(GlobalUser.studentID)}",
          "bid": "$bid"
        });
    print(
        'post -> http://114.115.208.32:8000/timetable/evaluation/student/up/');
  } else if (type == 1) {
    response = await http.post(
        'http://114.115.208.32:8000/timetable/evaluation/student/cancel_up/',
        body: {
          "student_id": "$student",
          "actor": "${Encrypt.encrypt2(GlobalUser.studentID)}",
          "bid": "$bid"
        });
    print(
        'post -> http://114.115.208.32:8000/timetable/evaluation/student/cancel_up/');
  }
  print('student_id: $student');
  print('actor: ${Encrypt.encrypt2(GlobalUser.studentID)}');
  print('bid: $bid');
  if (response.statusCode == 201) {
    print('post success');
    return;
  } else {
    print(response.statusCode);
    throw Exception('Failed to post message');
  }
}

Future<void> postDisagree(String student, String bid, int type) async {
  var response;
  if (type == 0) {
    response = await http.post(
        'http://114.115.208.32:8000/timetable/evaluation/student/down/',
        body: {
          "student_id": "$student",
          "actor": "${Encrypt.encrypt2(GlobalUser.studentID)}",
          "bid": "$bid"
        });
    print(
        'post -> http://114.115.208.32:8000/timetable/evaluation/student/down/');
  } else if (type == 1) {
    response = await http.post(
        'http://114.115.208.32:8000/timetable/evaluation/student/cancel_down/',
        body: {
          "student_id": "$student",
          "actor": "${Encrypt.encrypt2(GlobalUser.studentID)}",
          "bid": "$bid"
        });
    print(
        'post -> http://114.115.208.32:8000/timetable/evaluation/student/cancel_down/');
  }
  print('student_id: $student');
  print('actor: ${Encrypt.encrypt2(GlobalUser.studentID)}');
  print('bid: $bid');
  if (response.statusCode == 201) {
    print('post success');
    return;
  } else {
    print(response.statusCode);
    throw Exception('Failed to post message');
  }
}

Future<void> postTeacherAgree(String teacher, String bid, int type) async {
  var response;
  if (type == 0) {
    response = await http.post(
        'http://114.115.208.32:8000/timetable/evaluation/teacher/',
        body: {
          "teacher": "$teacher",
          "actor": "${Encrypt.encrypt2(GlobalUser.studentID)}",
          "bid": "$bid",
          "action": "up"
        });
    print('post -> http://114.115.208.32:8000/timetable/evaluation/teacher/');
  } else if (type == 1) {
    response = await http.post(
        'http://114.115.208.32:8000/timetable/evaluation/teacher/',
        body: {
          "teacher": "$teacher",
          "actor": "${Encrypt.encrypt2(GlobalUser.studentID)}",
          "bid": "$bid",
          "action": "cancel_up"
        });
    print('post -> http://114.115.208.32:8000/timetable/evaluation/teacher/');
  }
  print('teacher: $teacher');
  print('actor: ${Encrypt.encrypt2(GlobalUser.studentID)}');
  print('bid: $bid');
  print('action: ${type == 0 ? 'up' : 'cancel_up'}');
  if (response.statusCode == 201) {
    print('post success');
    return;
  } else {
    print(response.statusCode);
    throw Exception('Failed to post message');
  }
}

Future<void> deleteComment(String bid) async {
  Dio dio = new Dio();
  var response = await dio.request(
    'http://114.115.208.32:8000/timetable/evaluation/student/',
    data: {
      "bid": "$bid",
      "student_id": "${Encrypt.encrypt2(GlobalUser.studentID)}",
    },
    options: Options(method: "DELETE", responseType: ResponseType.json),
  );
  print('delete -> http://114.115.208.32:8000/timetable/evaluation/student/');
  print('bid: $bid');
  print('student_id: ${Encrypt.encrypt2(GlobalUser.studentID)}');
  if (response.statusCode == 204) {
    print('delete success');
    return;
  } else {
    print(response.statusCode);
    throw Exception('Failed to delete message');
  }
}

class EvaluationCourse {
  final String courseName;
  final String department;
  final String bid;
  final double score;
  final String credit;

  EvaluationCourse(
      {this.courseName, this.department, this.bid, this.score, this.credit});

  factory EvaluationCourse.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson['avg_score'] == null) parsedJson['avg_score'] = 0.0;
    return EvaluationCourse(
        courseName: parsedJson['course_name'],
        department: parsedJson['department'],
        bid: parsedJson['bid'],
        credit: parsedJson['credit'],
        score: parsedJson['avg_score']);
  }
}

class EvaluationCourseList {
  final List<EvaluationCourse> courseList;

  EvaluationCourseList(this.courseList);

  factory EvaluationCourseList.fromJson(List<dynamic> parsedJson) {
    List<EvaluationCourse> courseList =
        parsedJson.map((i) => EvaluationCourse.fromJson(i)).toList();
    return EvaluationCourseList(courseList);
  }
}

class EvaluationCoursePage {
  final EvaluationCourseList evaluationCourseList;
  final int totalCourse;
  final int currentPage;
  final int totalPage;

  EvaluationCoursePage(this.evaluationCourseList, this.totalCourse,
      this.currentPage, this.totalPage);

  factory EvaluationCoursePage.fromJson(Map<String, dynamic> parsedJson) {
//    print(parsedJson);
    int total = parsedJson['total'];
    int currentPage = parsedJson['cur_page'];
    int totalPage = parsedJson['total_page'];
    EvaluationCourseList courseList =
        EvaluationCourseList.fromJson(parsedJson['info']);
    return EvaluationCoursePage(courseList, total, currentPage, totalPage);
  }
}

Future<EvaluationCoursePage> loadEvaluationCoursePage(String courseName,
    String teacher, String type, String department, int page) async {
  Dio dio = new Dio();
  Response response;
  try {
    if (department == null || department == "全部") department = "";
    if (type == null || type == "全部") type = "";
    print(
        'http://114.115.208.32:8000/timetable/search/?course=$courseName&teacher=$teacher&type=$type&department=$department&page=$page');
    response = await dio.request(
        'http://114.115.208.32:8000/timetable/search/?course=$courseName&teacher=$teacher&type=$type&department=$department&page=$page',
        options: Options(method: "GET", responseType: ResponseType.json));
  } catch (e) {
    print(e);
    throw ('参数名称或者数目错误');
  }
  try {
    return EvaluationCoursePage.fromJson(response.data);
  } catch (e) {
    throw ('课程评价列表解析错误');
  }
}

Future<EvaluationCoursePage> loadDefaultEvaluationCourseList(
    String studentID) async {
  Dio dio = new Dio();
  Response response;
  try {
    print(
        'http://114.115.208.32:8000/timetable/search/default/?student_id=${Encrypt.encrypt(studentID)}');
    response = await dio.request(
        'http://114.115.208.32:8000/timetable/search/default/?student_id=${Encrypt.encrypt(studentID)}',
        options: Options(method: "GET", responseType: ResponseType.json));
  } catch (e) {
    throw ('参数名称或者数目错误');
  }
  try {
    return EvaluationCoursePage.fromJson(response.data);
  } catch (e) {
    throw ('课程评价列表解析错误');
  }
}

class SchoolCalendarStr {
  String schoolYear;
  String firstSemester;
  String winterSemester;
  String secondSemester;
  String thirdSemester;
  String endSemester;
  List<Holiday> holiday;
  List<Ddl> ddl;

  SchoolCalendarStr(
      {this.schoolYear,
      this.firstSemester,
      this.winterSemester,
      this.secondSemester,
      this.thirdSemester,
      this.endSemester,
      this.holiday,
      this.ddl});

  SchoolCalendarStr.fromJson(Map<String, dynamic> json) {
    schoolYear = json['school_year'];
    firstSemester = json['first_semester'];
    winterSemester = json['winter_semester'];
    secondSemester = json['second_semester'];
    thirdSemester = json['third_semester'];
    endSemester = json['end_semester'];
    if (json['holiday'] != null) {
      holiday = new List<Holiday>();
      json['holiday'].forEach((v) {
        holiday.add(new Holiday.fromJson(v));
      });
    }
    if (json['ddl'] != null) {
      ddl = new List<Ddl>();
      json['ddl'].forEach((v) {
        ddl.add(new Ddl.fromJson(v));
      });
    }
  }
}

class Holiday {
  DateTime date;
  String holiday;

  Holiday({this.date, this.holiday});

  Holiday.fromJson(Map<String, dynamic> json) {
    date = DateTime.parse(json['date'] as String);
    holiday = json['holiday'];
  }
}

class Ddl {
  String course;
  String homework;
  DateTime ddlDay;
  String ddlSecond;

  Ddl({this.course, this.homework, this.ddlDay, this.ddlSecond});

  Ddl.fromJson(Map<String, dynamic> json) {
    String ddlStr = json['ddl'] as String;
    List<String> ddlInfo = ddlStr.split(' ');
    course = json['course'];
    homework = json['homework'];
    ddlDay = DateTime.parse(ddlInfo[0]);
    ddlSecond = ddlInfo[1];
  }
}

// ignore: camel_case_types
class schoolCalendar {
  Map<DateTime, String> weekNumbers;
  List<Holiday> holidays;
  List<Ddl> ddls;

  schoolCalendar() {
    weekNumbers = new Map();
    holidays = [];
    ddls = [];
  }

  void parse(SchoolCalendarStr str) {
    //ddl
    ddls = str.ddl;
    //holiday
    holidays = str.holiday;
    //week number
    DateTime first = DateTime.parse(str.firstSemester);
    DateTime winter = DateTime.parse(str.winterSemester);
    DateTime second = DateTime.parse(str.secondSemester);
    DateTime third = DateTime.parse(str.thirdSemester);
    DateTime end = DateTime.parse(str.endSemester);
    Duration inter = Duration(days: 7);
    for (int i = 0; first.isBefore(winter); i++) {
      weekNumbers[first] = '秋${i + 1}';
      first = first.add(inter);
    }
    for (int i = 0; winter.isBefore(second); i++) {
      weekNumbers[winter] = '寒假${i + 1}';
      winter = winter.add(inter);
    }
    for (int i = 0; second.isBefore(third); i++) {
      weekNumbers[second] = '春${i + 1}';
      second = second.add(inter);
    }
    for (int i = 0; third.isBefore(end); i++) {
      weekNumbers[third] = '夏${i + 1}';
      third = third.add(inter);
    }
  }
}

Future<schoolCalendar> getSchoolCalendar(String studentID) async {
  String schoolYear = '2019-2020';
  DateTime endDay = DateTime(2020, 9, 6);
  DateTime nowDay = DateTime.now();
  if (nowDay.isAfter(endDay)) {
    schoolYear = '2020-2021';
  }
  Dio dio = new Dio();
  Response response;
  print(
      'http://114.115.208.32:8000/ddl/Calendar/?student_id=${Encrypt.encrypt(studentID)}&school_year=$schoolYear');
  try {
    response = await dio.request(
      'http://114.115.208.32:8000/ddl/Calendar/?student_id=${Encrypt.encrypt(studentID)}&school_year=$schoolYear',
      options: Options(method: "GET", responseType: ResponseType.plain),
    );
  } on DioError catch (e) {
    //throw 401;//测试
    if (e.type == DioErrorType.RESPONSE) {
      if (e.response.statusCode == 401) {
        throw 401;
      } else if (e.response.statusCode == 402) {
        throw 402;
      } else if (e.response.statusCode == 463) {
        throw "无该学年数据";
      } else {
        throw "网络请求出错";
      }
    } else {
      throw "其他错误";
    }
  }
  String ss = response.data;

//  String ss = await rootBundle.loadString('assets/data/courseTable1.json');
  try {
    dynamic jsonList = json.decode(ss);
    SchoolCalendarStr tempStr = new SchoolCalendarStr.fromJson(jsonList);
    schoolCalendar temp = new schoolCalendar();
    temp.parse(tempStr);
    return temp;
  } catch (e) {
    throw "文件读取错误";
  }
}
