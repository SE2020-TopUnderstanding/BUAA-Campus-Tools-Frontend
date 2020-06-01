import 'dart:async' show Future;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/User.dart';
import 'package:jiaowuassistent/GlobalUser.dart';
import 'package:provider/provider.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseCenterPage extends StatefulWidget {
  @override
  _CourseCenterPageState createState() => _CourseCenterPageState();
}

class _CourseCenterPageState extends State<CourseCenterPage> {
  Future<CourseCenter> courseCenter;
  UpdateInfo remoteInfo;
  static int isUpdate = 1;

  @override
  initState() {
    super.initState();
    check(showInstallUpdateDialog);
    courseCenter = getCourseCenter(GlobalUser.studentID);
  }

  check(Function showDialog) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    remoteInfo = await getUpdateInfo();
//    print(packageInfo.version);
//    print(remoteInfo.version);
    if (packageInfo.version.hashCode == remoteInfo.version.hashCode) {
//      print('无新版本');
      setState(() {
        isUpdate = 0;
      });
      return;
    }
//    print('有新版本');
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
      if ((course.content[i].status.contains('已提交') ||
              course.content[i].status.contains('重新提交') ||
              course.content[i].status.contains('已返还') ||
              course.content[i].time == "") &&
          (GlobalUser.ddlChoice == 0 ? false : true)) continue;
      var time, duration;
      if (course.content[i].time != "") {
        time = DateTime.parse(course.content[i].time);
        duration = time.difference(now);
      }
      dataRows.add(DataRow(
        cells: [
          DataCell(
            course.content[i].status.contains('已提交') ||
                    course.content[i].status.contains('重新提交') ||
                    course.content[i].status.contains('已返还') ||
                    course.content[i].time == ""
                ? Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  )
                : course.content[i].status.contains('未显示')
                    ? Text('未显示', style: TextStyle(color: Color(0xFFF57C00)))
                    : duration.inHours < 0
                        ? Text('已截止', style: TextStyle(color: Colors.red))
                        : duration.inDays > 0
                            ? Text('剩${duration.inDays.toString()}天',
                                style: TextStyle(color: Color(0xFFF57C00)))
                            : Text('剩${duration.inHours.toString()}时',
                                style: TextStyle(color: Colors.deepOrange)),
          ),
          DataCell(Text('${course.content[i].text}')),
          DataCell(course.content[i].time == ""
              ? Text('没有截止时间')
              : Text('${course.content[i].time}')),
        ],
      ));
    }
    return dataRows;
  }

  List<int> mList = []; //组成一个int类型数组，用来控制索引
  List<ExpandStateBean> courseList = [];
  int ifShowAll = GlobalUser.ddlChoice; // 0->展示全部ddl，1->不展示全部ddl

  @override
  Widget build(BuildContext context) {
    PageSelect page = Provider.of<PageSelect>(context);
    if (isUpdate == 1) {
      return new Scaffold();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("课程中心DDL"),
//        backgroundColor: Colors.lightBlue,
        actions: <Widget>[
          DropdownButton(
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 20,
            value: ifShowAll,
            items: [
              DropdownMenuItem(
                child: Text('全部ddl'),
                value: 0,
              ),
              DropdownMenuItem(
                child: Text('未完成ddl'),
                value: 1,
              )
            ],
            onChanged: (_value) {
              setState(() {
                ifShowAll = _value;
                GlobalUser.setDDLChoice(ifShowAll);
              });
            },
          ),
          //IconButton(icon: Icon(Icons.refresh), onPressed: null,),暂不支持手动刷新
        ],
      ),
      //加入可滚动组件(ExpansionPanelList必须使用可滚动的组件)
      body: FutureBuilder<CourseCenter>(
          future: courseCenter,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.courses.length == 0) {
                return Container(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "目前没有获取到您的课程信息,以下是几个可能的原因及解决办法：",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "1. 努力获取数据中，请稍后再试。\n\n"
                        "2. 如果您本学期课程中心没有课程，请忽略上述提示，此时我们不再提供该功能。\n\n",
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                );
              }
              if (snapshot.data.courses[0].name == "错误") {
                return Container(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "抱歉，我们暂时无法获取您的课程信息,以下是可能的原因及解决办法：",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "您的课程中心没有“活跃站点”，请在学校“课程中心-我的工作空间-用户偏好”页面进行偏好设置，"
                        "保证希望获取ddl的课程都属于收藏站点或活跃站点，并且活跃站点不能为空。",
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                );
              }
              for (int i = 0; i < snapshot.data.courses.length; i++) {
                if (!mList.contains(i)) {
                  mList.add(i);
                  courseList.add(ExpandStateBean(i, false)); //item初始状态为闭着的
                }
              }
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
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
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1565C0))),
                                ),
                                DataColumn(
                                  label: Text('作业内容',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1565C0))),
                                ),
                                DataColumn(
                                  label: Text('DeadLine',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1565C0))),
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
            } else if (snapshot.error == 401) {
              return Container(
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
              );
            } else {
              return Container(
                  alignment: Alignment(0.0, 0.0),
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF1565C0)),
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
