import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/LoginPage.dart';
import 'package:jiaowuassistent/pages/WelcomePage.dart';
import 'GlobalUser.dart';
import 'package:jiaowuassistent/pages/FirstPage.dart';
import 'package:async/async.dart';
import 'package:jiaowuassistent/pages/HomePage.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    // TODO: implement build
    return MultiProvider(
      providers: [ChangeNotifierProvider(builder: (_) => PageSelect())],
      child: Consumer(
          builder: (BuildContext context, PageSelect select, Widget child) {
        return MaterialApp(
          title: '航胥',
          theme: ThemeData(
            primaryColor: Colors.grey,
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
