import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/GlobalUser.dart';
import 'package:jiaowuassistent/pages/CourseEvaluationDetailPage.dart';
import 'package:jiaowuassistent/pages/User.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class MyRectClipper extends CustomClipper<Rect> {
  final double width;

  MyRectClipper({this.width});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, width, size.height);
  }

  @override
  bool shouldReclip(MyRectClipper oldClipper) {
    return width != oldClipper.width;
  }
}

class CourseEvaluationPage extends StatefulWidget {
  @override
  _CourseEvaluationPageState createState() => _CourseEvaluationPageState();
}

class _CourseEvaluationPageState extends State<CourseEvaluationPage> {
  EvaluationCoursePage _evaluationList;
  TextEditingController _courseNameController = new TextEditingController();
  FocusNode _focusNodeCourse = new FocusNode();
  TextEditingController _teacherController = new TextEditingController();
  FocusNode _focusNodeTeacher = new FocusNode();
  FocusNode blankNode = FocusNode();
  bool _isDisabled = false;
  String _department;
  String _courseType;
  String _courseName;
  String _teacher;

  //下滑刷新相关
  bool _firstIn = true;

  int _page = 1;
  bool _isLoading = false;

  UpdateInfo remoteInfo;
  static int isUpdate = 1;

  //回到顶部悬浮按扭相关
  var _scrollController = ScrollController();
  var _showBackTop = false;

