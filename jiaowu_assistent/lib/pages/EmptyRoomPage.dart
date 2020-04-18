import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'dart:async';

import 'package:jiaowuassistent/pages/CourseTablePage.dart';
import 'package:jiaowuassistent/pages/User.dart';

class EmptyRoomPage extends StatefulWidget {
  @override
  _DateTimeDemoState createState() => _DateTimeDemoState();
}

class _DateTimeDemoState extends State<EmptyRoomPage> {
  Map<int, String> campusMap = {
    1: "学院路校区",
    2: "沙河校区",
  };

  Map<int, String> buildingMap = {
    1: "一号楼",
    2: "二号楼",
    3: "新主楼",
  };

  Map<int, String> lessonMap = {
    1: "第一节课",
    2: "第二节课",
    3: "第三节课",
    4: "第四节课",
    5: "第五节课",
    6: "第六节课",
    7: "第七节课",
    8: "第八节课",
    9: "第九节课",
    10: "第十节课",
    11: "第十一节课",
    12: "第十二节课",
    13: "第十三节课",
    14: "第十四节课",
  };

  DateTime _selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 9, minute: 30);
  static List<String> list = ["G-101", "H-402"];

  static double size = 20;
  TextStyle textStyle = TextStyle(fontSize: size);
  var _selectedBegin = 1, _selectedEnd = 1, _selectedCampus = 1, _selectedBuilding = 1;
  List<String> _list = list;


  Future<void> _selectDate() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    setState(() {
      _selectedDate = date;
    });
  }

  Future<void> _search() async {
    String section = '';
    for (int i = _selectedBegin; i <= _selectedEnd; i++) {
      section = section + i.toString() + ',';
    }
    try {
      getEmptyRoom(campusMap[_selectedCampus], _selectedDate.toString(), section,
          buildingMap[_selectedBuilding]).then((EmptyRoom temp) {
        setState(() {
          if (temp == null) {
            _list = null;
          }
          else {
            _list = temp.getRooms();
          }
        });
      });
    }
    catch(e) {
      print(e);
    }
  }

  List<DropdownMenuItem> getListData() {
    List<DropdownMenuItem> items=
      [
        DropdownMenuItem(child: Text('第一节课'), value: 1,),
        DropdownMenuItem(child: Text('第二节课'), value: 2,),
        DropdownMenuItem(child: Text('第三节课'), value: 3,),
        DropdownMenuItem(child: Text('第四节课'), value: 4,),
        DropdownMenuItem(child: Text('第五节课'), value: 5,),
        DropdownMenuItem(child: Text('第六节课'), value: 6,),
        DropdownMenuItem(child: Text('第七节课'), value: 7,),
        DropdownMenuItem(child: Text('第八节课'), value: 8,),
        DropdownMenuItem(child: Text('第九节课'), value: 9,),
        DropdownMenuItem(child: Text('第十节课'), value: 10,),
        DropdownMenuItem(child: Text('第十一节课'), value: 11,),
        DropdownMenuItem(child: Text('第十二节课'), value: 12,),
        DropdownMenuItem(child: Text('第十三节课'), value: 13,),
        DropdownMenuItem(child: Text('第十四节课'), value: 14,),
      ];
    return items;
  }

  Widget _buildListItem(BuildContext context, int index) {
    if (_list == null) {
      return Container(
        child: ListTile(
          title: Text("No Empty Room!"),
          subtitle: Text(buildingMap[_selectedBuilding]),
        ),
        decoration: BoxDecoration(border: Border(top: BorderSide(width: 1, color: Colors.black))),
      );
    }
    return Container(
      child: ListTile(
        title:  Text(_list[index]),
        subtitle: Text(buildingMap[_selectedBuilding]),
      ),
      decoration: BoxDecoration(border: Border(top: BorderSide(width: 1, color: Colors.black))),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('空教室查询'),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: _selectDate,
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.date_range, size: 30,),
                              SizedBox(width: 20,),
                              Text(DateFormat.yMMMMd().format(_selectedDate), style: textStyle,),
                              Icon(Icons.arrow_drop_down, size: size,),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  CupertinoButton(
                    child: Text("查询"),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.grey,
                    onPressed: _search,
                    pressedOpacity: 0.8,
                  )
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  DropdownButton(
                    value: _selectedCampus,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    iconEnabledColor: Colors.black,
                    hint: Text('请选择校区'),
                    items: [
                      DropdownMenuItem(child: Text('沙河校区'), value: 1,),
                      DropdownMenuItem(child: Text('学院路校区'), value: 2,)
                    ],
                    onChanged: (value){
                      setState(() {
                        _selectedCampus = value;
                      });
                    },
                  ),
                  DropdownButton(
                    value: _selectedBuilding,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    iconEnabledColor: Colors.black,
                    hint: Text('请选择教学楼'),
                    items: [
                      DropdownMenuItem(child: Text('一号教学楼'), value: 1,),
                      DropdownMenuItem(child: Text('二号教学楼'), value: 2,),
                      DropdownMenuItem(child: Text('新主楼'), value: 3,),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedBuilding = value;
                      });
                    },
                  )
                ],
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    DropdownButton(
                      value: _selectedBegin,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 30,
                      iconEnabledColor: Colors.black,
                      hint: Text('请选择开始时间段'),
                      items: getListData(),
                      onChanged: (value){
                        setState(() {
                          _selectedBegin = value;
                        });
                      },
                    ),
                    DropdownButton(
                      value: _selectedEnd,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 30,
                      iconEnabledColor: Colors.black,
                      hint: Text('请选择结束时间段'),
                      items: getListData(),
                      onChanged: (value){
                        setState(() {
                          _selectedEnd = value;
                        });
                      },
                    ),
                  ]
              ),
              SizedBox(height: 40,),
            Column(
              children: <Widget>[
                Container(
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: (_list == null) ? 1 : _list.length,
                    itemBuilder: _buildListItem,
                  ),
                )
              ],
            )
            ],
          ),
        )
    );
  }
}