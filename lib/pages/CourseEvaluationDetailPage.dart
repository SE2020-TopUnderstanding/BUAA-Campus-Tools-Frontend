import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/CourseEvaluationPage.dart';

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

  Widget getLeftStar(double radio, double size) {
    if (radio > 0) {
      return ClipRect(
          clipper: MyRectClipper(width: radio * size),
          child: Icon(Icons.star, size: size, color: const Color(0xffe0aa46)));
    } else {
      return Icon(Icons.star, size: size, color: const Color(0xffbbbbbb));
    }
  }

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
            padding: const EdgeInsets.all(10.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                    child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    new Text(
                      widget.courseCredit,
                      style: new TextStyle(
                        color: Colors.grey[500],
                        fontSize: 20,
                      ),
                    ),
                    new Text(
                      evaluationTimes.toString() + ' 人评价过这门课',
                      style: new TextStyle(
                        color: Colors.grey[900],
                        fontSize: 16,
                      ),
                    )
                  ],
                )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          widget.courseScore.toString(),
                          style: new TextStyle(fontSize: 16),
                        ),
                        fiveStars(widget.courseScore, 28),
                      ],
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
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
