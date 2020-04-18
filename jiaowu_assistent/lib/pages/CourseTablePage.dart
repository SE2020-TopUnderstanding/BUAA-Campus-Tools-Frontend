import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';

class Course {
  int ID;
  String name;
  String location;
  String teacher;
  List<int> week;
  int weekDay;
  int sectionStart;
  int sectionEnd;
  String semester;

  Course({
    this.ID,
    this.name,
    this.location,
    this.teacher,
    this.week,
    this.weekDay,
    this.sectionStart,
    this.sectionEnd,
    this.semester,
  });
}

class ShareWeekWidget extends InheritedWidget {
  ShareWeekWidget({
   @required  this.week,
    Widget child,
  }):super(child:child);

  final int week;
  static ShareWeekWidget of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(ShareWeekWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return oldWidget.week != week;
  }
}

class CourseTablePage extends StatefulWidget {
  @override
  _CourseTablePage createState() => _CourseTablePage();
}

class _CourseTablePage extends State<CourseTablePage> {
  int week_value;
  List<DropdownMenuItem> getWeekItem() {
    List<DropdownMenuItem> weekItems = [
      DropdownMenuItem(child: Text('第1周'), value: 1,),
      DropdownMenuItem(child: Text('第2周'), value: 2,),
      DropdownMenuItem(child: Text('第3周'), value: 3,),
      DropdownMenuItem(child: Text('第4周'), value: 4,),
      DropdownMenuItem(child: Text('第5周'), value: 5,),
      DropdownMenuItem(child: Text('第6周'), value: 6,),
      DropdownMenuItem(child: Text('第7周'), value: 7,),
      DropdownMenuItem(child: Text('第8周'), value: 8,),
      DropdownMenuItem(child: Text('第9周'), value: 9,),
      DropdownMenuItem(child: Text('第10周'), value: 10,),
      DropdownMenuItem(child: Text('第11周'), value: 11,),
      DropdownMenuItem(child: Text('第12周'), value: 12,),
      DropdownMenuItem(child: Text('第13周'), value: 13,),
      DropdownMenuItem(child: Text('第14周'), value: 14,),
      DropdownMenuItem(child: Text('第15周'), value: 15,),
      DropdownMenuItem(child: Text('第16周'), value: 16,),
      DropdownMenuItem(child: Text('第17周'), value: 17,),
      DropdownMenuItem(child: Text('第18周'), value: 18,),
      DropdownMenuItem(child: Text('第19周'), value: 19,),
    ];
    return weekItems;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ShareWeekWidget(
      week:week_value,
      child: Scaffold(
          appBar: AppBar(
            title: Text('课程表'),
            actions: <Widget>[
              DropdownButton(
                value: week_value,
                hint: Text('请选择周次'),
                items: getWeekItem(),
                onChanged: (_value){
                  setState(() {
                    week_value = _value;
                  });
                },
                iconSize: 20,
              ),
              IconButton(
                icon: Icon(Icons.refresh), onPressed: null,),
            ],
          ),
          body: SingleChildScrollView(
          //  child: CourseGridTable(),
          ),
        ),
    );
  }
}

class CourseGridTable extends StatefulWidget{
  @override
  _CourseGridTable createState() => _CourseGridTable();
}

class _CourseGridTable extends State{
  int week;
  List<Course> courselist;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: FutureBuilder<List<Course>>(
          future: getCourse(ShareWeekWidget.of(context).week),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              return Stack(
                children: <Widget>[
                  WeekBar(
                    DateTime.now(),
                    color: Colors.white,
                    height: blockHeight,
                  ),
                  buildBlocks(),
                ],
              );
            }else{
              return Text('loading');
            }
          }
      ),
    );
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  final double blockHeight = 60;

  Future<List<Course>> getCourse(int week) async{
    List<Course> courses = [
      Course(
        name: '方法论',
        location: '教1',
        teacher: '阮利',
        week: [1, 2, 3, 4, 5, 6, 7, 8],
        weekDay: 1,
        sectionStart: 3,
        sectionEnd: 4,
      ),
      Course(
        name: '医学伦理',
        location: '教2',
        teacher: '汲婧',
        week: [1, 2, 3, 4, 5, 6, 7, 8],
        weekDay: 4,
        sectionStart: 5,
        sectionEnd: 6,
      ),
      Course(
        name: '计网实验',
        location: '远程',
        teacher: '张力军',
        week: [1, 2, 3, 4, 5, 6, 7, 8],
        weekDay: 1,
        sectionStart: 11,
        sectionEnd: 14,
      ),
    ];
    Dio dio = new Dio();
    try{
      Response response;
      print('test1');
      response = await dio.request('http://127.0.0.1:8000/timetable/',
          data:{"student_id":"17373182","semester":"2020_Spring", "week":"8"},
          options: Options(method: "GET", responseType: ResponseType.json));
      print('test2');
      print(response.data);
    }catch(e){
      e.toString();
    }
    return courses;
  }


  /// 左边显示节数的列
  Widget buildLeftColumn() {
    return Column(
      children: List<Widget>.generate(
          14, (index) => Container(
          width: 30,
          height: blockHeight,
          color: Colors.white,
          child: Center(
            child: Text('${index + 1}'),
          ),
        ),
      ),
    );
  }


  /// 中间的所有列
  List<Widget> buildMainColumns() {
    return List<Widget>.generate(7, (index) {
      // 获取当天的课
      Iterable<Course> day = courselist.where((c) => c.weekDay == index + 1);
      List<Widget> cols = new List();

      // 遍历每天的14节课
      for (int i = 0; i < 14; i++) {
        // 获取课程开始时间等于本节课的课程
        Iterable<Course> courselist = day.where((c) => c.sectionStart == i + 1);
        // 没找到就用空块填充
        if (courselist.length == 0) {
          cols.add(WhiteBlock(blockHeight));
          continue;
        }

        // 获得其中的第一个课
        Course course = courselist.first;
        // 计算块的大小
        int jie = course.sectionEnd - course.sectionStart;
        if (jie >= 0 && jie < 14) {
          cols.add(
            CourseBlock(
              course,
              size: jie + 1,
              height: blockHeight,
              backgroundColor: Color.fromARGB(255, 250, 107, 91),
              textColor: Colors.white,
              onTap: () => onTap(course),
            ),
          );
          i += jie;
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

  onTap(Course course) {
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
            ListTile(
              leading: Text("课程名："),
              title: Text(course.name),
            ),
            ListTile(
              leading: Text("时间："),
              title: Text('星期${course.weekDay}'),
            ),
            ListTile(
              leading: Text("地点："),
              title: Text(course.location),
            ),
            ListTile(
              leading: Text("教师："),
              title: Text(course.teacher),
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
            Text(
              '$month/$day',
              style: TextStyle(fontSize: 10),
            ),
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
  final Course course;
  final Color backgroundColor;
  final Color textColor;
  final int size;
  final double height;
  final onTap;

  CourseBlock(this.course, {
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
        margin: EdgeInsets.all(1),
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Text(
          '${course.name}@${course.teacher}',
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}







