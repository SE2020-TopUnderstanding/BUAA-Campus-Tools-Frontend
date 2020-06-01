import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/FeedbackDetailPage.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPage createState() {
    return _FeedbackPage();
  }
}

class _FeedbackPage extends State<FeedbackPage> {
  List<String> items = ["课表", "DDL查询", "成绩查询", "空教室", "校历", "课程评价", "其他"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('使用反馈'),
//          backgroundColor: Colors.lightBlue,
        ),
        body: Column(
          children: <Widget>[
            Container(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: ListTile(
                      title: Text(
                        items[index],
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        size: 20,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FeedbackDetailPage(
                                      kind: items[index],
                                    )));
                      },
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: Colors.grey))),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
