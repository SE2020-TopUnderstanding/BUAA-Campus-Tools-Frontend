import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/CourseCenterPage.dart';
import 'package:jiaowuassistent/pages/EmptyRoomPage.dart';
import 'package:jiaowuassistent/pages/ScorePage.dart';
import 'package:jiaowuassistent/pages/CourseTablePage.dart';
import 'package:jiaowuassistent/pages/CourseEvaluationPage.dart';
import 'package:jiaowuassistent/pages/CalendarPage.dart';

class FunctionsPage extends StatelessWidget {
  // 图标函数，其中page 参数需要给出页面函数

  Container _block(BuildContext context, Icon icon, Text text, Widget page) {
    return Container(
      height: 60,
      width: 600,
      decoration: BoxDecoration(
        border: new Border.all(width: 2.0, color: Colors.black12),
        borderRadius: new BorderRadius.all(new Radius.circular(12.0)),
      ),
      child: RaisedButton(
        color: Colors.grey[100],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            icon,
            SizedBox(
              width: 30,
            ),
            text
          ],
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('功能选择', style: TextStyle(color: Colors.grey[100])),
//        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.grey[100],
      body: new Container(
        padding: EdgeInsets.only(left: 50, top: 40, right: 50, bottom: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _block(
                context,
                Icon(
                  Icons.school,
                  color: Color(0xFF1565C0),
                  size: 40,
                ),
                Text(
                  "成绩查询",
                  style: TextStyle(fontSize: 20),
                ),
                ScorePage()),
            _block(
                context,
                Icon(
                  Icons.business,
                  color: Color(0xFF1565C0),
                  size: 40,
                ),
                Text(
                  "空教室查询",
                  style: TextStyle(fontSize: 20),
                ),
                EmptyRoomPage()),
            _block(
                context,
                Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF1565C0),
                  size: 40,
                ),
                Text(
                  "课程中心查询",
                  style: TextStyle(fontSize: 20),
                ),
                CourseCenterPage()),
            _block(
                context,
                Icon(
                  Icons.date_range,
                  color: Color(0xFF1565C0),
                  size: 40,
                ),
                Text(
                  "课表查询",
                  style: TextStyle(fontSize: 20),
                ),
                CourseTablePage()),
            _block(
                context,
                Icon(
                  Icons.assignment,
                  color: Color(0xFF1565C0),
                  size: 40,
                ),
                Text(
                  "课程评价",
                  style: TextStyle(fontSize: 20),
                ),
                CourseEvaluationPage()),
            _block(
                context,
                Icon(
                  Icons.calendar_today,
                  color: Color(0xFF1565C0),
                  size: 40,
                ),
                Text(
                  "校历",
                  style: TextStyle(fontSize: 20),
                ),
                CalendarPage()),
          ],
        ),
      ),
    );
  }
}
