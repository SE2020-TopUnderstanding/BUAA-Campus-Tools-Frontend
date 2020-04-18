import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/HomePage.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("登录"),
        backgroundColor: Colors.lightBlue,
      ),
      body: new LoginPageBody(),
    );
  }
}

class LoginPageBody extends StatefulWidget {
  @override
  _LoginPageStateBody createState() {
    return _LoginPageStateBody();
  }
}

class _LoginPageStateBody extends State<LoginPageBody> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Center(
      child: new Container(
        child: SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              SizedBox(height: 0),
              new InputIDWidget(),
              SizedBox(
                height: 20,
              ),
              new InputPassWordWidget(),
              SizedBox(
                height: 50,
              ),
              new LoginButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class InputIDWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new SizedBox(
      width: 350.0,
      child: new Container(
        padding: EdgeInsets.fromLTRB(20, 2, 8, 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.black12,
        ),
        alignment: Alignment.center,
        child: TextField(
          maxLines: 1,
          decoration: InputDecoration(
            hintText: '统一认证账号',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

//输入密码
class InputPassWordWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new SizedBox(
      width: 350.0,
      child: new Container(
        padding: EdgeInsets.fromLTRB(20, 2, 8, 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.black12,
        ),
        alignment: Alignment.center,
        child: TextField(
          maxLines: 1,
          decoration: InputDecoration(
            hintText: '密码',
            border: InputBorder.none,
          ),
          obscureText: true,
        ),
      ),
    );
  }
}

//登录按钮
class LoginButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new SizedBox(
      width: 200.0,
      height: 50.0,
      child: new RaisedButton(
        color: Colors.lightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Text(
          '登录',
          textAlign: TextAlign.center,
          style: TextStyle(
              letterSpacing: 20,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black54),
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyHomePage()));
        },
      ),
    );
  }
}
