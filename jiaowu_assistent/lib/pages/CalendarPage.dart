
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/calendar/calendar.dart';

class CalendarPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CalendarPage();
  }
}

class _CalendarPage extends State<CalendarPage>{
  RCalendarController controller;

  @override
  void initState() {
    super.initState();
    controller = RCalendarController.single(mode: RCalendarMode.month,selectedDate: DateTime.now(),);
//    controller = RCalendarController.single(selectedDate: DateTime.now(),isAutoSelect: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("校历"),
      ),
      body: RCalendarWidget(
        controller: controller,
        customWidget: DefaultRCalendarCustomWidget(),
        firstDate: DateTime(1970, 1, 1),
        lastDate: DateTime(2055, 12, 31),
      ),
    );
  }
}