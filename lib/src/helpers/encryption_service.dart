import 'package:encrypt/encrypt.dart';
import '../helpers/globals.dart' as globals;

class EncryptionService {
  static final _key = Key.fromUtf8(globals.secretKey);
  static final _iv = IV.fromLength(
      16); // fixed IV for demo; consider using random IV per encryption

  static final _encrypter = Encrypter(AES(_key));

  static String encrypt(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  static String decrypt(String encryptedText) {
    final decrypted = _encrypter.decrypt64(encryptedText, iv: _iv);
    return decrypted;
  }
}
