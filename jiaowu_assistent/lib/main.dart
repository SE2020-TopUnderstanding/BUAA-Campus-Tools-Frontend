import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/LoginPage.dart';
import 'package:jiaowuassistent/pages/WelcomePage.dart';
import 'GlobalUser.dart';
import 'package:jiaowuassistent/pages/FirstPage.dart';
import 'package:async/async.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalUser.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'BUAA',
      theme: ThemeData(
        primaryColor: Colors.grey,
      ),
      home: getHomePage(),
    );
  }
}

Widget getHomePage(){
  if(GlobalUser.isFirst){
    return WelcomePage();
  }else if(GlobalUser.isLogin){
    return FirstPage();
  }else{
    return LoginPage();
  }
}