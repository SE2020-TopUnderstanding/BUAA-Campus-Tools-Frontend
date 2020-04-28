import 'package:encrypt/encrypt.dart';

class Encrypt {
  static String encrypt(String str) {
    try {
      print(str);
      final key = Key.fromUtf8('2020042820200428');
      final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
      final encrypted = encrypter.encrypt(str);
      print('加密后：${encrypted.base64}');
      return encrypted.base64;
    } catch (err) {
      print("aes encode error:$err");
      return str;
    }
  }
}
