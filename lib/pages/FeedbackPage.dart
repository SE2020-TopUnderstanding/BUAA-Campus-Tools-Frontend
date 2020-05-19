import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/FeedbackDetailPage.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:jpush_flutter/jpush_flutter.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPage createState() {
    return _FeedbackPage();
  }
}

class _FeedbackPage extends State<FeedbackPage> {
  List<String> items = ["课表查询", "DDL查询", "空教室查询"];
  String debugLable = 'Unknown';

  /*错误信息*/
  final JPush jpush = new JPush();

  /* 初始化极光插件*/

  @override
  void initState() {
    super.initState();
    initPlatformState(); /*极光插件平台初始化*/
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      /*监听响应方法的编写*/
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
        print(">>>>>>>>>>>>>>>>>flutter 接收到推送: $message");
        setState(() {
          debugLable = "接收到推送: $message";
        });
      });
    } on PlatformException {
      platformVersion = '平台版本获取失败，请检查！';
    }
    if (!mounted) {
      return;
    }
    setState(() {
      debugLable = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('使用反馈'),
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
            RaisedButton(
                child: new Text(
                  '点击发送推送消息\n',
                ),
                onPressed: () {
                  /*三秒后出发本地推送*/
                  var fireDate = DateTime.fromMillisecondsSinceEpoch(
                      DateTime.now().millisecondsSinceEpoch + 3000);
                  var localNotification = LocalNotification(
                    id: 234,
                    title: '我是推送测试标题',
                    buildId: 1,
                    content: '看到了说明已经成功了',
                    fireTime: fireDate,
                    subtitle: '一个测试',
                  );
                  jpush.sendLocalNotification(localNotification).then((res) {
                    setState(() {
                      debugLable = res;
                    });
                  });
                }),
          ],
        ));
  }
}
