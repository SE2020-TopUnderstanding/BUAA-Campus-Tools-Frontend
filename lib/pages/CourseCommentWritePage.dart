import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class courseCommentWritePage extends StatefulWidget{
  String bname;
  courseCommentWritePage({this.bname});
  @override
  _courseCommentWritePage createState() {
    // TODO: implement createState
    return _courseCommentWritePage();
  }
}

class _courseCommentWritePage extends State<courseCommentWritePage>{
  double score;
  TextEditingController commentController = new TextEditingController();
  FocusNode commentNode = new FocusNode();
  List<bool> iconsState = new List(5);
  List<Icon> icons = new List(5);

  @override
  void initState() {
    print('init');
    // TODO: implement initState
    score = 5.0;
    iconsState = [true,true,true,true,true];
    for(int i =0 ; i < 5; i++){
      icons[i] = (iconsState[i] == true) ?
      Icon(Icons.star,size: 50,color: Colors.deepOrange,) :
      Icon(Icons.star,size: 50,color: Colors.grey);
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    print("change");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(courseCommentWritePage oldWidget) {
    // TODO: implement didUpdateWidget
    print("update");
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //print(icons.length);
    return Scaffold(
      appBar: AppBar(
        title: Text("评价课程"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              if (commentController.text.length == 0) {
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
                    }
                );
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
                            },
                          ),
                          RaisedButton(
                            child: Text("我再想想"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }
                );
              }
            },
          ),
        ],
      ),
      body: GestureDetector(
          onTap: (){
            commentNode.unfocus();
          },
        child: SingleChildScrollView(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                child: Text(
                  "${widget.bname}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("评分",style: TextStyle(fontSize: 20),),
                    SizedBox(width: 20,),
                    IconButton(
                      padding: EdgeInsets.all(0),
                      icon: icons[0],
                      onPressed: (){
                        setState(() {
                          score = 1.0;
                          iconsState = [true,false,false,false,false];
                        });
                        print(iconsState.toString());
                      },
                    ),
                    IconButton(
                      padding: EdgeInsets.all(0),
                      icon: icons[1],
                      onPressed: (){
                        setState(() {
                          score = 2.0;
                          iconsState = [true,true,false,false,false];
                          print(iconsState.toString());
                        });
                      },
                    ),
                    IconButton(
                      padding: EdgeInsets.all(0),
                      icon: icons[2],
                      onPressed: (){
                        setState(() {
                          score = 3.0;
                          iconsState = [true,true,true,false,false];
                          print(iconsState.toString());
                        });
                      },
                    ),
                    IconButton(
                      padding: EdgeInsets.all(0),
                      icon: icons[3],
                      onPressed: (){
                        setState(() {
                          score = 4.0;
                          iconsState = [true,true,true,true,false];
                          print(iconsState.toString());
                        });
                      },
                    ),
                    IconButton(
                      padding: EdgeInsets.all(0),
                      icon: icons[4],
                      onPressed: (){
                        setState(() {
                          score = 5.0;
                          iconsState = [true,true,true,true,true];
                          print(iconsState.toString());
                        });
                      },
                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  border: new Border.all(width: 2.0, color: Colors.black12),
                  borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                ),
                child: TextField(
                  maxLines: 12,
                  focusNode: commentNode,
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: '请输入你对课程的评价',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
