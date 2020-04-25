import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:jiaowuassistent/pages/User.dart';
import 'dart:math';
import 'package:jiaowuassistent/GlobalUser.dart';

class ShareWeekWidget extends InheritedWidget {
  //跨组件共享指定week和当前week
  ShareWeekWidget({
    @required this.week,
    @required this.curWeek,
    Widget child,
  }) : super(child: child);

  final int week;
  final int curWeek;

  static ShareWeekWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(ShareWeekWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return ((oldWidget.week != week) || (oldWidget.curWeek != curWeek));
  }
}

class CourseTablePage extends StatefulWidget {
  @override
  _CourseTablePage createState() => _CourseTablePage();
}

class _CourseTablePage extends State<CourseTablePage> {
  int week_value;
  int cur_week_value;

  List<DropdownMenuItem> getWeekItem() {
    List<DropdownMenuItem> weekItems = [
      DropdownMenuItem(
        child: Text('第1周'),
        value: 1,
      ),
      DropdownMenuItem(
        child: Text('第2周'),
        value: 2,
      ),
      DropdownMenuItem(
        child: Text('第3周'),
        value: 3,
      ),
      DropdownMenuItem(
        child: Text('第4周'),
        value: 4,
      ),
      DropdownMenuItem(
        child: Text('第5周'),
        value: 5,
      ),
      DropdownMenuItem(
        child: Text('第6周'),
        value: 6,
      ),
      DropdownMenuItem(
        child: Text('第7周'),
        value: 7,
      ),
      DropdownMenuItem(
        child: Text('第8周'),
        value: 8,
      ),
      DropdownMenuItem(
        child: Text('第9周'),
        value: 9,
      ),
      DropdownMenuItem(
        child: Text('第10周'),
        value: 10,
      ),
      DropdownMenuItem(
        child: Text('第11周'),
        value: 11,
      ),
      DropdownMenuItem(
        child: Text('第12周'),
        value: 12,
      ),
      DropdownMenuItem(
        child: Text('第13周'),
        value: 13,
      ),
      DropdownMenuItem(
        child: Text('第14周'),
        value: 14,
      ),
      DropdownMenuItem(
        child: Text('第15周'),
        value: 15,
      ),
      DropdownMenuItem(
        child: Text('第16周'),
        value: 16,
      ),
      DropdownMenuItem(
        child: Text('第17周'),
        value: 17,
      ),
      DropdownMenuItem(
        child: Text('第18周'),
        value: 18,
      ),
      DropdownMenuItem(
        child: Text('第19周'),
        value: 19,
      ),
    ];
    return weekItems;
  }

  @override
  void initState() {
    // TODO: implement initState
    //print('course table init');
    getWeek().then((value) {
      setState(() {
        week_value = value;
        cur_week_value = value;
        //print('set cur week:$week_value');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ShareWeekWidget(
      week: week_value,
      curWeek: cur_week_value,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text('课程表'),
          actions: <Widget>[
            DropdownButton(
              value: week_value,
              hint: Text('第$week_value周'),
              items: getWeekItem(),
              onChanged: (_value) {
                setState(() {
                  week_value = _value;
                });
              },
              iconSize: 20,
            ),
            //IconButton(icon: Icon(Icons.refresh), onPressed: null,),暂不支持手动刷新
          ],
        ),
        body:  CourseGridTable(),

      ),
    );
  }
}

class CourseGridTable extends StatefulWidget {
  @override
  _CourseGridTable createState() => _CourseGridTable();
}

class _CourseGridTable extends State {
  int week;
  int cur_week;

  //Future<WeekCourseTable> courseList;
  final double blockHeight = 60;
  List<CourseT> courses = new List<CourseT>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    week = ShareWeekWidget.of(context).week;
    cur_week = ShareWeekWidget.of(context).curWeek;

