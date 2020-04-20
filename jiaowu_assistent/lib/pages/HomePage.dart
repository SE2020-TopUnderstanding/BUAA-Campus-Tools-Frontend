import 'package:jiaowuassistent/Pages/PersonalPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/CourseTablePage.dart';
import 'package:jiaowuassistent/pages/FirstPage.dart';
import 'package:jiaowuassistent/pages/FunctionsPage.dart';

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

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new PageView(
        children: <Widget>[
          //FirstPage(),
          CourseTablePage(),
          FunctionsPage(),
          PersonalPage(),
        ],
        controller: _controller,
//        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: new BottomNavigationBar(
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
            title: Text("课表"),
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
            title: Text("分类"),
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
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void onTap(int index) {
    _controller.jumpToPage(index);
    setState(() {
      _currentIndex = index;
    });
  }
}
