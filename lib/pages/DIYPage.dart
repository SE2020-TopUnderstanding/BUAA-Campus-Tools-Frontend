import 'package:flutter/material.dart';
import 'package:jiaowuassistent/GlobalUser.dart';
import 'package:provider/provider.dart';

class DIYPage extends StatefulWidget {
  @override
  _DIYPage createState() {
    return _DIYPage();
  }
}

class _DIYPage extends State<DIYPage> {
  int choice;

  @override
  Widget build(BuildContext context) {
    final select = Provider.of<PageSelect>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('主页选择', style: TextStyle(color: Colors.grey[100])),
//        backgroundColor: Colors.lightBlue,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: <Widget>[
          SizedBox(height: 30),
          Container(
            margin: const EdgeInsets.only(left: 27),
            alignment: Alignment.centerLeft,
            child: Text(
              '您可以自定义您的主页显示下方几个选项中的任一项',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          Flexible(
            child: RadioListTile(
              title: Text('课表查询'),
              value: 1,
              groupValue: choice,
              onChanged: (value) {
                setState(() {
                  choice = value;
                });
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
              },
            ),
          ),
          Flexible(
            child: RadioListTile(
              title: Text('课程评价'),
              value: 4,
              groupValue: choice,
              onChanged: (value) {
                setState(() {
                  choice = value;
                });
              },
            ),
          ),
          Flexible(
            child: RadioListTile(
              title: Text('校历查询'),
              value: 5,
              groupValue: choice,
              onChanged: (value) {
                setState(() {
                  choice = value;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: MaterialButton(
                onPressed: () {
                  select.setPage(choice);
                  Navigator.pop(context);
                },
                child: Text("确认"),
                color: Color(0x99FFFFFF),
                minWidth: double.infinity,
                height: 50,
              ))
        ],
      ),
    );
  }
}
