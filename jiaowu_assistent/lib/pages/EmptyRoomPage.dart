import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class EmptyRoomPage extends StatefulWidget {
  @override
  _DateTimeDemoState createState() => _DateTimeDemoState();
}

class _DateTimeDemoState extends State<EmptyRoomPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 9, minute: 30);

  Future<void> _selectDate() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    setState(() {
      selectedDate = date;
    });
  }

//  Future<void> _selectTime() async {
//    final TimeOfDay time = await showTimePicker(
//      context: context,
//      initialTime: selectedTime,
//    );
//
//    if (time == null) return;
//
//    setState(() {
//      selectedTime = time;
//    });
//  }

  static double size = 20;
  TextStyle textStyle = TextStyle(fontSize: size);
  var _valueL, _valueR, _valueA, _valueB;

  List<DropdownMenuItem> getListData() {
    List<DropdownMenuItem> items=
      [
        DropdownMenuItem(child: Text('第一节课'), value: 1,),
        DropdownMenuItem(child: Text('第二节课'), value: 2,),
        DropdownMenuItem(child: Text('第三节课'), value: 3,),
        DropdownMenuItem(child: Text('第四节课'), value: 4,),
        DropdownMenuItem(child: Text('第五节课'), value: 5,),
        DropdownMenuItem(child: Text('第六节课'), value: 6,),
        DropdownMenuItem(child: Text('第七节课'), value: 7,),
        DropdownMenuItem(child: Text('第八节课'), value: 8,),
        DropdownMenuItem(child: Text('第九节课'), value: 9,),
        DropdownMenuItem(child: Text('第十节课'), value: 10,),
        DropdownMenuItem(child: Text('第十一节课'), value: 11,),
        DropdownMenuItem(child: Text('第十二节课'), value: 12,),
        DropdownMenuItem(child: Text('第十三节课'), value: 13,),
        DropdownMenuItem(child: Text('第十四节课'), value: 14,),
      ];
    return items;
  }

  List list = [
    {
      "building": "新主楼",
      "classroom": "G-101"
    },
    {
      "building": "新主楼",
      "classroom": "H-402"
    }
  ];

  Widget _buildListItem(BuildContext context, int index) {
    Map newItem = list[index];
    return Container(
      child: ListTile(
        title:  Text(newItem["classroom"]),
        subtitle: Text(newItem["building"]),
      ),
      decoration: BoxDecoration(border: Border(top: BorderSide(width: 1, color: Colors.black))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('空教室查询'),
          elevation: 0.0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: _selectDate,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.date_range, size: 30,),
                            SizedBox(width: 20,),
                            Text(DateFormat.yMMMMd().format(selectedDate), style: textStyle,),
                            Icon(Icons.arrow_drop_down, size: size,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                CupertinoButton(
                  child: Text("查询"),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.grey,
                  onPressed: (){
//                    this.build(context);
                  },
                  pressedOpacity: 0.8,
                )
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                DropdownButton(
                  value: _valueA,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 30,
                  iconEnabledColor: Colors.black,
                  hint: Text('请选择校区'),
                  items: [
                    DropdownMenuItem(child: Text('沙河校区'), value: 1,),
                    DropdownMenuItem(child: Text('学院路校区'), value: 2,)
                  ],
                  onChanged: (value){
                    setState(() {
                      _valueA = value;
                    });
                  },
                ),
                DropdownButton(
                  value: _valueB,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 30,
                  iconEnabledColor: Colors.black,
                  hint: Text('请选择教学楼'),
                  items: [
                    DropdownMenuItem(child: Text('一号教学楼'), value: 1,),
                    DropdownMenuItem(child: Text('二号教学楼'), value: 2,),
                    DropdownMenuItem(child: Text('新主楼'), value: 3,),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _valueB = value;
                    });
                  },
                )
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  DropdownButton(
                    value: _valueL,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    iconEnabledColor: Colors.black,
                    hint: Text('请选择开始时间段'),
                    items: getListData(),
                    onChanged: (value){
                      setState(() {
                        _valueL = value;
                      });
                    },
                  ),
                  DropdownButton(
                    value: _valueR,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    iconEnabledColor: Colors.black,
                    hint: Text('请选择结束时间段'),
                    items: getListData(),
                    onChanged: (value){
                      setState(() {
                        _valueR = value;
                      });
                    },
                  ),
                ]
            ),
            SizedBox(height: 40,),
            Column(
              children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: (list == null) ? 0 : list.length,
                  itemBuilder: _buildListItem,
                )
              ],
            )
          ],
        )
    );
  }
}