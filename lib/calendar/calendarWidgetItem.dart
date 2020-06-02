import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'calendarUtils.dart';
import 'calendarCustomWidget.dart';
import 'calendarController.dart';
import 'calendar.dart';

class RCalendarMonthItem extends StatelessWidget {
  final DateTime monthDate;

  const RCalendarMonthItem({Key key, this.monthDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RCalendarMarker data = RCalendarMarker.of(context);
    RCalendarController controller = data.notifier;
    Map<DateTime, String> weekMap = data.weekNumberMap;
    Map<DateTime, String> holidayMap = new Map();
    for (int i = 0; i < data.holidays.length; i++) {
      holidayMap[data.holidays[i].date] = data.holidays[i].holiday;
    }
    Map<DateTime, int> ddlMap = new Map();
    for (int i = 0; i < data.ddls.length; i++) {
      ddlMap[data.ddls[i].ddlDay] =
          data.ddls.where((c) => c.ddlDay == data.ddls[i].ddlDay).length;
    }
    //获取星期的第一天
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final int year = monthDate.year;
    final int month = monthDate.month;
    final int dayInMonth = RCalendarUtils.getDaysInMonth(year, month);
    //第一天的偏移
    final int firstDayOffset =
        RCalendarUtils.computeFirstDayOffset(year, month, localizations);

    final List<Widget> labels = [];

    for (int i = 0; true; i += 1) {
      final int day = i - firstDayOffset + 1;

      if (day > dayInMonth && i % 7 == 0) break; // 大于当月最大日期和可以除以7
      if (day < 1) {
        //小于当月的日期
        List<RCalendarType> types = [RCalendarType.differentMonth];
        final DateTime dayToBuild =
            DateTime(year, month, 1).subtract(Duration(days: (day * -1) + 1));

        final bool disabled = dayToBuild.isAfter(controller.lastDate) ||
            dayToBuild.isBefore(controller.firstDate) ||
            (data.customWidget != null &&
                !data.customWidget.isUnable(context, dayToBuild, false));
        if (disabled) {
          types.add(RCalendarType.disable);
        }

        if (!disabled) {
          labels.add(GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              if (await data.customWidget
                  .clickInterceptor(context, dayToBuild)) {
                return;
              }
              data.onChanged(dayToBuild);
            },
            child: data.customWidget
                .buildDateTime(context, dayToBuild, types, holidayMap, ddlMap),
          ));
        } else {
          labels.add(data.customWidget
              .buildDateTime(context, dayToBuild, types, holidayMap, ddlMap));
        }
      } else if (day > dayInMonth) {
        //大于当月的日期
        List<RCalendarType> types = [RCalendarType.differentMonth];
        final DateTime dayToBuild = DateTime(year, month, dayInMonth)
            .add(Duration(days: day - dayInMonth));

        final bool disabled = dayToBuild.isAfter(controller.lastDate) ||
            dayToBuild.isBefore(controller.firstDate) ||
            (data.customWidget != null &&
                !data.customWidget.isUnable(context, dayToBuild, false));
        if (disabled) {
          types.add(RCalendarType.disable);
        }

        if (!disabled) {
          labels.add(GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              if (await data.customWidget
                  .clickInterceptor(context, dayToBuild)) {
                return;
              }
              data.onChanged(dayToBuild);
            },
            child: data.customWidget
                .buildDateTime(context, dayToBuild, types, holidayMap, ddlMap),
          ));
        } else {
          labels.add(data.customWidget
              .buildDateTime(context, dayToBuild, types, holidayMap, ddlMap));
        }
      } else {
        List<RCalendarType> types = [RCalendarType.disable];
        final DateTime dayToBuild = DateTime(year, month, day);
        final bool disabled = dayToBuild.isAfter(controller.lastDate) ||
            dayToBuild.isBefore(controller.firstDate) ||
            (data.customWidget != null &&
                !data.customWidget.isUnable(context, dayToBuild, true));
        if (disabled) {
          types.add(RCalendarType.disable);
        }
        bool isSelectedDay = false;
        try {
          isSelectedDay = controller.selectedDates
                  .where((selectedDate) =>
                      selectedDate.year == year &&
                      selectedDate.month == month &&
                      selectedDate.day == day)
                  .length !=
              0;
        } catch (_) {}
        if (isSelectedDay) {
          types.add(RCalendarType.selected);
        }
        final bool isToday = data.toDayDate.year == year &&
            data.toDayDate.month == month &&
            data.toDayDate.day == day;
        if (isToday) {
          types.add(RCalendarType.today);
        }
        if (!disabled && !isSelectedDay && !isToday) {
          types.add(RCalendarType.normal);
        }

        if (!disabled) {
          labels.add(GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              if (await data.customWidget
                  .clickInterceptor(context, dayToBuild)) {
                return;
              }
              data.onChanged(dayToBuild);
            },
            child: data.customWidget
                .buildDateTime(context, dayToBuild, types, holidayMap, ddlMap),
          ));
        } else {
          labels.add(data.customWidget
              .buildDateTime(context, dayToBuild, types, holidayMap, ddlMap));
        }
      }
    }

    DateTime mondayDate = monthDate.add(Duration(days: -monthDate.weekday + 1));

    ///添加周号
    int lines = labels.length ~/ 7;
    List<Widget> weekNumbers = [];
    for (int i = 0; i < lines; i++) {
      if (weekMap.containsKey(mondayDate)) {
        weekNumbers.add(Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${weekMap[mondayDate]}',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Text(
                " ",
                style: TextStyle(fontSize: 14.5),
              ),
            ],
          ),
        ));
      } else {
        weekNumbers.add(Container(
          alignment: Alignment.center,
          child: Text(
            ' ',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ));
      }
      mondayDate = mondayDate.add(Duration(days: 7));
    }
    List<Widget> labelss = [];
    for (int i = 0; i < lines; i++) {
      labelss.add(weekNumbers[i]);
      labelss..addAll(labels.sublist(7 * i, 7 * (i + 1)));
    }

    return GridView.custom(
      key: ValueKey<int>(month),
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: _DayPickerGridDelegate(data.customWidget.childHeight ?? 42),
      childrenDelegate:
          SliverChildListDelegate(labelss, addRepaintBoundaries: true),
    );
  }
}

