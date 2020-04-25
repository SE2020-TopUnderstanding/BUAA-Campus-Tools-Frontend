import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/LoginPage.dart';
import 'package:jiaowuassistent/pages/WelcomePage.dart';
import 'GlobalUser.dart';
import 'package:jiaowuassistent/pages/FirstPage.dart';
import 'package:async/async.dart';
import 'package:jiaowuassistent/pages/HomePage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalUser.init();
  runApp(MyApp());
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
