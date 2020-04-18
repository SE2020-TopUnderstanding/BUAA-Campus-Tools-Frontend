import 'dart:convert';
import 'package:jiaowuassistent/GlobalUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/FirstPage.dart';
import 'package:jiaowuassistent/pages/HomePage.dart';
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';

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

  String userName;
  String password;
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  bool showPassword = false;//是否明文显示密码
  bool _userNameFocus = true;//焦点是否在账号输入框
  GlobalKey _formkey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(50),
          child: SingleChildScrollView(
            child:Form(
              key: _formkey,
              autovalidate: false,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    autofocus: _userNameFocus,
                    controller: _userNameController,
                    validator: (v) => v.trim().isNotEmpty?Null:'请输入统一认证账号',
                    decoration: InputDecoration(
                      hintText: '统一认证账号',
                      //labelText: userName,
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    autofocus: !_userNameFocus,
                    controller: _passwordController,
                    obscureText: !showPassword,
                    validator: (v) => v.trim().isNotEmpty?Null:'请输入密码',
                    decoration: InputDecoration(
                      hintText: '密码',
                      //labelText: password,
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon:Icon(showPassword?Icons.visibility:Icons.visibility_off),
                        onPressed: (){
                          setState(() {
                            showPassword = !showPassword;

                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 50, 50, 0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints.expand(height: 50),
                      child: RaisedButton(
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
                          _login();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }

  void _login() async {
    //if((_formkey.currentState as FormState).validate()){
    //}
    if(_userNameController.text.isEmpty||_passwordController.text.isEmpty){
      print('账号或密码为空，请继续输入');
    }else{
      //Url请求
      BaseOptions options = new BaseOptions(
          //baseUrl: 'http://114.115.208.32:8000',
          connectTimeout: 50000,
          receiveTimeout: 3000,
          //contentType: "applicatio/json",
      );
      Dio dio = new Dio(options);
      try{
        Response response;
        response = await dio.request(
            'http://114.115.208.32:8000/login/',
            data: {"usr_name":_userNameController.text, "usr_password":_passwordController.text},
            options:Options(method: "POST", responseType: ResponseType.json));
        print(response.data);
        int state = response.data['state'];
        if(state != 1){
          throw '账号或密码错误';
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
      }catch(e){
        print(e.toString());
      }
    }
  }
}
