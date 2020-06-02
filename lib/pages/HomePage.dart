import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/FirstPage.dart';
import 'package:jiaowuassistent/pages/FunctionsPage.dart';
import 'package:jiaowuassistent/pages/Person.dart';
import 'package:jiaowuassistent/pages/User.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _bottomNavigationColor = Colors.grey[400];
  final _bottomNavigationSelectColor = Colors.black;
  var _controller = PageController(
    initialPage: 0,
  );
  int _currentIndex = 0;
  UpdateInfo remoteInfo;
  static int isUpdate = 1;

  @override
  void initState() {
    super.initState();
    // 检查更新
    check(showInstallUpdateDialog);
  }

  check(Function showDialog) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    remoteInfo = await getUpdateInfo();
    print(packageInfo.version);
    print(remoteInfo.version);
    if (packageInfo.version.hashCode == remoteInfo.version.hashCode) {
      print('无新版本');
      setState(() {
        isUpdate = 0;
      });
      return;
    }
    print('有新版本');
    showInstallUpdateDialog();
  }

  launchURL() {
    launch(remoteInfo.address);
  }

  void showInstallUpdateDialog() {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
                      child: Text(
                        '航胥 v${remoteInfo.version} 版本更新',
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        '更新日期：${remoteInfo.date}',
                        style: Theme.of(context).textTheme.body2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        '更新内容：${remoteInfo.info}',
                        style: Theme.of(context).textTheme.body2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: MaterialButton(
                        color: Color(0x99FFFFFF),
                        onPressed: launchURL,
                        minWidth: double.infinity,
                        child: Text(
                          '点击下载',
                          style: Theme.of(context).textTheme.body2,
                        ),
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

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _pageChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isUpdate != 0) {
      return new Scaffold();
    } else {
      return new Scaffold(
        body: PageView(
          onPageChanged: _pageChange,
          children: <Widget>[
            FirstPage(),
            //CourseTablePage(),
            FunctionsPage(),
            PersonPage(),
          ],
          controller: _controller,
          // onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: new BottomNavigationBar(
          selectedItemColor: Colors.grey,
          type: BottomNavigationBarType.shifting,
          items: [
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.date_range,
                color: _bottomNavigationSelectColor,
              ),
              icon: Icon(
                Icons.date_range,
                color: _bottomNavigationColor,
              ),
              title: Text("主页"),
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.list,
                color: _bottomNavigationSelectColor,
              ),
              icon: Icon(
                Icons.list,
                color: _bottomNavigationColor,
              ),
              title: Text("功能"),
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.person,
                color: _bottomNavigationSelectColor,
              ),
              icon: Icon(
                Icons.person,
                color: _bottomNavigationColor,
              ),
              title: Text("个人中心"),
            ),
          ],
          onTap: onTap,
          currentIndex: _currentIndex,
        ),
      );
    }
  }

  void onTap(int index) {
    _controller.jumpToPage(index);
    setState(() {
      _currentIndex = index;
    });
  }
}
