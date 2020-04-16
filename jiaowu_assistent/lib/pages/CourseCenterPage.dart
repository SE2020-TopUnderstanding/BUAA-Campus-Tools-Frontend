import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class CourseCenterPage extends StatefulWidget {
  @override
  _CourseCenterPageState createState() => _CourseCenterPageState();
}

class _CourseCenterPageState extends State<CourseCenterPage> {
  List<int> mList; //组成一个int类型数组，用来控制索引
  List<ExpandStateBean> courseList;

  _CourseCenterPageState() {
    mList = new List();
    courseList = new List();
    //遍历两个List进行赋值
    for (int i = 0; i < 5; i++) {
      mList.add(i);
      courseList.add(ExpandStateBean(i, false)); //item初始状态为闭着的
    }
  }

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
                    title: Text('课程$index'),
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
                        DataColumn(
                          label: Text('剩余时间',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                      rows: [
                        DataRow(
                          cells: [
                            DataCell(
                              Icon(Icons.done_all),
                            ),
                            DataCell(
                              Text(
                                '作业$index',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(
                                '2020.4.15 20:00',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(
                                '已完成',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(
                              Icon(Icons.timelapse),
                            ),
                            DataCell(
                              Text(
                                '作业$index',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(
                                '2020.4.18 24:00',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(
                              Text(
                                '4h35min',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )
                      ],
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