class RCalendarWeekItem extends StatelessWidget {
  final DateTime weekDate;

  const RCalendarWeekItem({Key key, this.weekDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RCalendarMarker data = RCalendarMarker.of(context);
    RCalendarController controller = data.notifier;

    final List<Widget> labels = [];
    for (int i = 0; i < 7; i += 1) {
      final DateTime dayToBuild =
          DateTime(weekDate.year, weekDate.month, weekDate.day + i);
      final int year = dayToBuild.year;
      final int month = dayToBuild.month;
      final int day = dayToBuild.day;
      List<RCalendarType> types = [];
      final bool disabled = dayToBuild.isAfter(controller.lastDate) ||
          dayToBuild.isBefore(controller.firstDate) ||
          (data.customWidget != null &&
              !data.customWidget.isUnable(context, dayToBuild, true));
      if (disabled) {
        types.add(RCalendarType.disable);
      }
      bool isSelectedDay = false;
      try {
        isSelectedDay = controller.selectedDates
                .where((selectedDate) =>
                    selectedDate.year == year &&
                    selectedDate.month == month &&
                    selectedDate.day == day)
                .length !=
            0;
      } catch (_) {}
      if (isSelectedDay) {
        types.add(RCalendarType.selected);
      }
      final bool isToday = data.toDayDate.year == year &&
          data.toDayDate.month == month &&
          data.toDayDate.day == day;
      if (isToday) {
        types.add(RCalendarType.today);
      }
      if (!disabled && !isSelectedDay && !isToday) {
        types.add(RCalendarType.normal);
      }
      if (!disabled) {
        labels.add(GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            if (await data.customWidget.clickInterceptor(context, dayToBuild)) {
              return;
            }
            data.onChanged(dayToBuild);
          },
          //child: data.customWidget.buildDateTime(context, dayToBuild, types),
          child: Text(' '),
        ));
      } else {
        //labels.add(data.customWidget.buildDateTime(context, dayToBuild, types));
        labels.add(Text(' '));
      }
    }
    return GridView.custom(
      key: ValueKey<String>(weekDate.toIso8601String()),
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: _DayPickerGridDelegate(data.customWidget.childHeight ?? 42),
      childrenDelegate:
          SliverChildListDelegate(labels, addRepaintBoundaries: true),
    );
  }
}

class _DayPickerGridDelegate extends SliverGridDelegate {
  final double childHeight;

  const _DayPickerGridDelegate(this.childHeight);

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    const int columnCount = DateTime.daysPerWeek + 1;
    final double tileWidth = constraints.crossAxisExtent / columnCount;
    return SliverGridRegularTileLayout(
      crossAxisCount: columnCount,
      mainAxisStride: childHeight,
      crossAxisStride: tileWidth,
      childMainAxisExtent: childHeight,
      childCrossAxisExtent: tileWidth,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_DayPickerGridDelegate oldDelegate) => false;
}
