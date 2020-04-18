import 'dart:convert';
import 'dart:io';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CourseCenterPage extends StatefulWidget {
  @override
  _CourseCenterPageState createState() => _CourseCenterPageState();
}

//Map<String, List<Map>> courseData = {
//  "计网": [
//    {"ddl": "2020-04-14 17:00:00", "homework": "团队作业", "state": "已提交"}
//  ],
//  "软工": [
//    {"ddl": "2020-04-22 22:00:00", "homework": "最后一次作业", "state": "未提交"},
//    {"ddl": "2020-04-19 22:00:00", "homework": "团队作业", "state": "未提交"},
//    {"ddl": "2020-04-17 20:00:00", "homework": "团队作业", "state": "已提交"},
//    {"ddl": "2020-04-14 24:00:00", "homework": "个人作业", "state": "已提交"},
//  ]
//};

class DDL {
  final String time;
  final String text;
  final String status;

  DDL({this.time, this.text, this.status});

  factory DDL.fromJson(Map<String, dynamic> parsedJson) {
    return DDL(
        time: parsedJson['ddl'],
        text: parsedJson['homework'],
        status: parsedJson['state']);
  }
}

class Course {
  final String name;
  final List<DDL> content;

  Course({this.name, this.content});

  factory Course.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['content'] as List;
    print(list.runtimeType);
    List<DDL> ddlList = list.map((i) => DDL.fromJson(i)).toList();

    return Course(name: parsedJson['name'], content: ddlList);
  }
}

class CourseCenter {
  final List<Course> courses;

  CourseCenter({this.courses});

  factory CourseCenter.fromJson(List<dynamic> parsedJson) {
    List<Course> courseCenterList =
        parsedJson.map((i) => Course.fromJson(i)).toList();
    return CourseCenter(courses: courseCenterList);
  }
}

Future<CourseCenter> loadCourseCenter() async {
  final response =
      await http.get('http://114.115.208.32:8000/ddl/?student_id=17373349');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return CourseCenter.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load course center');
  }
}

class _CourseCenterPageState extends State<CourseCenterPage> {
  List<int> mList; //组成一个int类型数组，用来控制索引
  CourseCenter courseCenter;
  List<ExpandStateBean> courseList;

  _CourseCenterPageState() {}

  //修改展开与闭合的内部方法
  _setCurrentIndex(int index, isExpand) {
    setState(() {
      //遍历可展开状态列表
      courseList.forEach((item) {
        if (item.index == index) {
          //取反，经典取反方法
          item.isOpen = !isExpand;
        }
      });
    });
  }

  _getDataRows(int index) {
    List<DataRow> dataRows = [];
    var now = DateTime.now();
    for (int i = 0; i < courseCenter.courses[index].content.length; i++) {
      var time = DateTime.parse(courseCenter.courses[index].content[i].time);
      var duration = time.difference(now);
      dataRows.add(DataRow(
        cells: [
          DataCell(
            courseCenter.courses[index].content[i].status == '已提交'
                ? Icon(Icons.done_all)
                : Text('剩${duration.inHours.toString()}h'),
          ),
          DataCell(Text(
            '${courseCenter.courses[index].content[i].text}',
            textAlign: TextAlign.center,
          )),
          DataCell(Text(
            '${courseCenter.courses[index].content[i].time}',
            textAlign: TextAlign.center,
          )),
//          DataCell(Text(
//            '${courses[index].deadLine[i].status}',
//            textAlign: TextAlign.center,
//          )),
        ],
      ));
    }
    return dataRows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("课程中心DDL"),
      ),
      //加入可滚动组件(ExpansionPanelList必须使用可滚动的组件)
      body: SingleChildScrollView(
        child: ExpansionPanelList(
          //交互回调属性，里面是个匿名函数
          expansionCallback: (index, bol) {
            //调用内部方法
            _setCurrentIndex(index, bol);
          },
          //进行map操作，然后用toList再次组成List
          children: mList.map((index) {
            //返回一个组成的ExpansionPanel
            return ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    title: Text('${courseCenter.courses[index].name}'),
                  );
                },
                body: Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(
                          label: Text('状态',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('作业内容',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        DataColumn(
                          label: Text('DeadLine',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                      rows: _getDataRows(index),
                    ),
                  ),
                ),
                isExpanded: courseList[index].isOpen);
          }).toList(),
        ),
      ),
    );
  }
}

//list中item状态自定义类
class ExpandStateBean {
  var isOpen; //item是否打开
  var index; //item中的索引
  ExpandStateBean(this.index, this.isOpen);
}
