import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/CourseTablePage.dart';
import 'package:jiaowuassistent/pages/FirstPage.dart';
import 'package:jiaowuassistent/pages/FunctionsPage.dart';
import 'package:jiaowuassistent/pages/Person.dart';

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

  void _pageChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new PageView(
        onPageChanged: _pageChange,
        children: <Widget>[
          FirstPage(),
          //CourseTablePage(),
          FunctionsPage(),
          PersonPage(),
        ],
        controller: _controller,
//        onPageChanged: onPageChanged,
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

  void onTap(int index) {
    _controller.jumpToPage(index);
    setState(() {
      _currentIndex = index;
    });
  }
}
