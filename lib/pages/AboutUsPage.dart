import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPage createState() => _AboutUsPage();
}

class _AboutUsPage extends State<AboutUsPage> {
  PackageInfo packageInfo;

  @override
  initState() {
    super.initState();
    getInfo();
  }

  Future<void> getInfo() async {
    PackageInfo.fromPlatform().then((PackageInfo temp) {
      setState(() {
        packageInfo = temp;
      });
    });
  }

  launchURL() {
    launch('https://www.cnblogs.com/se2020djlj/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("关于我们", style: TextStyle(color: Colors.grey[100])),
//          backgroundColor: Colors.lightBlue,
          elevation: 0,
        ),
        backgroundColor: Colors.grey[100],
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage("assets/images/head.png"),
                radius: 50,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  children: <Widget>[
                    Text("航  胥",
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    packageInfo != null
                        ? Container(
                            height: 30,
                            child: Text("v ${packageInfo.version}",
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center),
                            alignment: Alignment.center,
                          )
                        : Container(
                            height: 30,
                          ),
                  ],
                ),
                alignment: Alignment.center,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                    "Powered by 顶级理解团队\n\n北航2020年春季软件工程\n指导老师：罗杰 任健\n\n团队博客：\nhttps://www.cnblogs.com/se2020djlj/",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center),
                alignment: Alignment.center,
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  child: MaterialButton(
                    onPressed: launchURL,
                    child: Text("点击进入博客首页"),
                    color: Color(0x99FFFFFF),
                    minWidth: double.infinity,
                    height: 50,
                  ))
            ],
          ),
        ));
  }
}
