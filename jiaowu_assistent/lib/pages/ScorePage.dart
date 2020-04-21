import 'dart:async' show Future;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:jiaowuassistent/pages/User.dart';

class ScorePage extends StatefulWidget {
  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  Future<GradeCenter> gradeCenter;

  @override
  initState() {
    super.initState();
    gradeCenter = getGrade();
  }

  _getDataRows(List<Grade> grades) {
    List<DataRow> dataRows = [];
    double sumScore = 0;
    double sumCredit = 0;
    for (int i = 0; i < grades.length; i++) {
      dataRows.add(DataRow(
        cells: [
          DataCell(Text(
            '${grades[i].name}',
            textAlign: TextAlign.center,
          )),
          DataCell(Text(
            '          ${grades[i].credit}',
            textAlign: TextAlign.center,
          )),
          DataCell(Text(
            '         ${grades[i].score}',
            textAlign: TextAlign.center,
          )),
        ],
      ));
      sumScore += grades[i].score * grades[i].credit;
      sumCredit += grades[i].credit;
    }
    dataRows.add(DataRow(
      cells: [
        DataCell(Text('加权平均分',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(
          '          ',
          textAlign: TextAlign.center,
        )),
        DataCell(Text('      ${(sumScore / sumCredit).toStringAsFixed(2)}',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold))),
      ],
    ));

    return dataRows;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('成绩查询'),
      ),
      body: FutureBuilder<GradeCenter>(
          future: gradeCenter,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Text('课程',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  DataColumn(
                    label: Text('     学分',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  DataColumn(
                    label: Text('    成绩',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                ],
                rows: _getDataRows(snapshot.data.grades),
              ),
            );
          }),
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
