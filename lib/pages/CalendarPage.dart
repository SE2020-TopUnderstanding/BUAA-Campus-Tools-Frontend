import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/calendar/calendar.dart';
import 'package:jiaowuassistent/pages/User.dart';
import 'package:jiaowuassistent/GlobalUser.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarPage();
  }
}

class _CalendarPage extends State<CalendarPage> {
  RCalendarController controller;
  List<Ddl> ddlList;
  List<Holiday> holidayList;
  Map<DateTime, String> weekNumber;

  @override
  void initState() {
    super.initState();
    print(DateTime.now());
    controller = RCalendarController.single(
      mode: RCalendarMode.month,
      selectedDate: DateTime.now(),
    );
//  controller = RCalendarController.single(selectedDate: DateTime.now(),isAutoSelect: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PageSelect page = Provider.of<PageSelect>(context);
    return Scaffold(
      appBar: AppBar(
//        backgroundColor: Colors.lightBlue,
        title: Text("校历", style: TextStyle(color: Colors.grey[100])),
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder(
          future: getSchoolCalendar(GlobalUser.studentID),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if ((snapshot.connectionState == ConnectionState.done) &&
                (snapshot.hasData)) {
              ddlList = snapshot.data.ddls;
              holidayList = snapshot.data.holidays;
              weekNumber = snapshot.data.weekNumbers;
              return RCalendarWidget(
                controller: controller,
                customWidget: DefaultRCalendarCustomWidget(),
                firstDate: DateTime(1970, 1, 1),
                lastDate: DateTime(2055, 12, 31),
                weekNumberMap: weekNumber,
                holidays: holidayList,
                ddls: ddlList,
              );
            } else {
              if (snapshot.hasError) {
                if (snapshot.error == 401) {
                  return Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("账号密码已失效，\n这可能是因为您修改了统一认证密码，\n请点击下方按钮以重新登录。"),
                        SizedBox(
                          height: 30,
                        ),
                        RaisedButton(
                          child: Text("重新登录"),
                          onPressed: () {
                            GlobalUser.setIsLogin(false);
                            page.setPage(1);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/loginPage', (Route route) => false);
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container(
                    alignment: Alignment.center,
                    child: Text(
                      "${snapshot.error.toString()}",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              }
              return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Color(0xFF1565C0)),
                  ));
            }
          }),
    );
  }
}
