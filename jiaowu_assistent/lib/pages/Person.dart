import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiaowuassistent/pages/HelpCenterPage.dart';
import 'package:jiaowuassistent/GlobalUser.dart';
import 'package:jiaowuassistent/pages/LoginPage.dart';
import 'DIYPage.dart';
import 'package:provider/provider.dart';

class PersonPage extends StatefulWidget {
  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        //backgroundColor: Colors.white,
        title: Text('个人中心'),
        elevation: 0,
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(32.0),
            color: Colors.white,
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
                      ),
                    ),
                    subtitle: Text("学号:${GlobalUser.studentID}"),
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
            color: Colors.white,
            child: ListTile(
              leading: Icon(
                Icons.help_outline,
                size: 20,
              ),
              title: Text(
                "帮助中心",
                style: TextStyle(fontSize: 20),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                size: 20,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HelpCenterPage()));
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: Icon(
                Icons.view_stream,
                size: 20,
              ),
              title: Text(
                "主页选择",
                style: TextStyle(fontSize: 20),
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                size: 20,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DIYPage()));
              },
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: ListTile(
              title: Text(
                "退出登录",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              onTap: () {
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
            decoration: BoxDecoration(border: Border.all(width: 1)),
          )
        ],
      ),
    );
  }
}
