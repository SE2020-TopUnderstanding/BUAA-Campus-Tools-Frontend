import 'package:encrypt/encrypt.dart';

class Encrypt {
  static String encrypt(String str) {
    try {
      final key = Key.fromUtf8('1234567812345678');
      final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
      final encrypted = encrypter.encrypt(str);
      return Uri.encodeComponent(encrypted.base64);
    } catch (err) {
      print("aes encode error:$err");
      return str;
    }
  }

  static String encrypt2(String str) {
    try {
      final key = Key.fromUtf8('1234567812345678');
      final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
      final encrypted = encrypter.encrypt(str);
      return encrypted.base64;
    } catch (err) {
      print("aes encode error:$err");
      return str;
    }
  }
}
