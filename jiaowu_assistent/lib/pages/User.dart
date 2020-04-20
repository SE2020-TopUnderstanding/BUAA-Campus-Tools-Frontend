import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gbk2utf8/gbk2utf8.dart';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

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
