import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../GlobalUser.dart';
import 'CourseCenterPage.dart';
import 'CourseTablePage.dart';
import 'ScorePage.dart';
import 'CourseEvaluationPage.dart';
import 'CalendarPage.dart';
import 'package:jiaowuassistent/GlobalUser.dart';
import 'package:provider/provider.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PageSelect page = Provider.of<PageSelect>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: getFirstPage(page.choice),
      ),
    );
  }
}

Widget getFirstPage(int type) {
  switch (type) {
    case 1:
      return CourseTablePage();
    case 2:
      return ScorePage();
    case 3:
      return CourseCenterPage();
    case 4:
      return CourseEvaluationPage();
    case 5:
      return CalendarPage();
    default:
      return CourseTablePage();
  }
}