  @override
  void initState() {
    super.initState();
    check(showInstallUpdateDialog);
    // 对 scrollController 进行监听
    _scrollController.addListener(() {
      // 当滚动距离大于 500 之后，显示回到顶部按钮
      setState(() => _showBackTop = _scrollController.position.pixels >= 500);
    });
    _scrollController.addListener(() {
      if (!_firstIn &&
          !_isLoading &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        setState(() {
          _isLoading = true;
          _page += 1;
          refreshEvaluationCourseList();
        });
      }
    });
    //获得已选课程评价列表
    getDefaultList();
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<DropdownMenuItem> getDepartment() {
    List<DropdownMenuItem> items = [
      DropdownMenuItem(
        child: Text('全部'),
        value: '全部',
      ),
      DropdownMenuItem(
        child: Text('材料科学与工程学院'),
        value: '材料科学与工程学院',
      ),
      DropdownMenuItem(
        child: Text('电子信息工程学院'),
        value: '电子信息工程学院',
      ),
      DropdownMenuItem(
        child: Text('自动化科学与电气工程学院'),
        value: '自动化科学与电气工程学院',
      ),
      DropdownMenuItem(
        child: Text('能源与动力工程学院'),
        value: '能源与动力工程学院',
      ),
      DropdownMenuItem(
        child: Text('航空科学与工程学院'),
        value: '航空科学与工程学院',
      ),
      DropdownMenuItem(
        child: Text('计算机学院'),
        value: '计算机学院',
      ),
      DropdownMenuItem(
        child: Text('机械工程及自动化学院'),
        value: '机械工程及自动化学院',
      ),
      DropdownMenuItem(
        child: Text('经济管理学院'),
        value: '经济管理学院',
      ),
      DropdownMenuItem(
        child: Text('数学科学学院'),
        value: '数学科学学院',
      ),
      DropdownMenuItem(
        child: Text('生物与医学工程学院'),
        value: '生物与医学工程学院',
      ),
      DropdownMenuItem(
        child: Text('人文社会科学学院'),
        value: '人文社会科学学院',
      ),
      DropdownMenuItem(
        child: Text('外国语学院'),
        value: '外国语学院',
      ),
      DropdownMenuItem(
        child: Text('交通科学与工程学院'),
        value: '交通科学与工程学院',
      ),
      DropdownMenuItem(
        child: Text('可靠性与系统工程学院'),
        value: '可靠性与系统工程学院',
      ),
      DropdownMenuItem(
        child: Text('宇航学院'),
        value: '宇航学院',
      ),
      DropdownMenuItem(
        child: Text('飞行学院'),
        value: '飞行学院',
      ),
      DropdownMenuItem(
        child: Text('仪器科学与光电工程学院'),
        value: '仪器科学与光电工程学院',
      ),
      DropdownMenuItem(
        child: Text('北京学院'),
        value: '北京学院',
      ),
      DropdownMenuItem(
        child: Text('物理学院'),
        value: '物理学院',
      ),
      DropdownMenuItem(
        child: Text('法学院'),
        value: '法学院',
      ),
      DropdownMenuItem(
        child: Text('软件学院'),
        value: '软件学院',
      ),
      DropdownMenuItem(
        child: Text('现代远程教育学院'),
        value: '现代远程教育学院',
      ),
      DropdownMenuItem(
        child: Text('高等理工学院'),
        value: '高等理工学院',
      ),
      DropdownMenuItem(
        child: Text('中法工程师学院'),
        value: '中法工程师学院',
      ),
      DropdownMenuItem(
        child: Text('国际学院'),
        value: '国际学院',
      ),
      DropdownMenuItem(
        child: Text('新媒体艺术与设计学院'),
        value: '新媒体艺术与设计学院',
      ),
      DropdownMenuItem(
        child: Text('化学学院'),
        value: '化学学院',
      ),
      DropdownMenuItem(
        child: Text('马克思主义学院'),
        value: '马克思主义学院',
      ),
      DropdownMenuItem(
        child: Text('人文与社会科学高等研究院'),
        value: '人文与社会科学高等研究院',
      ),
      DropdownMenuItem(
        child: Text('空间与环境学院'),
        value: '空间与环境学院',
      ),
      DropdownMenuItem(
        child: Text('武装部'),
        value: '武装部',
      ),
      DropdownMenuItem(
        child: Text('工程训练中心'),
        value: '工程训练中心',
      ),
      DropdownMenuItem(
        child: Text('体育部'),
        value: '体育部',
      ),
      DropdownMenuItem(
        child: Text('图书馆'),
        value: '图书馆',
      ),
      DropdownMenuItem(
        child: Text('国际通用工程学院'),
        value: '国际通用工程学院',
      ),
      DropdownMenuItem(
        child: Text('校医院'),
        value: '校医院',
      ),
      DropdownMenuItem(
        child: Text('招生就业处'),
        value: '招生就业处',
      ),
      DropdownMenuItem(
        child: Text('无人机所'),
        value: '无人机所',
      ),
      DropdownMenuItem(
        child: Text('网络空间安全学院'),
        value: '网络空间安全学院',
      ),
      DropdownMenuItem(
        child: Text('校机关'),
        value: '校机关',
      ),
      DropdownMenuItem(
        child: Text('继续教育学院'),
        value: '继续教育学院',
      ),
      DropdownMenuItem(
        child: Text('研究生院'),
        value: '研究生院',
      ),
      DropdownMenuItem(
        child: Text('北航暑期学校'),
        value: '北航暑期学校',
      ),
      DropdownMenuItem(
        child: Text('微电子学院'),
        value: '微电子学院',
      ),
      DropdownMenuItem(
        child: Text('校际'),
        value: '校际',
      ),
      DropdownMenuItem(
        child: Text('学生处武装部'),
        value: '学生处武装部',
      ),
      DropdownMenuItem(
        child: Text('团委'),
        value: '团委',
      ),
      DropdownMenuItem(
        child: Text('校内其它单位'),
        value: '校内其它单位',
      ),
      DropdownMenuItem(
        child: Text('校外单位'),
        value: '校外单位',
      ),
      DropdownMenuItem(
        child: Text('学生发展服务中心'),
        value: '学生发展服务中心',
      ),
      DropdownMenuItem(
        child: Text('北航学院'),
        value: '北航学院',
      ),
      DropdownMenuItem(
        child: Text('高等理工学院（华罗庚班）'),
        value: '高等理工学院（华罗庚班）',
      ),
    ];
    return items;
  }

  List<DropdownMenuItem> getCourseType() {
    List<DropdownMenuItem> items = [
      DropdownMenuItem(
        child: Text('全部'),
        value: '全部',
      ),
      DropdownMenuItem(
        child: Text('核心专业类'),
        value: '核心专业类',
      ),
      DropdownMenuItem(
        child: Text('一般专业类'),
        value: '一般专业类',
      ),
      DropdownMenuItem(
        child: Text('核心通识类'),
        value: '核心通识类',
      ),
      DropdownMenuItem(
        child: Text('一般通识类'),
        value: '一般通识类',
      ),
      DropdownMenuItem(
        child: Text('工程基础类'),
        value: '工程基础类',
      ),
      DropdownMenuItem(
        child: Text('博雅类'),
        value: '博雅类',
      ),
      DropdownMenuItem(
        child: Text('体育类'),
        value: '体育类',
      ),
    ];
    return items;
  }

  Future<void> getDefaultList() async {
    try {
      dynamic response =
          await loadDefaultEvaluationCourseList(GlobalUser.studentID);
      setState(() {
        _evaluationList = response;
      });
    } catch (e) {
      throw (e);
    }
  }

  Future<void> searchEvaluationCourseList() async {
    _courseName = _courseNameController.text;
    _teacher = _teacherController.text;
    if (_courseName.isEmpty &&
        _teacher.isEmpty &&
        _department == null &&
        _courseType == null) {
      _showAlertDialog();
    } else {
      try {
        setState(() {
          _isDisabled = true;
        });
        dynamic response = await loadEvaluationCoursePage(
            _courseName, _teacher, _courseType, _department, _page);
        setState(() {
          _evaluationList = response;
          _isDisabled = false;
          _firstIn = false;
          _page = 1;
        });
      } catch (e) {
        throw (e);
      }
    }
  }

  Future<void> refreshEvaluationCourseList() async {
    try {
      setState(() {
        _isDisabled = true;
      });
      if (_evaluationList.totalPage >= _page) {
//        await new Future.delayed(new Duration(seconds: 3));
        dynamic response = await loadEvaluationCoursePage(
            _courseName, _teacher, _courseType, _department, _page);
        setState(() {
          _evaluationList.evaluationCourseList.courseList
              .addAll(response.evaluationCourseList.courseList);
          _isDisabled = false;
          _isLoading = false;
        });
      } else {
        await new Future.delayed(new Duration(seconds: 2));
        setState(() {
          _isDisabled = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      throw (e);
    }
  }

  void _showAlertDialog() {
    showDialog(
        // 设置点击 dialog 外部不取消 dialog，默认能够取消
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                '错误提示',
                textAlign: TextAlign.center,
              ),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
              // 标题文字样式
              content: Text(r'四个字段至少要填写一个\(^o^)/~'),
              contentTextStyle: TextStyle(color: Colors.white, fontSize: 17),
              // 内容文字样式
              backgroundColor: CupertinoColors.systemGrey,
              elevation: 8.0,
              // 投影的阴影高度
              semanticLabel: 'Label',
              // 这个用于无障碍下弹出 dialog 的提示
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              // dialog 的操作按钮，actions 的个数尽量控制不要过多，否则会溢出 `Overflow`
              actions: <Widget>[
                // 点击增加显示的值
//            FlatButton(onPressed: increase, child: Text('点我增加')),
//            // 点击减少显示的值
//            FlatButton(onPressed: decrease, child: Text('点我减少')),
//            // 点击关闭 dialog，需要通过 Navigator 进行操作
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      '知道了',
                      style: TextStyle(color: CupertinoColors.white),
                    )),
              ],
            ));
  }

