import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/CourseEvaluationPage.dart';
import 'package:jiaowuassistent/pages/CourseCommentWritePage.dart';
import 'package:jiaowuassistent/pages/User.dart';
import 'package:jiaowuassistent/GlobalUser.dart';
import 'package:jiaowuassistent/encrypt.dart';

import 'User.dart';

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

  void updateAgree(int index) {
    setState(() {
      if (evaluationDetail.info.infoList[index].hasUp) {
        evaluationDetail.info.infoList[index].upNum -= 1;
        evaluationDetail.info.infoList[index].hasUp = false;
        postAgree(
            evaluationDetail.info.infoList[index].studentId, widget.bid, 1);
      } else {
        evaluationDetail.info.infoList[index].upNum += 1;
        evaluationDetail.info.infoList[index].hasUp = true;
        if (evaluationDetail.info.infoList[index].hasDown) {
          evaluationDetail.info.infoList[index].hasDown = false;
          evaluationDetail.info.infoList[index].downNum -= 1;
        }
        postAgree(
            evaluationDetail.info.infoList[index].studentId, widget.bid, 0);
      }
    });
  }

  void updateDisagree(int index) {
    setState(() {
      if (evaluationDetail.info.infoList[index].hasDown) {
        evaluationDetail.info.infoList[index].downNum -= 1;
        evaluationDetail.info.infoList[index].hasDown = false;
        postDisagree(
            evaluationDetail.info.infoList[index].studentId, widget.bid, 1);
      } else {
        evaluationDetail.info.infoList[index].downNum += 1;
        evaluationDetail.info.infoList[index].hasDown = true;
        if (evaluationDetail.info.infoList[index].hasUp) {
          evaluationDetail.info.infoList[index].hasUp = false;
          evaluationDetail.info.infoList[index].upNum -= 1;
        }
        postDisagree(
            evaluationDetail.info.infoList[index].studentId, widget.bid, 0);
      }
    });
  }

  void updateTeacherAgree(int index) {
    setState(() {
      if (evaluationDetail.teacherInfo.teacherInfoList[index].hasUp) {
        evaluationDetail.teacherInfo.teacherInfoList[index].upNum -= 1;
        evaluationDetail.teacherInfo.teacherInfoList[index].hasUp = false;
        postTeacherAgree(
            evaluationDetail.teacherInfo.teacherInfoList[index].teacherName,
            widget.bid,
            1);
      } else {
        evaluationDetail.teacherInfo.teacherInfoList[index].upNum += 1;
        evaluationDetail.teacherInfo.teacherInfoList[index].hasUp = true;
        postTeacherAgree(
            evaluationDetail.teacherInfo.teacherInfoList[index].teacherName,
            widget.bid,
            0);
      }
    });
  }

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
                        itemCount:
                            evaluationDetail.teacherInfo.teacherInfoList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: <Widget>[
                              Expanded(
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      evaluationDetail.teacherInfo
                                          .teacherInfoList[index].teacherName,
                                      style: new TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              new Column(
                                children: <Widget>[
                                  new IconButton(
                                    icon: (evaluationDetail.teacherInfo
                                            .teacherInfoList[index].hasUp
                                        ? new Icon(
                                            Icons.thumb_up,
                                            color: Colors.orangeAccent,
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
                                      evaluationDetail.teacherInfo
                                          .teacherInfoList[index].upNum
                                          .toString(),
                                      style: new TextStyle(
                                        fontSize: 14,
                                      ))
                                ],
                              ),
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

  void deleteConfirm() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('确定删除评论?'),
            actions: <Widget>[
              RaisedButton(
                child: Text("确定"),
                onPressed: () {
                  //此处添加向后端的put操作。
                  Navigator.of(context).pop();
                  deleteComment(widget.bid);
                  commentText = null;
                  score = 0;
                  searchEvaluationDetail();
                },
              ),
            ],
          );
        });
  }

  Widget getReview() {
    return new Container(
      child: Column(children: <Widget>[
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: evaluationDetail.info.infoList.length,
            itemBuilder: (BuildContext context, int index) {
              if (evaluationDetail.info.infoList[index].studentId ==
                  Encrypt.encrypt2(GlobalUser.studentID)) {
                commentText = evaluationDetail.info.infoList[index].content;
                score = evaluationDetail.info.infoList[index].score.toDouble();
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
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  fiveStars(
                                      0.0 +
                                          evaluationDetail
                                              .info.infoList[index].score,
                                      16),
                                ]),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 1.6, top: 5.0),
                              child: Text(
                                evaluationDetail.info.infoList[index].content,
                                style: new TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Container(
                                margin:
                                    const EdgeInsets.only(left: 1.6, top: 3.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '更新于 ${evaluationDetail.info.infoList[index].updateTime.replaceAll('T', ' ').substring(0, 16)}',
                                      style: new TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                    evaluationDetail.info.infoList[index]
                                                .studentId ==
                                            Encrypt.encrypt2(
                                                GlobalUser.studentID)
                                        ? Container(
                                            margin: const EdgeInsets.only(
                                                left: 20.0),
                                            child: GestureDetector(
                                              child: Text(
                                                '删除',
                                                style: new TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600]),
                                              ),
                                              onTap: () {
                                                deleteConfirm();
                                              },
                                            ),
                                          )
                                        : Container(),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      new Column(
                        children: <Widget>[
                          new IconButton(
                            icon: (evaluationDetail.info.infoList[index].hasUp
                                ? new Icon(
                                    Icons.thumb_up,
                                    color: Colors.orangeAccent,
                                    size: 15,
                                  )
                                : new Icon(
                                    Icons.thumb_up,
                                    size: 15,
                                  )),
                            onPressed: () => {updateAgree(index)},
                          ),
                          Text(
                              evaluationDetail.info.infoList[index].upNum
                                  .toString(),
                              style: new TextStyle(
                                fontSize: 14,
                              ))
                        ],
                      ),
                      new Column(
                        children: <Widget>[
                          new IconButton(
                            icon: evaluationDetail.info.infoList[index].hasDown
                                ? new Icon(
                                    Icons.thumb_down,
                                    color: Colors.red,
                                    size: 15,
                                  )
                                : new Icon(
                                    Icons.thumb_down,
                                    size: 15,
                                  ),
                            onPressed: () => {updateDisagree(index)},
                            padding: const EdgeInsets.all(0.0),
                          ),
                          Text(
                              evaluationDetail.info.infoList[index].downNum
                                  .toString(),
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
    double one = evaluationDetail == null || evaluationDetail.evaluationNum == 0
        ? 0
        : evaluationDetail.scoreInfo.scoreInfoList[0] /
            evaluationDetail.evaluationNum;
    double two = evaluationDetail == null || evaluationDetail.evaluationNum == 0
        ? 0
        : evaluationDetail.scoreInfo.scoreInfoList[1] /
            evaluationDetail.evaluationNum;
    double three =
        evaluationDetail == null || evaluationDetail.evaluationNum == 0
            ? 0
            : evaluationDetail.scoreInfo.scoreInfoList[2] /
                evaluationDetail.evaluationNum;
    double four =
        evaluationDetail == null || evaluationDetail.evaluationNum == 0
            ? 0
            : evaluationDetail.scoreInfo.scoreInfoList[3] /
                evaluationDetail.evaluationNum;
    double five =
        evaluationDetail == null || evaluationDetail.evaluationNum == 0
            ? 0
            : evaluationDetail.scoreInfo.scoreInfoList[4] /
                evaluationDetail.evaluationNum;
    return new Scaffold(
      appBar: AppBar(
        title: Text('课程详情', style: TextStyle(color: Colors.grey[100])),
//        backgroundColor: Colors.lightBlue,
      ),
      backgroundColor: Colors.grey[100],
      body: evaluationDetail == null
          ? Container(
              alignment: Alignment(0.0, 0.0),
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Color(0xFF1565C0)),
              ))
          : ListView(
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(
                      left: 10.0, top: 5.0, right: 10.0, bottom: 10.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          Expanded(
                            child: new Container(
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
                          ),
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
                                          )))
                                  .then((value) => searchEvaluationDetail());
                            },
                          ), // zyx add modify icon
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                evaluationDetail.averageScore.toString(),
                                style: new TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                evaluationDetail.info.infoList.length
                                        .toString() +
                                    ' 个评价',
                                style: new TextStyle(
                                  color: Colors.grey[900],
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          )),
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
                                          value: five,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          '${(five * 100).toStringAsFixed(1)}%'),
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
                                          value: four,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          '${(four * 100).toStringAsFixed(1)}%'),
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
                                          value: three,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          '${(three * 100).toStringAsFixed(1)}%'),
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
                                          value: two,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          '${(two * 100).toStringAsFixed(1)}%'),
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
                                          value: one,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          '${(one * 100).toStringAsFixed(1)}%'),
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
