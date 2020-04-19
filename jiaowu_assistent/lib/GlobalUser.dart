
class GlobalUser{
  String account;//统一认证账号
  String password;//密码
  int student_id;//学号
  int choice = 1;//主页选择,1课表，2成绩,3课程中心,默认课表

  GlobalUser(
      this.account,
      this.password,
      this.student_id
      );

  void setChoice(int type){
    choice = type;
  }
}