import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/LoginPage.dart';
import 'package:jiaowuassistent/pages/WelcomePage.dart';
import 'GlobalUser.dart';
import 'package:jiaowuassistent/pages/HomePage.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

void main() async {
  final JPush jPush = JPush();

  Future<void> initPlatformState() async {
    jPush.getRegistrationID().then((rid) {
      print('---->rid: $rid');
    });

    jPush.setup(
      appKey: "f0f9cce2a851456596e97378",
      channel: "developer-default",
      production: false,
      debug: true,
    );

    jPush.applyPushAuthority(
        NotificationSettingsIOS(sound: true, alert: true, badge: true));

    try {
      jPush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
        print('---->接收到推送:$message');
      });
    } on Exception {
      print("---->获取平台版本失败");
    }
  }

  WidgetsFlutterBinding.ensureInitialized();
  initPlatformState();
  await GlobalUser.init();
  runApp(MyApp());
  if (Platform.isAndroid) {
    //设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，
    //覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(builder: (_) => PageSelect())],
      child: Consumer(
          builder: (BuildContext context, PageSelect select, Widget child) {
        return MaterialApp(
          title: '航胥',
          theme: ThemeData(
            primaryColor: Colors.lightBlue,
          ),
          home: getHomePage(),
          routes: {
            '/loginPage': (context) => LoginPage(),
            '/homePage': (context) => MyHomePage(),
          },
        );
      }),
    );
  }
}

Widget getHomePage() {
  if (GlobalUser.isFirst) {
    return WelcomePage();
  } else if (GlobalUser.isLogin) {
    return MyHomePage();
  } else {
    return LoginPage();
  }
}
