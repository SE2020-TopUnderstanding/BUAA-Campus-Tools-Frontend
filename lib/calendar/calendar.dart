import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/User.dart';
import 'calendarWidgetItem.dart';
import 'calendarController.dart';
import 'calendarUtils.dart';
import 'calendarCustomWidget.dart';

export 'calendarController.dart';
export 'calendarWidgetItem.dart';
export 'calendarCustomWidget.dart';

class RCalendarWidget extends StatefulWidget {
  // 最小日期
  final DateTime firstDate;

  // 最大日期
  final DateTime lastDate;

  // 控制器
  final RCalendarController controller;

  //自定义部件
  final RCalendarCustomWidget customWidget;

  //ddl
  final Map<DateTime, String> weekNumberMap;

  //holiday
  final List<Holiday> holidays;

  //ddl
  final List<Ddl> ddls;

  const RCalendarWidget(
      {Key key,
      this.firstDate,
      this.lastDate,
      this.controller,
      this.customWidget,
      this.weekNumberMap,
      this.holidays,
      this.ddls})
      : super(key: key);

  @override
  _RCalendarWidgetState createState() => _RCalendarWidgetState();
}

class _RCalendarWidgetState extends State<RCalendarWidget> {
  //今天的日期
  DateTime _toDayDate;

  //用于更新今天
  Timer _timer;

  ///选中日期更改
  void _handleDayChanged(DateTime value) {
    setState(() {
      widget.controller.updateSelected(value);
    });
  }

  /// 更新当前日期
  void _updateCurrentDate() {
    _toDayDate = DateTime.now();
    final DateTime tomorrow =
        DateTime(_toDayDate.year, _toDayDate.month, _toDayDate.day + 1);
    Duration timeUntilTomorrow = tomorrow.difference(_toDayDate);
    timeUntilTomorrow +=
        const Duration(seconds: 1); // so we don't miss it by rounding
    _timer?.cancel();
    _timer = Timer(timeUntilTomorrow, () {
      setState(() {
        _updateCurrentDate();
      });
    });
  }

  ///处理月份页改变
  void _handlePageChanged(int page, RCalendarMode mode) {
    setState(() {
      widget.controller.updateDisplayedDate(page, mode);
    });
  }

  @override
  void initState() {
    super.initState();
    widget.controller.initial(context, widget.firstDate, widget.lastDate);
    _updateCurrentDate();
  }