    super.didChangeDependencies();
    //print('didChangeDependencies:$week');
  }

  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    // TODO: implement didUpdateWidget
    //print('didUpdateWidget:$week');
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    //print('build:$week');
    // TODO: implement build
    return Center(
      child: FutureBuilder(
          future: loadCourse(week, GlobalUser.studentID),
          builder: (BuildContext context, AsyncSnapshot snapshot) {

            if ((snapshot.connectionState == ConnectionState.done)
                  &&(snapshot.hasData)) {
              if (snapshot.data.courses.length == 0){
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "正在获取您的数据\n请稍后再试",
                        style: TextStyle(fontSize: 24,),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 50,),
                      Text(
                        "如果您本学期没有课程\n请忽略上述提示\n因为此时我们不再提供课表查询功能~",
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                );
              }
              courses.clear();
              for (int i = 0; i < snapshot.data.courses.length; i++) {
                courses.add(snapshot.data.courses[i]);
              }
              return Stack(
                children: <Widget>[
                  WeekBar(
                    //(DateTime.now().add(Duration(days: (week-cur_week)*7))),
                    DateTime.now(),
                    color: Colors.white,
                    height: blockHeight,
                  ),
                  buildBlocks(),
                ],
              );
            } else {
              if(snapshot.hasError){
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    "网络请求出错\n请稍后再试\n",
                    style: TextStyle(fontSize: 24,),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                  ));
            }
          }),
    );
  }

  List<Color> _tableColors = [
    Colors.brown,
    Colors.deepOrange,
    Colors.blue,
    Colors.red[500],
    Colors.green,
    Colors.pink,
    Colors.deepPurple[200],
    Colors.blueGrey,
    Colors.yellow[800],
  ];

  List<String> _beginTime = [
    '8:00',
    '8:50',
    '9:50',
    '10:40',
    '11:30',
    '14:00',
    '14:50',
    '15:50',
    '16:40',
    '17:30',
    '19:00',
    '19:50',
    '20:40',
    '21:30'
  ];

  // 左边显示节数的列
  Widget buildLeftColumn() {
    return Column(
      children: List<Widget>.generate(
        14,
        (index) => Container(
          width: 40,
          height: blockHeight,
          color: Colors.white,
          child: Center(
            child: Text('${_beginTime[index]}\n${index + 1}',
              softWrap: true,
              textAlign: TextAlign.center,),
          ),
        ),
      ),
    );
  }

  // 中间的所有列
  List<Widget> buildMainColumns() {
    Iterable<CourseT> weekcourses =
        courses.where((c) => c.week.contains(week.toString())); //当周的课

    return List<Widget>.generate(7, (index) {
      Iterable<CourseT> day =
          weekcourses.where((c) => c.weekDay == index + 1); // 当天的课

      List<Widget> cols = new List();
      for (int i = 1; i <= 14; i++) {
        Iterable<CourseT> section =
            day.where((c) => c.sectionStart == i); //当节的课
        List<CourseT> sectionList = section.toList();
        // 没找到就用空块填充
        if (sectionList.length == 0) {
          cols.add(WhiteBlock(blockHeight));
          continue;
        }
        //找到当节开始的课
        int maxLength = 0;
        int last = i; //结束时间
        for (CourseT temp in sectionList) {
          int length = temp.sectionEnd - temp.sectionStart;
          if (length > maxLength) {
            maxLength = length;
            last = temp.sectionEnd;
          }
        }
        for (CourseT temp in day) {
          if (temp.sectionStart > i && temp.sectionStart <= last) {
            sectionList.add(temp);
          }
        }
        if (maxLength >= 0 && maxLength < 14) {
          cols.add(
            CourseBlock(
              sectionList,
              size: maxLength + 1,
              height: blockHeight,
//              backgroundColor: _tableColors[Random().nextInt(_tableColors.length)],
              backgroundColor: _tableColors[sectionList.first.color%_tableColors.length],
              textColor: Colors.white,
              onTap: () => onTap(sectionList),
            ),
          );
          i += maxLength;
        } else {
          cols.add(WhiteBlock(blockHeight));
        }
      }
      return Expanded(
        child: Column(
          children: cols,
        ),
      );
    });
  }

  Widget buildBlocks() {
    return Container(
      padding: EdgeInsets.only(top: blockHeight),
      child: SingleChildScrollView(
        child: Row(
          children: <Widget>[
            buildLeftColumn(),
          ]..addAll(buildMainColumns()),
        ),
      ),
    );
  }

  List<Widget> showCourse(List<CourseT> templist) {
    List<Widget> l = new List();
    for (int i = 0; i < templist.length; i++) {
      CourseT temp = templist[i];
      l.add(ListTile(
        leading: Text("课程："),
        title: Text(temp.name),
      ));
      l.add(ListTile(
          leading: Text("时间："),
          title: Text('第${temp.sectionStart}-${temp.sectionEnd}节')));
      l.add(ListTile(leading: Text("地点："), title: Text('${temp.location}')));
      l.add(ListTile(
          leading: Text("教师："), title: Text(temp.teacherCourse.toString())));
      l.add(Divider(height: 1.0, indent: 0.0, color: Colors.black87));
    }
    l.removeLast();
    return l;
  }

  onTap(List<CourseT> course) {
    showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: Text(
            '查看',
            textAlign: TextAlign.center,
          ),
          titlePadding: EdgeInsets.all(10),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[]..addAll(showCourse(course)),
              ),
            ),
          ],
        );
      },
    );
  }
}

class WeekBar extends StatelessWidget {
  final Color color;
  final DateTime now;
  final double height;

  WeekBar(this.now, {this.color = Colors.white, this.height = 60});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: color,
        child: Row(
          children: <Widget>[
            buildMonth(),
            buildWeek(1),
            buildWeek(2),
            buildWeek(3),
            buildWeek(4),
            buildWeek(5),
            buildWeek(6),
            buildWeek(7),
          ],
        ),
      ),
    );
  }

  Widget buildMonth() {
    return Container(
      width: 30,
      height: height,
    );
  }

  final weekText = [
    '周一',
    '周二',
    '周三',
    '周四',
    '周五',
    '周六',
    '周日',
  ];

  Widget buildWeek(int weekDay) {
    DateTime dateTime = now.add(Duration(days: -now.weekday + weekDay));
    int month = dateTime.month;
    int day = dateTime.day;

    return Expanded(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              weekText[weekDay - 1],
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            //Text('$month/$day', style: TextStyle(fontSize: 10),),
          ],
        ),
      ),
      flex: 1,
    );
  }
}

class WhiteBlock extends StatelessWidget {
  final double height;

  WhiteBlock(this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[200],
            width: 0.5,
          ),
        ),
      ),
    );
  }
}

class CourseBlock extends StatelessWidget {
  final List<CourseT> course;
  final Color backgroundColor;
  final Color textColor;
  final int size;
  final double height;
  final onTap;

  CourseBlock(
    this.course, {
    this.backgroundColor = Colors.black12,
    this.textColor = Colors.grey,
    this.size = 1,
    this.height = 60,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height * size,
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: backgroundColor,
//          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: getCourseBlocks(course),
      ),
    );
  }
}

Widget getCourseBlocks(List<CourseT> list) {
  if (list.length == 1) {
    return Text(
      '${list.first.name}@${list.first.location}',
      style: TextStyle(color: Colors.white),
    );
  } else {
    return Text(
      '多节课，请点开查看',
      style: TextStyle(color: Colors.white),
    );
  }
}
