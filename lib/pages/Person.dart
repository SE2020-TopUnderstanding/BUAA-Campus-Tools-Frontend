import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/FeedbackPage.dart';
import 'package:jiaowuassistent/pages/AboutUsPage.dart';
import 'package:jiaowuassistent/GlobalUser.dart';
import 'DIYPage.dart';
import 'package:provider/provider.dart';
import 'package:package_info/package_info.dart';

class PersonPage extends StatefulWidget {
  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  PackageInfo packageInfo;

  @override
  initState() {
    super.initState();
    getInfo();
  }

  Future<void> getInfo() async {
    PackageInfo.fromPlatform().then((PackageInfo temp) {
      setState(() {
        packageInfo = temp;
      });
    });
  }

  void editOnPressed() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('温馨提示'),
            content: Card(
              elevation: 0.0,
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        hintText: '请输入你的昵称',
                        filled: true,
                        fillColor: Colors.grey.shade50),
                    onChanged: (text) {
                      _name = text;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('取消'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  setState(() {});
                  Navigator.pop(context);
                },
                child: Text('确定'),
              ),
            ],
          );
        });
  }

  String _name = GlobalUser.name;

  @override
  Widget build(BuildContext context) {
    PageSelect page = Provider.of<PageSelect>(context);
    return Scaffold(
      appBar: AppBar(
//        backgroundColor: Colors.white,
        title: Text(' '),
        elevation: 0,
//        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(30, 10, 30, 30),
            color: Color(0xFF1565C0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text(
                      _name,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[100],
                        letterSpacing: 2,
                      ),
                    ),
                    subtitle: Container(
                      margin: const EdgeInsets.only(left: 1.5, top: 3.0),
                      child: Text(
                        "学号: ${GlobalUser.studentID}",
                        style: TextStyle(
                          color: Colors.grey[100],
                        ),
                      ),
                    ),
                  ),
                ),
                /*
                IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.edit, size: 15,),
                  onPressed: () {
                    editOnPressed();
                  },
                ),

                 */
                SizedBox(
                  width: 100,
                ),
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/head.png"),
                  radius: 40,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            child: ListTile(
              leading: Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Icon(
                  Icons.view_stream,
                  color: Color(0xFF1565C0),
                  size: 20,
                ),
              ),
              title: Text(
                "主页选择",
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                size: 20,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DIYPage()));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
            ),
//            decoration: BoxDecoration(border: Border(top: BorderSide(width: 1, color: Colors.grey[300]))),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: ListTile(
              leading: Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: Color(0xFF1565C0),
                    size: 20,
                  )),
              title: Text(
                "使用反馈",
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                size: 20,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeedbackPage()));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
            ),
//            decoration: BoxDecoration(border: Border(top: BorderSide(width: 1, color: Colors.grey[300]))),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: ListTile(
              leading: Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Icon(
                  Icons.help_outline,
                  color: Color(0xFF1565C0),
                  size: 20,
                ),
              ),
              title: Text(
                "关于我们",
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                size: 20,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutUsPage()));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
            ),
//            decoration: BoxDecoration(border: Border(top: BorderSide(width: 1, color: Colors.grey[300]))),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: MaterialButton(
              color: Color(0x99FFFFFF),
              minWidth: double.infinity,
              height: 50,
              child: Text(
                "退出登录",
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                GlobalUser.setIsLogin(false);
                page.setPage(1);
//                Navigator.pushAndRemoveUntil(
//                  context,
//                  MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
//                      (Route<dynamic> route) => false,
//                );
                Navigator.pushNamedAndRemoveUntil(
                    context, '/loginPage', ModalRoute.withName("/loginPage"));
                //Navigator.popUntil(context, ModalRoute.withName("/loginPage"));
              },
            ),
//            decoration: BoxDecoration(border: Border.all(width: 1)),
          )
        ],
      ),
    );
  }
}
