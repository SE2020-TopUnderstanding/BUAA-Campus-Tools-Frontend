import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Grade {
  final String name;
  final double credit;
  final int score;
  bool selected = false; //默认为未选中
  Grade(
    this.name,
    this.credit,
    this.score,
  );
}

List<Grade> grades = <Grade>[Grade('计算机网络', 3, 90), Grade('软件工程', 2, 93)];

class ScorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<DataRow> dateRows = [];
    double sumScore = 0;
    double sumCredit = 0;

    for (int i = 0; i < grades.length; i++) {
      dateRows.add(DataRow(
        selected: grades[i].selected,
        cells: [
          DataCell(Text('${grades[i].name}')),
          DataCell(Text('${grades[i].credit}')),
          DataCell(Text('${grades[i].score}')),
        ],
      ));
      sumScore += grades[i].score;
      sumCredit += grades[i].credit;
    }
    return new Scaffold(
        appBar: new AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: new Text('成绩查询'),
          backgroundColor: Colors.lightBlue,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: <Widget>[
              DataTable(
                  sortColumnIndex: 1,
                  sortAscending: true,
                  columns: [
                    DataColumn(label: Text('科目')),
                    DataColumn(label: Text('学分')),
                    DataColumn(label: Text('成绩')),
                  ],
                  rows: dateRows
              )
            ],
          ),
        ),
        floatingActionButton: RaisedButton(
          color: Colors.lightBlue,
          onPressed: () {},
          onHighlightChanged: (b) {
            //If your press down the button ,b is true
            //If your release up the button,b is false
          },
//          textTheme: ButtonTextTheme.primary,
          elevation: 4.0,
          highlightElevation: 8.0,
          disabledElevation: 0.0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.black,
              width: 3.0,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          animationDuration: const Duration(milliseconds: 200),
          child: Text('刷新'),
        ));
  }
}
