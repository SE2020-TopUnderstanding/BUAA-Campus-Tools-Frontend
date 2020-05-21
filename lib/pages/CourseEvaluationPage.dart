import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/CourseEvaluationDetailPage.dart';
import 'package:jiaowuassistent/pages/User.dart';

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
  EvaluationCourseList _evaluationList;
  TextEditingController _courseNameController = new TextEditingController();
  FocusNode _focusNodeCourse = new FocusNode();
  TextEditingController _teacherController = new TextEditingController();
  FocusNode _focusNodeTeacher = new FocusNode();
  FocusNode blankNode = FocusNode();
  bool _isDisabled = false;
  String _department, _courseType;

  @override
  void initState() {
    super.initState();
//    this._evaluationList = loadEvaluationCourseList('计', '罗', '核心专业类');
  }

  List<DropdownMenuItem> getDepartment() {
    List<DropdownMenuItem> items = [
      DropdownMenuItem(
        child: Text('材料'),
        value: '材料',
      ),
      DropdownMenuItem(
        child: Text('电子'),
        value: '电子',
      ),
      DropdownMenuItem(
        child: Text('自动化'),
        value: '自动化',
      ),
      DropdownMenuItem(
        child: Text('能源'),
        value: '能源',
      ),
      DropdownMenuItem(
        child: Text('航空航天'),
        value: '航空航天',
      ),
      DropdownMenuItem(
        child: Text('计算机'),
        value: '计算机',
      ),
    ];
    return items;
  }

  List<DropdownMenuItem> getCourseType() {
    List<DropdownMenuItem> items = [
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
    ];
    return items;
  }

  Future<void> searchEvaluationCourseList() async {
    String courseName;
    String teacher;
    String courseType;
    courseName = _courseNameController.text;
    teacher = _teacherController.text;
    if ((courseName.isEmpty &&
            teacher.isEmpty &&
            (_department == null && _courseType == null)) ||
        (_department == null && _courseType!=null) ||
        (_department!=null && _courseType == null)) {
      _showAlertDialog();
    } else {
      try {
        setState(() {
          _isDisabled = true;
        });
        dynamic response =
            await loadEvaluationCourseList(courseName, teacher, courseType);
        setState(() {
          _evaluationList = response;
          _isDisabled = false;
        });
      } catch (e) {
        throw (e);
      }
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
              content: Text(r'四个字段至少要填写一个，并且开课院系和课程类别必须同时填写\(^o^)/~'),
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
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: Text(courseName),
                subtitle: Text(department + ' ' + courseCredit),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CourseEvaluationDetailPage(
                              courseName: courseName,
                              courseCredit: courseCredit,
                              courseScore: courseScore)));
                },
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
            Text(courseScore.toString() + '/5.0'),
            SizedBox(height: 20, width: 20),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('课程列表'),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: Column(
                  children: <Widget>[
                    TextFormField(
                      focusNode: _focusNodeCourse,
                      controller: _courseNameController,
                      validator: (v) =>
                          v.trim().isNotEmpty ? Null : '请输入您希望查看的课程',
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            //添加边框
                            gapPadding: 10.0,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: '课程名称',
                          prefixIcon: new Icon(Icons.assignment)),
                    ),
                    TextFormField(
                      focusNode: _focusNodeTeacher,
                      controller: _teacherController,
                      validator: (v) =>
                          v.trim().isNotEmpty ? Null : '请输入您希望查看的老师',
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            //添加边框
                            gapPadding: 10.0,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: '教师姓名',
                          prefixIcon: new Icon(Icons.assignment_ind)),
                    )
                  ],
                )),
                SizedBox(height: 20),
              ],
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    DropdownButton(
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      value: _department,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 30,
                      iconEnabledColor: Colors.black,
                      hint: Text('开课院系'),
                      items: getDepartment(),
                      onChanged: (value) {
                        setState(() {
                          _department = value;
                        });
                      },
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 25,
                      color: Colors.grey,
                    ),
                    DropdownButton(
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      value: _courseType,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 30,
                      iconEnabledColor: Colors.black,
                      hint: Text('课程类别'),
                      items: getCourseType(),
                      onChanged: (value) {
                        setState(() {
                          _courseType = value;
                        });
                      },
                    ),
                  ]),
            ),
            RaisedButton(
              color: Colors.lightBlue,
              disabledColor: Colors.grey,
              child: Text(
                '查询课程评价',
                textAlign: TextAlign.center,
                style: TextStyle(
                    letterSpacing: 5,
                    fontWeight: FontWeight.normal,
                    fontSize: 24,
                    color: Colors.white),
              ),
              onPressed:
                  _isDisabled ? null : () => searchEvaluationCourseList(),
            ),
            Container(
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _evaluationList == null
                      ? 0
                      : _evaluationList.evaluationCourseList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _courseInformation(
                        _evaluationList.evaluationCourseList[index].bid,
                        _evaluationList.evaluationCourseList[index].courseName,
                        _evaluationList.evaluationCourseList[index].credit,
                        _evaluationList.evaluationCourseList[index].score,
                        _evaluationList.evaluationCourseList[index].department);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
