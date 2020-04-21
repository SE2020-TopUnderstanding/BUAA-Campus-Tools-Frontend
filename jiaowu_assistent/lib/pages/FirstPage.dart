import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'CourseCenterPage.dart';
import 'CourseTablePage.dart';
import 'ScorePage.dart';
import 'package:jiaowuassistent/GlobalUser.dart';
import 'package:provider/provider.dart';

class FirstPage extends StatelessWidget {
  int choice;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiProvider(
      providers:[ ChangeNotifierProvider.value(notifier: PageSelect())],
      child:Consumer<PageSelect>(
        builder:(BuildContext context, PageSelect, Widget child){
          choice = PageSelect.choice;
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: getFirstPage(choice),
            ),
          );
        }
      ),
    );
  }
}

Widget getFirstPage(int type){
  switch(type) {
    case 1:
      return CourseTablePage();
    case 2:
      return ScorePage();
    case 3:
      return CourseCenterPage();
    default:
      return CourseTablePage();
  }
}
