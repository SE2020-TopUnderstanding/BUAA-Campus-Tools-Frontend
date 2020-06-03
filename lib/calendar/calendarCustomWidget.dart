import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiaowuassistent/calendar/calendar.dart';

enum RCalendarType {
  //正常
  normal,
  //不可用
  disable,
  //不是同一个月
  differentMonth,
  //选中的
  selected,
  //当天
  today,
}

abstract class RCalendarCustomWidget {
  // 如果你想设置第一天是星期一，请更改MaterialLocalizations 的firstDayOfWeekIndex
  // 日 一 二 三 四 五 六
  //构建头部
  List<Widget> buildWeekListWidget(
      BuildContext context, MaterialLocalizations localizations);

  // 1 2 3 4 5 6 7
  //构建普通的日期
  Widget buildDateTime(
      BuildContext context,
      DateTime time,
      List<RCalendarType> types,
      Map<DateTime, String> holidayMap,
      Map<DateTime, int> ddlCount);

  // <  2019年 11月 >
  //构建年份和月份,指示器
  Widget buildTopWidget(BuildContext context, RCalendarController controller);

  //是否不可用,不可用时，无点击事件
  bool isUnable(BuildContext context, DateTime time, bool isSameMonth);

  //点击拦截，当返回true时进行拦截，就不会改变选中日期
  FutureOr<bool> clickInterceptor(BuildContext context, DateTime dateTime);

  //子view的高度
  double get childHeight;
}

class DefaultRCalendarCustomWidget extends RCalendarCustomWidget {
  @override
  Widget buildDateTime(
      BuildContext context,
      DateTime time,
      List<RCalendarType> types,
      Map<DateTime, String> holidayMap,
      Map<DateTime, int> ddlCount) {
    TextStyle childStyle;
    BoxDecoration decoration;

    if (types.contains(RCalendarType.disable) ||
        types.contains(RCalendarType.differentMonth)) {
      childStyle = TextStyle(
        color: Colors.grey[400],
        fontSize: 18,
      );
      decoration = BoxDecoration();
    }
    if (types.contains(RCalendarType.normal)) {
      if (time.weekday == 7 ||
          time.weekday == 6 ||
          holidayMap.containsKey(time)) {
        childStyle = TextStyle(
          color: Colors.pink,
          fontSize: 18,
        );
      } else {
        childStyle = TextStyle(
          color: Colors.black,
          fontSize: 18,
        );
      }
      decoration = BoxDecoration();
    }

    if (types.contains(RCalendarType.today)) {
      childStyle = TextStyle(
        color: Color(0xFF1565C0),
        fontSize: 18,
      );
    }

    if (types.contains(RCalendarType.selected)) {
      childStyle = TextStyle(
        color: Colors.white,
        fontSize: 18,
      );
      decoration = BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF1565C0),
      );
    }

    if (!ddlCount.containsKey(time)) {
      return Tooltip(
        message: MaterialLocalizations.of(context).formatFullDate(time),
        child: Container(
          decoration: decoration,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                time.day.toString(),
                style: childStyle,
              ),
              Text(
                " ",
                style: TextStyle(color: childStyle.color, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    } else {
      return Tooltip(
        message: MaterialLocalizations.of(context).formatFullDate(time),
        child: Container(
          decoration: decoration,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                time.day.toString(),
                style: childStyle,
              ),
              Text(
                "${ddlCount[time]}个待办",
                style: TextStyle(color: childStyle.color, fontSize: 10),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  List<Widget> buildWeekListWidget(
      BuildContext context, MaterialLocalizations localizations) {
    List<Widget> list = [];
    List<String> weekdayText = <String>[
      '一',
      '二',
      '三',
      '四',
      '五',
      '六',
      '日',
    ];
    //list = localizations.narrowWeekdays
    list = weekdayText
        .map(
          (d) => Expanded(
            child: ExcludeSemantics(
              child: Container(
                height: 40,
                alignment: Alignment.topCenter,
                child: Text(
                  d,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w100),
                ),
              ),
            ),
          ),
        )
        .toList();
    list.insert(
      0,
      Expanded(
        //表头
        child: ExcludeSemantics(
          child: Container(
            height: 40,
            alignment: Alignment.topCenter,
            child: Text(
              "周号",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w100),
            ),
          ),
        ),
      ),
    );
    return list;
  }

  @override
  double get childHeight => 50;

  @override
  FutureOr<bool> clickInterceptor(BuildContext context, DateTime dateTime) {
    return false;
  }

  @override
  bool isUnable(BuildContext context, DateTime time, bool isSameMonth) {
    return isSameMonth;
  }

  @override
  Widget buildTopWidget(BuildContext context, RCalendarController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            controller.previousPage();
          },
        ),
        SizedBox(
          width: 16,
        ),
        Text(
          DateFormat('yyyy-MM').format(controller.displayedMonthDate),
          style: TextStyle(color: Colors.black87, fontSize: 18),
        ),
        SizedBox(
          width: 16,
        ),
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: () {
            controller.nextPage();
          },
        ),
      ],
    );
  }
}
