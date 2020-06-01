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

  Column _block(BuildContext context, Icon icon, Text text, Widget page) {
    return Column(
      children: <Widget>[
        Container(
          height: 60,
          child: RaisedButton(
            shape: CircleBorder(),
            child: icon,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => page));
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        text,
      ],
    );
  }

  // 目前的设计是一行一行，然后每行三列，一列里面button + text

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
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _block(
                    context,
                    Icon(
                      Icons.school,
                      size: 40,
                    ),
                    Text("成绩查询"),
                    ScorePage()),
                _block(
                    context,
                    Icon(
                      Icons.business,
                      size: 40,
                    ),
                    Text("空教室查询"),
                    EmptyRoomPage()),
                _block(
                    context,
                    Icon(
                      Icons.check_circle_outline,
                      size: 40,
                    ),
                    Text("课程中心查询"),
                    CourseCenterPage()),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
//                _block(context, Icon(Icons.school, size: 40,), Text("课程评价"), ScorePage()),

                _block(
                    context,
                    Icon(
                      Icons.date_range,
                      size: 40,
                    ),
                    Text("课表查询"),
                    CourseTablePage()),
                _block(
                    context,
                    Icon(
                      Icons.border_color,
                      size: 40,
                    ),
                    Text("课程评价"),
                    CourseEvaluationPage()),

                _block(context, Icon(Icons.calendar_today, size: 40,), Text("校历"), CalendarPage()),

              ],
            )
          ],
        ),
      ),
    );
  }
}
