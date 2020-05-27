import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/CourseEvaluationPage.dart';
import 'package:jiaowuassistent/pages/CourseCommentWritePage.dart';
import 'package:jiaowuassistent/pages/User.dart';
import 'package:jiaowuassistent/GlobalUser.dart';

class ExpandState {
  var isOpen;
  var index;

  ExpandState(this.index, this.isOpen);
}

class CourseEvaluationDetailPage extends StatefulWidget {
  final String courseName;
  final String courseCredit;
  final double courseScore;
  final String bid;

  CourseEvaluationDetailPage(
      {Key key,
      @required this.courseName,
      this.courseCredit,
      this.courseScore,
      this.bid})
      : super(key: key);

  @override
  _CourseEvaluationDetailPageState createState() =>
      _CourseEvaluationDetailPageState();
}

class _CourseEvaluationDetailPageState
    extends State<CourseEvaluationDetailPage> {
  int evaluationTimes = 10;
  ExpandState _expandState = new ExpandState(0, false);
  EvaluationDetail evaluationDetail;
  String commentText;
  double score;

  @override
  initState() {
    super.initState();
    searchEvaluationDetail();
  }

  Future<void> searchEvaluationDetail() async {
    try {
      getEvaluationDetail(widget.bid, GlobalUser.studentID)
          .then((EvaluationDetail temp) {
        setState(() {
          evaluationDetail = temp;
        });
      }).catchError((e) {
        print(e);
      });
    } catch (e) {
      print(e);
    }
  }

  //用来获得不同比例的星星
  Widget getLeftStar(double radio, double size) {
    if (radio > 0) {
      return ClipRect(
          clipper: MyRectClipper(width: radio * size),
          child: Icon(Icons.star, size: size, color: const Color(0xffe0aa46)));
    } else {
      return Icon(Icons.star, size: size, color: const Color(0xffbbbbbb));
    }
  }

  //根据评分返回对应数目及样式的星星
  Widget fiveStars(double score, double size) {
    return new Container(
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              getLeftStar(0, size),
              getLeftStar(0, size),
              getLeftStar(0, size),
              getLeftStar(0, size),
              getLeftStar(0, size),
            ],
          ),
          Row(children: <Widget>[
            score >= 1 ? getLeftStar(1, size) : getLeftStar(score, size),
            score >= 2 ? getLeftStar(1, size) : getLeftStar(score - 1, size),
            score >= 3 ? getLeftStar(1, size) : getLeftStar(score - 2, size),
            score >= 4 ? getLeftStar(1, size) : getLeftStar(score - 3, size),
            score >= 5 ? getLeftStar(1, size) : getLeftStar(score - 4, size),
          ]),
        ],
      ),
    );
  }

  void updateAgree(int index, int subIndex) {
    setState(() {
      if (evaluationDetail.info[index].hasUp) {
        evaluationDetail.info[index].upNum -= 1;
        evaluationDetail.info[index].hasUp = false;
      } else {
        evaluationDetail.info[index].upNum += 1;
        evaluationDetail.info[index].hasUp = true;
      }
    });
  }

  void updateDisagree(int index, int subIndex) {
    setState(() {
      if (evaluationDetail.info[index].hasDown) {
        evaluationDetail.info[index].downNum -= 1;
        evaluationDetail.info[index].hasDown = false;
      } else {
        evaluationDetail.info[index].downNum += 1;
        evaluationDetail.info[index].hasDown = true;
      }
    });
  }

  void updateTeacherAgree(int index) {
    setState(() {
      if (evaluationDetail.teacherInfo[index].hasUp) {
        evaluationDetail.teacherInfo[index].upNum -= 1;
        evaluationDetail.teacherInfo[index].hasUp = false;
      } else {
        evaluationDetail.teacherInfo[index].upNum += 1;
        evaluationDetail.teacherInfo[index].hasUp = true;
      }
    });
  }

//  void updateTeacherDisagree(int index) {
//    setState(() {
//      if (this._teacherList[index][4]) {
//        this._teacherList[index][2] -= 1;
//        this._teacherList[index][4] = false;
//      } else {
//        this._teacherList[index][2] += 1;
//        this._teacherList[index][4] = true;
//      }
//    });
//  }

  Widget getTeacher() {
    return ExpansionPanelList(
        expansionCallback: (int index, bool isExpand) {
          setState(() {
            this._expandState.isOpen = !isExpand;
          });
        },
        children: [
          ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '教师评价',
                    style: new TextStyle(fontSize: 18),
                  ),
                );
              },
              body: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 1, color: Colors.grey))),
                  // ignore: deprecated_member_use
                  child: Column(children: <Widget>[
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: evaluationDetail.teacherInfo.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: <Widget>[
                              Expanded(
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      evaluationDetail
                                          .teacherInfo[index].teacherName,
                                      style: new TextStyle(
                                        fontSize: 16,
                                      ),
//                                    ),
                                    ),
                                  ],
                                ),
                              ),
                              new Column(
                                children: <Widget>[
                                  new IconButton(
                                    icon: (evaluationDetail
                                            .teacherInfo[index].hasUp
                                        ? new Icon(
                                            Icons.thumb_up,
                                            color: Colors.red,
                                            size: 15,
                                          )
                                        : new Icon(
                                            Icons.thumb_up,
                                            size: 15,
                                          )),
                                    onPressed: () =>
                                        {updateTeacherAgree(index)},
                                  ),
                                  Text(
                                      evaluationDetail.teacherInfo[index].upNum
                                          .toString(),
                                      style: new TextStyle(
                                        fontSize: 14,
                                      ))
                                ],
                              ),
