import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/CourseEvaluationPage.dart';

class ExpandState {
  var isOpen;
  var index;
  ExpandState(this.index, this.isOpen);
}

class CourseEvaluationDetailPage extends StatefulWidget {
  final String courseName;
  final String courseCredit;
  final double courseScore;

  CourseEvaluationDetailPage(
      {Key key, @required this.courseName, this.courseCredit, this.courseScore})
      : super(key: key);

  @override
  _CourseEvaluationDetailPageState createState() =>
      _CourseEvaluationDetailPageState();
}

class _CourseEvaluationDetailPageState
    extends State<CourseEvaluationDetailPage> {
  int evaluationTimes = 10;
  List<dynamic> _reviewList;
  List<ExpandState> _expandStateList = [];

  _CourseEvaluationDetailPageState() {
    _reviewList = [
      [
        'this is a good course, i like it soooooooooooooooooooooooooooooooooooooooooo much',
        4.0,
        32,
        1,
        true,
        false
      ],
      ['this is a bad course', 2.0, 32, 1, false, true]
    ];
    for (int i = 0; i < _reviewList.length; i++) {
      _expandStateList.add(ExpandState(i, false));
    }
//    print(_expandStateList);
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
      if (subIndex == -1) {
        if (this._reviewList[index][4]) {
          this._reviewList[index][2] -= 1;
          this._reviewList[index][4] = false;
        } else {
          this._reviewList[index][2] += 1;
          this._reviewList[index][4] = true;
        }
      }
    });
  }

  void updateDisagree(int index, int subIndex) {
    setState(() {
      if (subIndex == -1) {
        if (this._reviewList[index][5]) {
          this._reviewList[index][3] -= 1;
          this._reviewList[index][5] = false;
        } else {
          this._reviewList[index][3] += 1;
          this._reviewList[index][5] = true;
        }
      }
    });
  }

  Widget getReview() {
    return new Container(
      child: Column(children: <Widget>[
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _reviewList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  padding: EdgeInsets.all(16.0),
                  // ignore: deprecated_member_use
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 1, color: Colors.grey))),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            fiveStars(0.0 + _reviewList[index][1], 15),
                            Text(
                              _reviewList[index][0],
                              style: new TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Column(
                        children: <Widget>[
                          new IconButton(
                            icon: (_reviewList[index][4]
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
                          Text(_reviewList[index][2].toString(),
                              style: new TextStyle(
                                fontSize: 14,
                              ))
                        ],
                      ),
                      new Column(
                        children: <Widget>[
                          new IconButton(
                            icon: _reviewList[index][5]
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
                          Text(_reviewList[index][3].toString(),
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
      body: new ListView(
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.all(5.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                    child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: new Text(
                        widget.courseName,
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
//                    new Text(
//                      widget.courseCredit,
//                      style: new TextStyle(
//                        color: Colors.grey[500],
//                        fontSize: 20,
//                      ),
//                    ),
                    Text(
                      widget.courseScore.toString(),
                      style: new TextStyle(
                        color: Colors.grey[900],
                        fontSize: 44,
                      ),
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
                    Text(
                      evaluationTimes.toString() + ' 人评价过这门课',
                      style: new TextStyle(
                        color: Colors.grey[900],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                )
              ],
            ),
          ),
          getReview(),
        ],
      ),
    );
  }
}
