import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/CourseCenterPage.dart';
import 'package:jiaowuassistent/pages/EmptyRoomPage.dart';
import 'package:jiaowuassistent/pages/ScorePage.dart';
import 'package:jiaowuassistent/pages/CourseTablePage.dart';


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
            onPressed: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => page));
            },
          ),
        ),
        text,
      ],
    );
  }

  // 目前的设计是一行一行，然后每行三列，一列里面button + text

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('功能选择'),
        backgroundColor: Colors.grey[500],
        automaticallyImplyLeading: false,
      ),
      body: new Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 100,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _block(context, Icon(Icons.school, size: 40,), Text("成绩查询"), ScorePage()),

                _block(context, Icon(Icons.business, size: 40,), Text("空教室查询"), EmptyRoomPage()),
                
                _block(context, Icon(Icons.check_circle_outline, size: 40,), Text("课程中心查询"), CourseCenterPage()),
              ],
            ),
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _block(context, Icon(Icons.school, size: 40,), Text("课程评价"), ScorePage()),

                _block(context, Icon(Icons.date_range, size: 40,), Text("课表查询"), CourseTablePage()),

                _block(context, Icon(Icons.date_range, size: 40,), Text("未知"), ScorePage()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
