import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
class GlobalUser {
  static SharedPreferences _sp;
  static bool _isFirst = true;
  static bool _isLogin = false;
  /*sp中需要保存的用户信息
  static String account;//统一认证账号
  static String password;//密码
  static String name;
  static String studentID;//学号
  static int choice = 1;//主页选择,1课表，2成绩,3课程中心,默认课表
   */
  static init() async{
    _sp = await SharedPreferences.getInstance();
  }

  //是否首次使用APP
  static setIsFirst(bool value) async{
    _sp.setBool('isFirst', value);
  }
  static bool get isFirst {
    return _sp.getBool('isFirst') ?? _isFirst;
  }

  //是否登陆
  static setIsLogin(bool value) async {
    _sp.setBool('isLogin', value);
  }
  static bool get isLogin {
    return _sp.getBool('isLogin') ?? _isLogin;
  }

  //登录时，记录用户信息
  static setUser(String accountValue, String passwordValue, String nameValue, String studentIDValue) async{
    _sp.setString('account', accountValue);
    _sp.setString('password', passwordValue);
    _sp.setString('name', nameValue);
    _sp.setString('studentID', studentIDValue);
    _sp.setInt('pageChoice', 1);//默认课表
  }
  //更改默认主页
  static setChoice(int type) async{
    _sp.setInt('pageChoice', type);
  }

  static String get account{
    return _sp.getString('account');
  }
  static String get password{
    return _sp.getString('password');
  }
  static String get name{
    return _sp.getString('name');
  }
  static String get studentID{
    return _sp.getString('studentID');
  }
  static int get pageChoice{
    return _sp.getInt('pageChoice');
  }

}

class PageSelect with ChangeNotifier{
  int _choice = 1;
  void setPage(int type){
    _choice = type;
    GlobalUser.setChoice(type);
    notifyListeners();
  }
  get choice => _choice;
}