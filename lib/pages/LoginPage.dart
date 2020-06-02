import 'package:jiaowuassistent/GlobalUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:jiaowuassistent/encrypt.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: new Text("登录", style: TextStyle(color: Colors.grey[100])),
//        backgroundColor: Colors.lightBlue,
      ),
      backgroundColor: Colors.grey[100],
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
  bool showPassword = false; //是否明文显示密码
//  bool _autoUserNameFocus = true;//焦点是否在账号密码输入框
  GlobalKey _formkey = new GlobalKey<FormState>();
  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePassword = new FocusNode();

  CancelToken _cancel = new CancelToken();

  @override
  void initState() {
    _focusNodeUserName.addListener(_focusNodeListener);
    _focusNodePassword.addListener(_focusNodeListener);
    GlobalUser.setIsFirst(false);
    super.initState();
  }

  Future<Null> _focusNodeListener() async {
    if (_focusNodeUserName.hasFocus) {
      _focusNodePassword.unfocus();
    }
    if (_focusNodePassword.hasFocus) {
      _focusNodeUserName.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNodeUserName.unfocus();
        _focusNodePassword.unfocus();
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            autovalidate: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(
                  "assets/images/hangxu2.jpg",
                  width: 100.0,
                  height: 100.0,
                ),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  //  autofocus: _autoUserNameFocus,
                  focusNode: _focusNodeUserName,
                  controller: _userNameController,
                  validator: (v) => v.trim().isNotEmpty ? Null : '请输入统一认证账号',
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
                  focusNode: _focusNodePassword,
                  controller: _passwordController,
                  obscureText: !showPassword,
                  validator: (v) => v.trim().isNotEmpty ? Null : '请输入密码',
                  decoration: InputDecoration(
                    hintText: '密码',
                    //labelText: password,
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(showPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
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
                      color: Color(0xFF1565C0),
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
                            color: Colors.white),
                      ),
                      onPressed: () {
                        _login();
                      },
                      disabledColor: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text("您的账户密码在传输过程中已被加密保护\n目前仅支持北航本科生使用",
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w100,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (_userNameController.text.isEmpty || _passwordController.text.isEmpty) {
      print('账号或密码为空，请继续输入');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: Text(
                '报错',
                textAlign: TextAlign.center,
              ),
              children: <Widget>[
                Text(
                  '请将账号密码填写完整',
                  textAlign: TextAlign.center,
                ),
              ],
            );
          });
    } else {
      //Url请求
      BaseOptions options = new BaseOptions(
        connectTimeout: 30000,
        sendTimeout: 30000,
        receiveTimeout: 30000,
      );
      Response response;
      Dio dio = new Dio(options);
      try {
        showLoading(context);
        response = await dio.request('http://114.115.208.32:8000/login/',
            data: {
              "usr_name": _userNameController.text,
              "usr_password": Encrypt.encrypt2(_passwordController.text)
            },
            options: Options(method: "POST", responseType: ResponseType.json),
            cancelToken: _cancel);
        print('response end');
        Navigator.of(context).pop();
        //保存用户信息
        GlobalUser.setUser(_userNameController.text, _passwordController.text,
            response.data['name'], response.data['student_id']);

        //  GlobalUser.setUser(_userNameController.text, _passwordController.text, "张艺璇", "17373182");
        GlobalUser.setIsLogin(true);
        GlobalUser.setChoice(1); //默认课表
        //切换页面
        Navigator.pushReplacementNamed(context, '/homePage');
      } on DioError catch (e) {
        print("error type:${e.type},${e.response.statusCode}");
        Navigator.of(context).pop();
        if ((e.type == DioErrorType.CONNECT_TIMEOUT) ||
            (e.type == DioErrorType.RECEIVE_TIMEOUT) ||
            (e.type == DioErrorType.SEND_TIMEOUT)) {
          showError(context, "网络请求超时");
        } else if (e.type == DioErrorType.RESPONSE) {
          if (e.response.statusCode == 401) {
            showError(context, "账号或密码错误");
          } else if (e.response.statusCode == 460) {
            showError(context, "您的账号被锁定，请十分钟后再试");
          } else if (e.response.statusCode == 462) {
            showError(context, "服务器出问题了，过会儿再试吧");
          } else {
            showError(context, "服务器错误");
          }
        } else if (e.type == DioErrorType.CANCEL) {
          showError(context, "请求取消");
        } else {
          showError(context, "未知错误");
        }
      }
    }
  }

  void showError(context, String str) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            titlePadding: EdgeInsets.fromLTRB(24.0, 14.0, 24.0, 0.0),
            title: Text(
              '错  误',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              Text(
                str,
                textAlign: TextAlign.center,
              ),
            ],
          );
        });
  }

  void showLoading(context, [String text]) {
    text = text ?? "Loading...";
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3.0),
                    boxShadow: [
                      //阴影
                      BoxShadow(
                        color: Colors.black12,
                        //offset: Offset(2.0,2.0),
                        blurRadius: 10.0,
                      )
                    ]),
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.all(16),
                constraints: BoxConstraints(minHeight: 120, minWidth: 180),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        text,
                        style: Theme.of(context).textTheme.body2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onWillPop: () {
              return new Future.value(false);
            },
          );
        });
  }
}
