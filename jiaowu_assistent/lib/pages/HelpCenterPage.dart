import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelpCenterPage extends StatelessWidget{

//  _launchURL(String url) async {
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {
//      throw 'Could not launch $url';
//    }
//  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("帮助中心"),
        elevation: 0,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: Text("使用中若遇到问题，请通过下面的链接联系我们^_^",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center
              ),
              alignment: Alignment.center,
            ),
            Container(
              alignment: Alignment.center,
              child: ListTile(
                title: Text("https://www.cnblogs.com/se2020djlj/",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center
                ),
              ),
            ),
//            RaisedButton(
//              child: Text('打开外部浏览器'),
//              onPressed: () async{
//                const url = 'https://cflutter.com';
//                if (await canLaunch(url)) {
//                  await launch(url);
//                } else {
//                  throw 'Could not launch $url';
//                }
//              },
//            ),
          ],
        ),
      )
    );
  }
}