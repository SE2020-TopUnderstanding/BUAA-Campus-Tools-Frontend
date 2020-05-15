import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseEvaluationDetailPage extends StatefulWidget {
  @override
  _CourseEvaluationDetailPageState createState() => _CourseEvaluationDetailPageState();
}

class _CourseEvaluationDetailPageState extends State<CourseEvaluationDetailPage>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('课程详情'),
        backgroundColor: Colors.lightBlue,
      ),
      body: new Scaffold(
        appBar: new AppBar(
          title: new Text('Welcome to Flutter'),
        ),
        body: new Center(
          child: new Text('Hello World'),
        ),
      ),
    );
  }
}