import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/User.dart';

class FeedbackDetailPage extends StatefulWidget {
  final String kind;

  FeedbackDetailPage({Key key, @required this.kind}) : super(key: key);

  @override
  _FeedbackDetailPage createState() {
    return _FeedbackDetailPage();
  }
}

class _FeedbackDetailPage extends State<FeedbackDetailPage> {
  String content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.kind}问题描述'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(30, 30, 30, 0),
            child: TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
//                hoverColor: Colors.lightBlue,
                border: OutlineInputBorder(),
                hintText: '请描述详情',
              ),
              onChanged: (String str) {
                content = str;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
            child: ConstrainedBox(
              constraints: BoxConstraints.expand(height: 50),
              child: RaisedButton(
                color: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Text(
                  '提交',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      letterSpacing: 20,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white),
                ),
                onPressed: () {
                  postMessage(widget.kind, content);
                },
                disabledColor: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