//                              new Column(
//                                children: <Widget>[
//                                  new IconButton(
//                                    icon: _teacherList[index][4]
//                                        ? new Icon(
//                                            Icons.thumb_down,
//                                            color: Colors.red,
//                                            size: 15,
//                                          )
//                                        : new Icon(
//                                            Icons.thumb_down,
//                                            size: 15,
//                                          ),
//                                    onPressed: () =>
//                                        {updateTeacherDisagree(index)},
//                                    padding: const EdgeInsets.all(0.0),
//                                  ),
//                                  Text(_teacherList[index][2].toString(),
//                                      style: new TextStyle(
//                                        fontSize: 14,
//                                      ))
//                                ],
//                              )
                            ],
                          );
                        }),
                  ])),
              isExpanded: _expandState.isOpen // 设置面板的状态，true展开，false折叠
              )
        ]
//      }).toList(),
        );
  }

  Widget getReview() {
    return new Container(
      child: Column(children: <Widget>[
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: evaluationDetail.info.length,
            itemBuilder: (BuildContext context, int index) {
              if (evaluationDetail.info[index].studentId ==
                  GlobalUser.studentID) {
                commentText = evaluationDetail.info[index].content;
                score = evaluationDetail.info[index].score;
              }
              return Container(
                  padding: EdgeInsets.all(16.0),
                  // ignore: deprecated_member_use
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: Colors.grey))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            fiveStars(
                                0.0 + evaluationDetail.info[index].score, 16),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              evaluationDetail.info[index].content,
                              style: new TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Column(
                        children: <Widget>[
                          new IconButton(
                            icon: (evaluationDetail.info[index].hasUp
                                ? new Icon(
                                    Icons.thumb_up,
                                    color: Colors.red,
                                    size: 15,
                                  )
                                : new Icon(
                                    Icons.thumb_up,
                                    size: 15,
                                  )),
                            onPressed: () => {updateAgree(index, -1)},
                          ),
                          Text(evaluationDetail.info[index].upNum.toString(),
                              style: new TextStyle(
                                fontSize: 14,
                              ))
                        ],
                      ),
                      new Column(
                        children: <Widget>[
                          new IconButton(
                            icon: evaluationDetail.info[index].hasDown
                                ? new Icon(
                                    Icons.thumb_down,
                                    color: Colors.red,
                                    size: 15,
                                  )
                                : new Icon(
                                    Icons.thumb_down,
                                    size: 15,
                                  ),
                            onPressed: () => {updateDisagree(index, -1)},
                            padding: const EdgeInsets.all(0.0),
                          ),
                          Text(evaluationDetail.info[index].downNum.toString(),
                              style: new TextStyle(
                                fontSize: 14,
                              ))
                        ],
                      )
                    ],
                  ));
            }),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('课程详情'),
        backgroundColor: Colors.lightBlue,
      ),
      body: evaluationDetail == null
          ? Container(
              alignment: Alignment(0.0, 0.0),
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
              ))
          : ListView(
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(
                      left: 10.0, top: 5.0, right: 10.0, bottom: 10.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(5.0),
                        child: new Text(
                          widget.courseName,
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      new Row(
                        children: <Widget>[
                          new Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.courseScore.toString(),
                                style: new TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: 44,
                                ),
                              ),
                              Text(
                                evaluationTimes.toString() + ' 个评价',
                                style: new TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          )),
                          IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.edit,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CourseCommentWritePage(
                                            bname: widget.courseName,
                                            bid: widget.bid,
                                            score: score,
                                            commentText: commentText,
                                          )));
                            },
                          ), // zyx add modify icon
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text('5星'),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        height: 8,
                                        width: 150,
                                        child: LinearProgressIndicator(
                                          value: 0.5,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('50.0%'),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text('4星'),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        height: 8,
                                        width: 150,
                                        child: LinearProgressIndicator(
                                          value: 0.3,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('30.0%'),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text('3星'),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        height: 8,
                                        width: 150,
                                        child: LinearProgressIndicator(
                                          value: 0.1,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('10.0%'),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text('2星'),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        height: 8,
                                        width: 150,
                                        child: LinearProgressIndicator(
                                          value: 0.08,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('8.0%'),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text('1星'),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        height: 8,
                                        width: 150,
                                        child: LinearProgressIndicator(
                                          value: 0.02,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('2.0%'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                getTeacher(),
                getReview(),
              ],
            ),
    );
  }
}
