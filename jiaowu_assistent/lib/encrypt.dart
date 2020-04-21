import 'dart:convert';
class Encrypt{
  static String encrypt(String str){
    //小写字母a=z z=a b=y y=b以此类推
    //大写字母E=0 F=1 J=2 H=3 I=4 J=5 K=6 L=7 M=8 N=9
    //数字0=N 1=M 2=L 3=K 4=J 5=I 6=H 7=J 8=F 9=E
    String encrypted='';
    List<int> listInt = AsciiEncoder().convert(str);
    for(int i=0; i<str.length; i++){
      int charInt = listInt[i];
      int encryptedInt;
      String encryptedChar;
      if((charInt >= 97) && (charInt <= 122)){
        encryptedInt = 122-(charInt-97);
      } else if((charInt>=69) && (charInt<=78)){
        encryptedInt = charInt-21;
      } else if((charInt>=48) && (charInt<=57)){
        encryptedInt = 78-charInt+48;
      } else{
        encryptedInt = charInt;
      }
      encryptedChar = AsciiDecoder().convert([encryptedInt]);
      encrypted = encrypted + encryptedChar;
    }
    return encrypted;
  }
}