  Widget getLeftStar(double radio) {
    if (radio > 0) {
      return ClipRect(
          clipper: MyRectClipper(width: radio * 20),
          child: Icon(Icons.star, size: 20, color: const Color(0xffe0aa46)));
    } else {
      return Icon(Icons.star, size: 20, color: const Color(0xffbbbbbb));
    }
  }

  Widget _courseInformation(String bid, String courseName, String courseCredit,
      double courseScore, String department) {
    return new Card(
        child: InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CourseEvaluationDetailPage(
                      courseName: courseName,
                      courseCredit: courseCredit,
                      courseScore: courseScore,
                      bid: bid,
                    ))).then((value) {
          _courseName = _courseNameController.text;
          _teacher = _teacherController.text;
          if (!(_courseName.isEmpty &&
              _teacher.isEmpty &&
              _department == null &&
              _courseType == null)) {
            _page = 1;
            _scrollController.animateTo(0.0,
                duration: Duration(milliseconds: 500),
                curve: Curves.decelerate);
            searchEvaluationCourseList();
          } else {
            getDefaultList();
          }
        });
      },
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: Text(courseName),
                subtitle: Text(department + ' ' + courseCredit),
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      getLeftStar(0),
                      getLeftStar(0),
                      getLeftStar(0),
                      getLeftStar(0),
                      getLeftStar(0),
                    ],
                  ),
                  Row(children: <Widget>[
                    courseScore >= 1
                        ? getLeftStar(1)
                        : getLeftStar(courseScore),
                    courseScore >= 2
                        ? getLeftStar(1)
                        : getLeftStar(courseScore - 1),
                    courseScore >= 3
                        ? getLeftStar(1)
                        : getLeftStar(courseScore - 2),
                    courseScore >= 4
                        ? getLeftStar(1)
                        : getLeftStar(courseScore - 3),
                    courseScore >= 5
                        ? getLeftStar(1)
                        : getLeftStar(courseScore - 4),
                  ]),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(courseScore.toString()),
            SizedBox(height: 20, width: 20),
          ]),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('课程列表', style: TextStyle(color: Colors.grey[100])),
