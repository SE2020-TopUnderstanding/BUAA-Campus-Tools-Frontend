import 'package:flutter/material.dart';
import 'package:jiaowuassistent/GlobalUser.dart';
import 'package:provider/provider.dart';

class DIYPage extends StatefulWidget {
  @override
  _DIYPage createState() {
    // TODO: implement createState
    return _DIYPage();
  }
}

class _DIYPage extends State<DIYPage> {
  int choice;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final select = Provider.of<PageSelect>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('自定义主页'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 50),
          SizedBox(
            child: Text('您可以自定义您的主页显示下方三个选项中的任一项'),
          ),
          SizedBox(height: 50),
          Flexible(
            child: RadioListTile(
              title: Text('课表查询'),
              value: 1,
              groupValue: choice,
              onChanged: (value) {
                setState(() {
                  choice = value;
                });
//                select.setPage(value);
              },
            ),
          ),
          Flexible(
            child: RadioListTile(
              title: Text('成绩查询'),
              value: 2,
              groupValue: choice,
              onChanged: (value) {
                setState(() {
                  choice = value;
                });
//                select.setPage(value);
              },
            ),
          ),
          Flexible(
            child: RadioListTile(
              title: Text('课程中心查询'),
              value: 3,
              groupValue: choice,
              onChanged: (value) {
                setState(() {
                  choice = value;
                });
//                select.setPage(value);
              },
            ),
          ),
          FlatButton(
            onPressed: () => {select.setPage(choice)},
            child: Text("确认"),
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}
