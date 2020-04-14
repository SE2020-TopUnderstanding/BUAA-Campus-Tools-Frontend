import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FunctionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('查询入口'),
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: false,
      ),
      body: new Container(
        decoration: new BoxDecoration(
          color: Colors.white,
        ),
        child: new Center(
          child: new Text(
            '这里是查询入口，目前尚未完成。',
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
