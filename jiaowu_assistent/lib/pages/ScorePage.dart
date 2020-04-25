import 'dart:async' show Future;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:jiaowuassistent/pages/User.dart';
import 'package:jiaowuassistent/GlobalUser.dart';

class ScorePage extends StatefulWidget {
  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  GradeCenter gradeCenter;
  var semester = 7;

  Map<int, String> semesterMap = {
    1: "2016秋季",
    2: "2017春季",
    3: "2017秋季",
    4: "2018春季",
    5: "2018秋季",
    6: "2019春季",
    7: "2019秋季",
    8: "2020春季",
  };

  List<DropdownMenuItem> semesterList = [
    DropdownMenuItem(
      child: Text('2016秋季'),
      value: 1,
    ),
    DropdownMenuItem(
      child: Text('2017春季'),
      value: 2,
    ),
    DropdownMenuItem(
      child: Text('2017秋季'),
      value: 3,
    ),
    DropdownMenuItem(
      child: Text('2018春季'),
      value: 4,
    ),
    DropdownMenuItem(
      child: Text('2018秋季'),
      value: 5,
    ),
    DropdownMenuItem(
      child: Text('2019春季'),
      value: 6,
    ),
    DropdownMenuItem(
      child: Text('2019秋季'),
      value: 7,
    ),
    DropdownMenuItem(
      child: Text('2020春季'),
      value: 8,
    ),
  ];

  @override
  initState() {
    super.initState();
    searchGrade();
  }

  Future<void> searchGrade() async {
    try {
      getGrade(GlobalUser.studentID, semesterMap[semester])
          .then((GradeCenter temp) {
        setState(() {
          gradeCenter = temp;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('成绩查询'),
        backgroundColor: Colors.lightBlue,
      ),
      body: gradeCenter == null
          ? Container(
              alignment: Alignment(0.0, 0.0),
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
              ))
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(left: 30.0),
                          child: Text('加权平均分： ${gradeCenter.averageScore}',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 30.0),
                          child: Text('GPA： ${gradeCenter.gpa}',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: DropdownButton(
                        value: semester,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 30,
                        iconEnabledColor: Colors.black,
                        hint: Text('请选择学期'),
                        items: semesterList,
                        onChanged: (value) {
                          setState(() {
                            semester = value;
                            searchGrade();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: <Widget>[
                    Container(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: gradeCenter.grades.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: ListTile(
                              title: Text(gradeCenter.grades[index].name),
                              subtitle:
                                  Text('${gradeCenter.grades[index].credit}学分'),
                              trailing:
                                  Text('${gradeCenter.grades[index].score}'),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 30.0),
                            ),
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        width: 1, color: Colors.grey))),
                          );
                        },
                      ),
                    )
                  ],
                )
              ])),
    );
  }
}

class AverageScore extends StatelessWidget {
  Widget build(BuildContext context) {
    return new SizedBox(
      width: 200.0,
      height: 50.0,
    );
  }
}
