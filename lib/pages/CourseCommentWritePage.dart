import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jiaowuassistent/GlobalUser.dart';
import '../encrypt.dart';
import 'dart:async';

class CourseCommentWritePage extends StatefulWidget {
  final String bname;
  final String bid;
  final String commentText;
  final double score;

  CourseCommentWritePage({this.bname, this.bid, this.commentText, this.score});

  @override
  _CourseCommentWritePage createState() {
    return _CourseCommentWritePage();
  }
}

class _CourseCommentWritePage extends State<CourseCommentWritePage> {
  TextEditingController commentController = new TextEditingController();
  FocusNode commentNode = new FocusNode();
  List<bool> iconsState = new List(5);
  List<Icon> icons = new List(5);
  bool _enable = false;
  double score;

  @override
  void initState() {
    print('init');
    score = widget.score;
    if (score == null) {
      score = 0.0;
    }
    iconsState = [false, false, false, false, false];
    for (int i = 0; i < score.round(); i++) {
      iconsState[i] = true;
    }
    for (int i = 0; i < 5; i++) {
      icons[i] = (iconsState[i] == true)
          ? Icon(
              Icons.star,
              size: 40,
              color: Colors.deepOrange,
            )
          : Icon(Icons.star, size: 40, color: Colors.grey);
    }
    /*
    if (widget.commentText== null) {
      _enable = true;
    } else {
      _enable = false;
    }

     */
    commentController.text = widget.commentText;
    super.initState();
  }

  Widget star(int number) {
    return IconButton(
      padding: EdgeInsets.all(0),
      icon: icons[number - 1],
      onPressed: () {
        setState(() {
          for (int i = 0; i < 5; i++) {
            if (i < number) {
              iconsState[i] = true;
            } else {
              iconsState[i] = false;
            }
          }
          for (int i = 0; i < 5; i++) {
            icons[i] = (iconsState[i] == true)
                ? Icon(
                    Icons.star,
                    size: 40,
                    color: Colors.deepOrange,
                  )
                : Icon(Icons.star, size: 40, color: Colors.grey);
          }
          score = number.toDouble();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("build_write");
    return Scaffold(
      appBar: AppBar(
        title: Text("评价课程", style: TextStyle(color: Colors.grey[100])),
      ),
      backgroundColor: Colors.grey[100],
      body: GestureDetector(
        onTap: () {
          commentNode.unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
                child: Text(
                  "${widget.bname}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "评分",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    star(1),
                    star(2),
                    star(3),
                    star(4),
                    star(5),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//                decoration: BoxDecoration(
//                  border: new Border.all(width: 2.0, color: Colors.black12),
//                  borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
//                ),
                child: TextField(
                  enabled: true,
                  maxLines: 12,
                  focusNode: commentNode,
                  controller: commentController,
                  decoration: InputDecoration(
                    hoverColor: Color(0xFF1565C0),
                    border: OutlineInputBorder(
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(10.0)),
                    ),

                    hintText: '请输入你对课程的评价',
//                    border: InputBorder.none,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 50),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Text(
                        '发布',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            letterSpacing: 20,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white),
                      ),
                      color: Color(0xFF1565C0),
                      disabledColor: Colors.grey,
                      onPressed: () {
                        if (score == 0.0) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text("您还未评分(最低一星)，请填写后发布"),
                                  actions: <Widget>[
                                    RaisedButton(
                                      child: Text("确定"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        } else if (commentController.text.length == 0) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text("您还未填写评价内容，请填写后发布"),
                                  actions: <Widget>[
                                    RaisedButton(
                                      child: Text("确定"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('确定发布?'),
                                  actions: <Widget>[
                                    RaisedButton(
                                      child: Text("发布"),
                                      onPressed: () {
                                        //此处添加向后端的put操作。
                                        Navigator.of(context).pop();
                                        putComment(
                                            commentController.text, score);
                                      },
                                    ),
                                    RaisedButton(
                                      child: Text("取消"),
                                      onPressed: () {
                                        //此处添加向后端的put操作。
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void putComment(String comment, double star) async {
    //Url请求
    BaseOptions options = new BaseOptions(
      connectTimeout: 30000,
      sendTimeout: 30000,
      receiveTimeout: 30000,
    );
    Response response;
    Dio dio = new Dio(options);

    try {
      showLoading(context);
      response = await dio.request(
        'http://114.115.208.32:8000/timetable/evaluation/student/',
        data: {
          "bid": widget.bid,
          "text": comment,
          "score": star,
          "student_id": Encrypt.encrypt2(GlobalUser.studentID)
        },
        options: Options(method: "PUT", responseType: ResponseType.json),
      );
      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("发布成功"),
            actions: <Widget>[
              RaisedButton(
                child: Text("确定"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      //  setTextEnable();
    } on DioError catch (e) {
      print("error type:${e.type},");
      Navigator.of(context).pop();
      if ((e.type == DioErrorType.CONNECT_TIMEOUT) ||
          (e.type == DioErrorType.RECEIVE_TIMEOUT) ||
          (e.type == DioErrorType.SEND_TIMEOUT)) {
        showError(context, "网络请求超时");
      } else if (e.type == DioErrorType.RESPONSE) {
        if (e.response.statusCode == 401) {
          showError(context, "您的账户不存在于我们的数据库");
        } else if (e.response.statusCode == 404) {
          showError(context, "课程不存在");
        } else if (e.response.statusCode == 500) {
          showError(context, "评论存在不合法字符\n请不要出现表情包等特殊字符");
        } else {
          print(e.response.statusCode);
          showError(context, "前端写错了，请联系我们团队，谢谢！");
        }
      } else if (e.type == DioErrorType.CANCEL) {
        showError(context, "请求取消");
      } else {
        showError(context, "http ${e.response.statusCode}");
      }
    } catch (e) {
      print("未知错误");
    }
  }

  void setTextEnable() {
    setState(() {
      _enable = !_enable;
    });
  }

  void showError(context, String str) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            titlePadding: EdgeInsets.fromLTRB(24.0, 14.0, 24.0, 0.0),
            title: Text(
              '错  误',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              Text(
                str,
                textAlign: TextAlign.center,
              ),
            ],
          );
        });
  }

  void showLoading(context, [String text]) {
    text = text ?? "发布中";
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
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        text,
                        style: Theme.of(context).textTheme.body2,
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
}

//bug日志，之前星级评价的Ui在更改星级后不发生改变，后来发现，updateWidget 与 setState的更新流程不同。
