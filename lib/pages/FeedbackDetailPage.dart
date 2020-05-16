import 'package:flutter/material.dart';

class FeedbackDetailPage extends StatefulWidget {
  @override
  _FeedbackDetailPage createState() {
    return _FeedbackDetailPage();
  }
}

class _FeedbackDetailPage extends State<FeedbackDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('问题详情描述'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(),
    );
  }
}
