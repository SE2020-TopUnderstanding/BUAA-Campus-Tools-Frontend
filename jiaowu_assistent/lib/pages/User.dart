import 'dart:convert';

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

class Room{
  String room;
  
  Room(String string) {
    room = string;
  }
}

Future<EmptyRoom> getEmptyRoom(
    String campus, String date, String section, String building) async{
  try {
    Response response = await Dio().get('http://www.mocky.io/v2/5e9a690133000021bf7b3008', options: Options(responseType: ResponseType.plain));    //http://114.115.208.32:8000/query/classroom/ campus="$campus" date="$date" section="$section"
    print('Request(http://127.0.0.1:8000/query/classroom/ campus="$campus" date="$date" section="$section")');
    Map<String, dynamic> data = json.decode(response.data.toString());
    if (data == null) {
      throw FormatException('No Data Response!');
    }
    else if (!data.containsKey(building)) {
      print("building: $building");
      throw FormatException('The certain building has no empty room!');
    }
    else {
      List<dynamic> listJson = data['$building'];
      List<String> list = listJson.map((value) => value['classroom'].toString()).toList();
      return EmptyRoom(building, list);
    }
  } catch(e) {
    print(e);
    return null;
  }
}