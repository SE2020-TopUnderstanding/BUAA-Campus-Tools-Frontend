import 'dart:async' show Future;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/User.dart';
import 'package:jiaowuassistent/GlobalUser.dart';
import 'package:provider/provider.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class ScorePage extends StatefulWidget {
  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  GradeCenter gradeCenter;
  var semester = 7;
  var quit = 0;
  UpdateInfo remoteInfo;
  static int isUpdate = 1;

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
    check(showInstallUpdateDialog);
    searchGrade();
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

  Future<void> searchGrade() async {
    try {
      getGrade(GlobalUser.studentID, semesterMap[semester])
          .then((GradeCenter temp) {
        setState(() {
          gradeCenter = temp;
        });
      }).catchError((e) {
        print(e);
        if (e == 401) {
          setState(() {
            quit = 1;
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    PageSelect page = Provider.of<PageSelect>(context);
    if (isUpdate == 1) {
      return new Scaffold();
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('成绩查询'),
        backgroundColor: Colors.lightBlue,
      ),
      body: quit == 1
          ? Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("账号密码已失效，\n这可能是因为您修改了统一认证密码，\n请点击下方按钮以重新登录。"),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                    child: Text("重新登录"),
                    onPressed: () {
                      GlobalUser.setIsLogin(false);
                      page.setPage(1);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/loginPage', (Route route) => false);
                    },
                  ),
                ],
              ),
            )
          : gradeCenter == null
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 30.0),
                              child: Text('GPA： ${gradeCenter.gpa}',
                                  textAlign: TextAlign.left,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        Container(
                          margin:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
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
                                  subtitle: Text(
                                      '${gradeCenter.grades[index].credit}学分'),
                                  trailing: Text(
                                      '${gradeCenter.grades[index].score}'),
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