  @override
  void didUpdateWidget(RCalendarWidget oldWidget) {
    if (widget.controller.isMultiple == false) {
      DateTime firstDate = widget.controller.selectedDate;
      if (firstDate != null) {
        if (firstDate.month != widget.controller.displayedMonthDate.month ||
            firstDate.year != widget.controller.displayedMonthDate.year) {
          if (widget.controller.isMonthMode) {
            widget.controller.monthController
                .jumpToPage(widget.controller.selectedPage);
          } else {
            widget.controller.weekController
                .jumpToPage(widget.controller.selectedPage);
          }
        }
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  int _getSelectRowCount() {
    if (!widget.controller.isMonthMode) return 1;
    int rowCount = 4;
    int maxDay = RCalendarUtils.getDaysInMonth(
        widget.controller.displayedMonthDate.year,
        widget.controller.displayedMonthDate.month);
    int labelCount = maxDay +
        RCalendarUtils.computeFirstDayOffset(
            widget.controller.displayedMonthDate.year,
            widget.controller.displayedMonthDate.month,
            MaterialLocalizations.of(
                context)); ///////////////////////////////////////
    if (labelCount <= 7 * 4) {
      rowCount = 4;
    } else if (labelCount <= 7 * 5) {
      rowCount = 5;
    } else if (labelCount <= 7 * 6) {
      rowCount = 6;
    }
    return rowCount;
  }

  @override
  Widget build(BuildContext context) {
    double maxHeight =
        widget.customWidget.childHeight * _getSelectRowCount() + 1;
    //获取星期的第一天
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return RCalendarMarker(
      customWidget: widget.customWidget,
      toDayDate: _toDayDate,
      onChanged: _handleDayChanged,
      controller: widget.controller,
      weekNumberMap: widget.weekNumberMap,
      holidays: widget.holidays,
      ddls: widget.ddls,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          widget.customWidget.buildTopWidget(context, widget.controller) ??
              Container(),
          SizedBox(
            height: 7,
          ),
          Row(
            children: widget.customWidget.buildWeekListWidget(
                context, localizations), /////////////////////////////
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: maxHeight,
            child: IndexedStack(
              index: widget.controller.isMonthMode ? 1 : 0,
              children: <Widget>[
                PageView.builder(
                  key: ValueKey("week_view"),
                  controller: widget.controller.weekController,
                  itemBuilder: _builderWeekItems,
                  onPageChanged: (int page) {
                    _handlePageChanged(page, RCalendarMode.week);
                  },
                  itemCount: widget.controller.maxPage,
                ),
                PageView.builder(
                  key: ValueKey("month_view"),
                  controller: widget.controller.monthController,
                  itemBuilder: _builderMonthItems,
                  onPageChanged: (int page) {
                    _handlePageChanged(page, RCalendarMode.month);
                  },
                  itemCount: widget.controller.maxPage,
                ),
              ],
            ),
          ),
          buildEvent(widget.ddls, widget.controller.selectedDate),
        ],
      ),
    );
  }

  Widget _builderMonthItems(BuildContext context, int index) {
    final DateTime month =
        RCalendarUtils.addMonthsToMonthDate(widget.firstDate, index);
    return RCalendarMonthItem(
      monthDate: month,
    );
  }

  Widget buildEvent(List<Ddl> ddls, DateTime selectTime) {
    Iterable<Ddl> ddlForDay = ddls.where((c) =>
        ((c.ddlDay.day == selectTime.day)) &&
        (c.ddlDay.month == selectTime.month) &&
        (c.ddlDay.day == selectTime.day));
    //ddl按时间排序
    List<Ddl> listForDay = ddlForDay.toList();
    listForDay.sort((left, rigth) => left.ddlSecond.compareTo(rigth.ddlSecond));
    List<Widget> ddlList = new List();
    for (int i = 0; i < ddlForDay.length; i++) {
      List<String> timeStr = listForDay[i].ddlSecond.split(':');
      String time = timeStr[0] + ': ' + timeStr[1];
      ddlList.add(SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 5,
              ),
              Text(
                time,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(listForDay[i].course),
                    Text(listForDay[i].homework),
                  ],
                ),
              ),
            ],
          )));
      ddlList.add(Divider(height: 1.0, indent: 0.0, color: Colors.black87));
    }
    //ddlList.removeLast();
    if (ddlList.length == 0) {
      return SizedBox(
        height: 10,
      );
    } else {
      return Expanded(
        //用于colmun嵌套
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 200),
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: new Border.all(width: 2.0, color: Color(0xFF1565C0)),
            borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[]..addAll(ddlList),
            ),
          ),
        ),
      );
    }
  }

  Widget _builderWeekItems(BuildContext context, int index) {
    DateTime week = RCalendarUtils.addWeeksToWeeksDate(
        widget.firstDate, index, MaterialLocalizations.of(context));
    return RCalendarWeekItem(
      weekDate: week,
    );
  }
}

class RCalendarMarker extends InheritedNotifier<RCalendarController> {
  //部件
  final RCalendarCustomWidget customWidget;

  //今天
  final DateTime toDayDate;

  //当前选中的日期事件
  final ValueChanged<DateTime> onChanged;

  //
  final Map<DateTime, String> weekNumberMap;
  final List<Holiday> holidays;
  final List<Ddl> ddls;

  const RCalendarMarker({
    @required this.onChanged,
    @required this.toDayDate,
    @required this.customWidget,
    @required this.weekNumberMap,
    @required this.holidays,
    @required this.ddls,
    @required RCalendarController controller,
    @required Widget child,
  })  : assert(controller != null),
        assert(child != null),
        super(notifier: controller, child: child);

  static RCalendarMarker of(BuildContext context, {bool nullOk: false}) {
    assert(context != null);
    final RCalendarMarker inherited =
        context.dependOnInheritedWidgetOfExactType<RCalendarMarker>();
    assert(() {
      if (nullOk) {
        return true;
      }
      if (inherited == null) {
        throw FlutterError(
            'Unable to find a $RCalendarMarker widget in the context.\n'
            '$RCalendarMarker.of() was called with a context that does not contain a '
            '$RCalendarMarker widget.\n'
            'No $RCalendarMarker ancestor could be found starting from the context that was '
            'passed to $RCalendarMarker.of().\n'
            'The context used was:\n'
            '  $context');
      }
      return true;
    }());
    return inherited;
  }

  @override
  bool updateShouldNotify(RCalendarMarker oldWidget) {
    return this.notifier != oldWidget.notifier ||
        this.toDayDate != toDayDate ||
        this.customWidget != customWidget ||
        this.onChanged != onChanged;
  }
}
