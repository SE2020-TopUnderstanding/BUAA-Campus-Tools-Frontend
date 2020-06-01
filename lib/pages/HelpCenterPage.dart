import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterPage extends StatelessWidget {
  launchURL() {
    launch('https://www.cnblogs.com/se2020djlj/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("帮助中心", style: TextStyle(color: Colors.grey[100])),
//          backgroundColor: Colors.lightBlue,
          elevation: 0,
        ),
        backgroundColor: Colors.grey[100],
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: Text("使用中若遇到问题，请通过下面的链接反馈给我们^_^",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center),
                alignment: Alignment.center,
              ),
              Container(
                alignment: Alignment.center,
                child: ListTile(
                  title: Text("https://www.cnblogs.com/se2020djlj/",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: MaterialButton(
                    onPressed: launchURL,
                    child: Text("点击进入"),
                    color: Color(0x99FFFFFF),
                    minWidth: double.infinity,
                    height: 50,
                  ))
            ],
          ),
        ));
  }
}
