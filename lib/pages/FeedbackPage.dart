import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/FeedbackDetailPage.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPage createState() {
    return _FeedbackPage();
  }
}

class _FeedbackPage extends State<FeedbackPage> {
  List<String> items = ["课表查询", "DDL查询", "空教室查询"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('问题反馈'),
          backgroundColor: Colors.lightBlue,
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
                                builder: (context) => FeedbackDetailPage()));
                      },
                      contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(width: 1, color: Colors.grey))),
                  );
                },
              ),
            )
          ],
        ));
  }
}