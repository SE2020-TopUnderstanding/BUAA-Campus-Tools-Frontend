//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:jiaowuassistent/pages/HelpCenterPage.dart';
//
//class PersonalPage extends StatelessWidget {
////  const PersonalPage({Key, key}) : super(key: key);
//
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Colors.white,
//      appBar: AppBar(
//        backgroundColor: Colors.white,
//        elevation: 0,
//        automaticallyImplyLeading: false,
//      ),
//      body: Column(
//        children: <Widget>[
//          Container(
//            padding: EdgeInsets.all(32.0),
//            color: Colors.white,
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                Expanded(
//                  child: ListTile(
//                    title: Text(
//                      "用户昵称",
//                      style: TextStyle(fontSize: 25),
//                    ),
//                    subtitle: Text("学号"),
//                  ),
//                ),
////                IconButton(
////                  icon: Icon(Icons.edit),
////                  onPressed: () {
////                    showCupertinoDialog(
////                        context: context,
////                        builder: (context) {
////                          return CupertinoAlertDialog(
////                            title: Text('温馨提示'),
////                            content: Card(
////                              elevation: 0.0,
////                              child: Column(
////                                children: <Widget>[
////                                  TextField(
////                                    decoration: InputDecoration(
////                                        hintText: '请输入你的昵称',
////                                        filled: true,
////                                        fillColor: Colors.grey.shade50),
////                                  ),
////                                ],
////                              ),
////                            ),
////                            actions: <Widget>[
////                              CupertinoDialogAction(
////                                onPressed: () {
////                                  Navigator.pop(context);
////                                },
////                                child: Text('取消'),
////                              ),
////                              CupertinoDialogAction(
////                                onPressed: () {
////                                  Navigator.pop(context);
////                                },
////                                child: Text('确定'),
////                              ),
////                            ],
////                          );
////                        }
////                    );
////                  },
////                ),
//                SizedBox(
//                  width: 100,
//                ),
//                CircleAvatar(
//                  backgroundImage: AssetImage("assets/images/head.png"),
//                  radius: 40,
//                ),
//              ],
//            ),
//          ),
//          SizedBox(
//            height: 40,
//          ),
//          Container(
//            color: Colors.white,
//            child: ListTile(
//              leading: Icon(Icons.help_outline),
//              title: Text("帮助中心"),
//              trailing: Icon(Icons.keyboard_arrow_right),
//              onTap: () {
//                Navigator.push(context, MaterialPageRoute(builder: (context) => HelpCenterPage()));
//              },
//            ),
//          ),
////          Container(
////            color: Colors.white,
////            child: ListTile(
////              leading: Icon(Icons.monetization_on),
////              title: Text("主页设计"),
////              trailing: Icon(Icons.keyboard_arrow_right),
////            ),
////          ),
////          Container(
////            color: Colors.white,
////            child: ListTile(
////              leading: Icon(Icons.settings),
////              title: Text("设置"),
////              trailing: Icon(Icons.keyboard_arrow_right),
////            ),
////          )
//        ],
//      ),
//    );
//  }
//}
