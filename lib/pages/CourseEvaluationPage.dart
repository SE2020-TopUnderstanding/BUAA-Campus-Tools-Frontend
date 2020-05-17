import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/CourseEvaluationDetailPage.dart';

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
  final _evaluationList = [
    ['软件工程', '2学分', 4.2],
    ['计算机网络', '2学分', 4.5],
    ['计算机网络实验', '1学分', 3.7]
  ];
  TextEditingController _searchController = new TextEditingController();
  FocusNode _focusNodeSearch = new FocusNode();

  @override
  void initState() {
    super.initState();
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

  Widget _courseInformation(
      String courseName, String courseCredit, double courseScore) {
    return new Card(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: Text(courseName),
                subtitle: Text(courseCredit),
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
                SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    focusNode: _focusNodeSearch,
                    controller: _searchController,
                    validator: (v) =>
                        v.trim().isNotEmpty ? Null : '请输入您希望查看的课程',
                    decoration: InputDecoration(
                      hintText: '课程名称',
                    ),
                  ),
                ),
                SizedBox(height: 20),
                RaisedButton(
                  color: Colors.lightBlue,
                  child: Text(
                    '搜索',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        letterSpacing: 10,
                        fontWeight: FontWeight.normal,
                        fontSize: 24,
                        color: Colors.white),
                  ),
                  onPressed: () {},
                ),
                SizedBox(height: 20, width: 20),
              ],
            ),
            Container(
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _evaluationList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _courseInformation(
                      _evaluationList[index][0],
                      _evaluationList[index][1],
                      _evaluationList[index][2],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
