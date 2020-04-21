import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Grade {
  String name;
  double credit;
  int score;

  Grade(this.name, this.credit, this.score);

  Grade.fromJson(Map<String, dynamic> json) {
    name = json['course_name'];
    credit = json['credit'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['course_name'] = this.name;
    data['credit'] = this.credit;
    data['score'] = this.score;
    return data;
  }
}

//List<Grade> grades = <Grade>[Grade('计算机网络', 3, 90), Grade('软件工程', 2, 93)];

class ScorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<DataRow> dateRows = [];
    double sumScore = 0;
    double sumCredit = 0;

    return new Scaffold(
        appBar: new AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: new Text('成绩查询'),
//          backgroundColor: Colors.lightBlue,
          automaticallyImplyLeading: false,
        ),
        body: Score());
  }
}

class Score extends StatelessWidget {

  List<Grade> grades = <Grade>[Grade('计算机网络', 3, 90), Grade('软件工程', 2, 93)];

  Widget build(BuildContext context) {
    Map<String, dynamic> data;
    List<DataRow> dataRows = [];
    double sumScore = 0;
    double sumCredit = 0;

    for (int i = 0; i < 2; i++) {
      dataRows.add(DataRow(
//        selected: grades[i].selected,
        cells: [
          DataCell(Text('${grades[i].name}')),
          DataCell(Text('${grades[i].credit}')),
          DataCell(Text('${grades[i].score}')),
        ],
      ));
//      sumScore += grades[i].score;
//      sumCredit += grades[i].credit;
    }
    return new Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child:
        ListView(
          children: <Widget>[
            DataTable(
                sortColumnIndex: 1,
                sortAscending: true,
                columns: [
                  DataColumn(label: Text('科目')),
                  DataColumn(label: Text('学分')),
                  DataColumn(label: Text('成绩')),
                ],
                rows: dataRows),
//            RaisedButton(
//              color: Colors.lightBlue,
//              shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.all(Radius.circular(30)),
//              ),
//              child: Text(
//                '刷新',
//                textAlign: TextAlign.center,
//                style: TextStyle(
//                    letterSpacing: 20,
//                    fontSize: 20,
//                    color: Colors.black54),
//              ),
//              onPressed: () {},
//            ),
          ],
        ),
      ),
    );
  }
}

class AverageScore extends StatelessWidget {
  Widget build(BuildContext context) {
    return new SizedBox(
      width: 200.0,
      height: 50.0,
    );
  }
}

class RefreshButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      width: 200.0,
      height: 50.0,
      child: new RaisedButton(
        color: Colors.lightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Text(
          '刷新',
          textAlign: TextAlign.center,
          style: TextStyle(
              letterSpacing: 20,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black54),
        ),
        onPressed: () {},
      ),
    );
  }
}
