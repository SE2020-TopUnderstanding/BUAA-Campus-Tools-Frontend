import 'dart:convert';
import 'dart:io';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:jiaowuassistent/pages/User.dart';

class CourseCenterPage extends StatefulWidget {
  @override
  _CourseCenterPageState createState() => _CourseCenterPageState();
}

class _CourseCenterPageState extends State<CourseCenterPage> {
  Future<CourseCenter> courseCenter;

  @override
  initState() {
    super.initState();
    courseCenter = loadCourseCenter();
  }

  //修改展开与闭合的内部方法
  _setCurrentIndex(List<ExpandStateBean> courseList, int index, isExpand) {
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

  _getDataRows(Course course) {
    List<DataRow> dataRows = [];
    var now = DateTime.now();
    for (int i = 0; i < course.content.length; i++) {
//      var time = DateTime.parse(course.content[i].time);
      var time = DateTime.parse("2020-04-20 19:00:00");
      var duration = time.difference(now);
      dataRows.add(DataRow(
        cells: [
          DataCell(
            course.content[i].status == '已提交'
                ? Icon(Icons.done_all)
                : Text('剩${duration.inHours.toString()}h'),
          ),
          DataCell(Text(
            '${course.content[i].text}',
            textAlign: TextAlign.center,
          )),
          DataCell(Text(
            '${course.content[i].time}',
            textAlign: TextAlign.center,
          )),
        ],
      ));
    }
    return dataRows;
  }

  List<int> mList = []; //组成一个int类型数组，用来控制索引
  List<ExpandStateBean> courseList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("课程中心DDL"),
      ),
      //加入可滚动组件(ExpansionPanelList必须使用可滚动的组件)
      body: FutureBuilder<CourseCenter>(
          future: courseCenter,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              for (int i = 0; i < snapshot.data.courses.length; i++) {
                if (!mList.contains(i)) {
                  mList.add(i);
                  courseList.add(ExpandStateBean(i, true)); //item初始状态为闭着的
                }
              }
              return SingleChildScrollView(
                child: ExpansionPanelList(
                  //交互回调属性，里面是个匿名函数
                  expansionCallback: (index, bol) {
                    //调用内部方法
                    _setCurrentIndex(courseList, index, bol);
                  },
                  //进行map操作，然后用toList再次组成List
                  children: mList.map((index) {
                    //返回一个组成的ExpansionPanel
                    return ExpansionPanel(
                        headerBuilder: (context, isExpanded) {
                          return ListTile(
                            title: Text('${snapshot.data.courses[index].name}'),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: Text('作业内容',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                DataColumn(
                                  label: Text('DeadLine',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                              rows: _getDataRows(snapshot.data.courses[index]),
                            ),
                          ),
                        ),
                        isExpanded: courseList[index].isOpen);
                  }).toList(),
                ),
              );
            } else {
              return Container(
                  alignment: Alignment(0.0, -0.2),
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                  ));
            }
          }),
    );
  }
}

//list中item状态自定义类
class ExpandStateBean {
  var isOpen; //item是否打开
  var index; //item中的索引
  ExpandStateBean(this.index, this.isOpen);
}
