import 'package:jiaowuassistent/pages/HomePage.dart';
import 'package:jiaowuassistent/pages/PersonalPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'BUAA',
      theme: ThemeData(
        primaryColor: Colors.grey,
      ),
      home: new MyHomePage(),
    );
  }
}