//        backgroundColor: Colors.lightBlue,
      ),
      backgroundColor: Colors.grey[100],
      body: Scrollbar(
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      SizedBox(height: 5),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: TextFormField(
                          focusNode: _focusNodeCourse,
                          controller: _courseNameController,
                          validator: (v) =>
                              v.trim().isNotEmpty ? Null : '请输入您希望查看的课程',
                          decoration: InputDecoration(
//                            border: new OutlineInputBorder(
//                              //添加边框
//                              gapPadding: 10.0,
//                              borderRadius: BorderRadius.circular(10.0),
//                            ),
                              hintText: '课程名称',
                              prefixIcon: new Icon(Icons.assignment)),
                        ),
                      ),
//                    SizedBox(height: 5),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: TextFormField(
                          focusNode: _focusNodeTeacher,
                          controller: _teacherController,
                          validator: (v) =>
                              v.trim().isNotEmpty ? Null : '请输入您希望查看的老师',
                          decoration: InputDecoration(
//                            border: new OutlineInputBorder(
//                              //添加边框
//                              gapPadding: 10.0,
//                              borderRadius: BorderRadius.circular(10.0),
//                            ),
                              hintText: '教师姓名',
                              prefixIcon: new Icon(Icons.assignment_ind)),
                        ),
                      )
                    ],
                  )),
                ],
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.card_travel, color: const Color(0xffbbbbbb)),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '开课院系：',
                        style: new TextStyle(fontSize: 16),
                      ),
//                      SizedBox(
//                        width: 10,
//                      ),
                      DropdownButton(
//                        underline: Container(
//                          height: 2,
//                          color: Colors.deepPurpleAccent,
//                        ),
                        value: _department,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 20,
                        iconEnabledColor: Colors.black,
                        hint: Text('请选择'),
                        items: getDepartment(),
                        onChanged: (value) {
                          setState(() {
                            _department = value;
                          });
                        },
                      ),
                    ]),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.book, color: const Color(0xffbbbbbb)),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '课程类别：',
                        style: new TextStyle(fontSize: 16),
                      ),
//                      SizedBox(
//                        width: 10,
//                      ),
                      DropdownButton(
//                        underline: Container(
//                          height: 2,
//                          color: Colors.deepPurpleAccent,
//                        ),
                        value: _courseType,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 20,
                        iconEnabledColor: Colors.black,
                        hint: Text('请选择'),
                        items: getCourseType(),
                        onChanged: (value) {
                          setState(() {
                            _courseType = value;
                          });
                        },
                      ),
                      Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Ink(
                                decoration: const ShapeDecoration(
                                  color: Color(0xFF1565C0),
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  onPressed: _isDisabled
                                      ? null
                                      : () => searchEvaluationCourseList(),
                                ),
                              )
                            ]),
                      )
                    ]),
              ),
              _firstIn
                  ? Text(
                      '默认展示本学期选课课程评价信息',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    )
                  : Text(
                      '共检索到 ${_evaluationList.totalCourse} 门课程',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
              Container(
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _evaluationList == null
                        ? 0
                        : _evaluationList
                                .evaluationCourseList.courseList.length +
                            1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index ==
                          _evaluationList
                              .evaluationCourseList.courseList.length) {
                        return new Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5.0),
                          child: new SizedBox(
                            height: 40.0,
                            width: 40.0,
                            child: new Opacity(
                              opacity: _isLoading ? 1.0 : 0.0,
                              child: new CircularProgressIndicator(),
                            ),
                          ),
                        );
                      }
                      return _courseInformation(
                          _evaluationList
                              .evaluationCourseList.courseList[index].bid,
                          _evaluationList.evaluationCourseList.courseList[index]
                              .courseName,
                          _evaluationList
                              .evaluationCourseList.courseList[index].credit,
                          _evaluationList
                              .evaluationCourseList.courseList[index].score,
                          _evaluationList.evaluationCourseList.courseList[index]
                              .department);
                    }),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: _showBackTop // 当需要显示的时候展示按钮，不需要的时候隐藏，设置 null
          ? FloatingActionButton(
              onPressed: () {
                // scrollController 通过 animateTo 方法滚动到某个具体高度
                // duration 表示动画的时长，curve 表示动画的运行方式，flutter 在 Curves 提供了许多方式
                _scrollController.animateTo(0.0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.decelerate);
              },
              child: Icon(Icons.vertical_align_top),
            )
          : null,
    );
  }
}
