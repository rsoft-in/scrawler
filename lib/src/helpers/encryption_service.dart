import 'package:encrypt/encrypt.dart';
import '../helpers/globals.dart' as globals;

class EncryptionService {
  static final _key = Key.fromUtf8(globals.secretKey);
  static final _iv = IV.fromLength(
      16); // fixed IV for demo; consider using random IV per encryption

  static final _encrypter = Encrypter(AES(_key));

  static String encrypt(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return '${_iv.base64}:${encrypted.base64}';
  }

  static String decrypt(String encryptedText) {
    final parts = encryptedText.split(':');
    final iv = IV.fromBase64(parts[0]);
    final encrypted = Encrypted.fromBase64(parts[1]);
    final decrypted = _encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }
}
