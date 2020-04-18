import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseCenterPage extends StatefulWidget {
  @override
  _CourseCenterPageState createState() => _CourseCenterPageState();
}

Map<String, List<Map>> courseData = {
  "计网": [
    {"ddl": "2010-10-11", "homework": "团队作业", "state": "已提交"}
  ],
  "软工": [
    {"ddl": "2010-10-9", "homework": "团队作业", "state": "已提交"},
    {"ddl": "2010-10-10", "homework": "个人作业", "state": "已提交"},
    {"ddl": "2010-10-12", "homework": "最后一次作业", "state": "未提交"},
    {"ddl": "2010-10-13", "homework": "团队作业", "state": "未提交"}
  ]
};

class DDL {
  String time;
  String text;
  String status;

  DDL(String time, String text, String status) {
    this.time = time;
    this.text = text;
    this.status = status;
  }
}

class Course {
  String name;
  List<DDL> deadLine;

  Course(String name) {
    this.name = name;
    this.deadLine = new List();
  }
}

class _CourseCenterPageState extends State<CourseCenterPage> {
  List<int> mList; //组成一个int类型数组，用来控制索引
  List<Course> courses;
  List<ExpandStateBean> courseList;

  _CourseCenterPageState() {
    mList = new List();
    courseList = new List();
    courses = new List();
    //遍历两个List进行赋值
    for (int i = 0; i < courseData.length; i++) {
      mList.add(i);
      courseList.add(ExpandStateBean(i, false)); //item初始状态为闭着的
    }
    courseData.keys.forEach((k) {
      Course c = new Course(k);
      courseData[k].forEach((d) {
        DDL ddl = new DDL(d['ddl'], d['homework'], d['state']);
        c.deadLine.add(ddl);
      });
      courses.add(c);
    });
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

  _getDataRows(int index) {
    List<DataRow> dataRows = [];
    for (int i = 0; i < courses[index].deadLine.length; i++) {
      dataRows.add(DataRow(
        cells: [
          DataCell(
            Icon(courses[index].deadLine[i].status == '已提交'
                ? Icons.done_all
                : Icons.timelapse),
          ),
          DataCell(Text(
            '${courses[index].deadLine[i].text}',
            textAlign: TextAlign.center,
          )),
          DataCell(Text(
            '${courses[index].deadLine[i].time}',
            textAlign: TextAlign.center,
          )),
          DataCell(Text(
            '${courses[index].deadLine[i].status}',
            textAlign: TextAlign.center,
          )),
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
                    title: Text('${courses[index].name}'),
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
