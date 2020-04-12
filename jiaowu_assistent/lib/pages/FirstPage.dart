import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("主页"),
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: false,
      ),
      body: new Container(
        decoration: new BoxDecoration(
          color: Colors.white,
        ),
        child: new Center(
          child: new Text('这里是主页，默认显示当周课表，目前尚未完成。',
            style: TextStyle(
              fontSize: 32,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );

  }
}