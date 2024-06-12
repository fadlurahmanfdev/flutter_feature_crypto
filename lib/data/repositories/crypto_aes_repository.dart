import 'package:encrypt/encrypt.dart';

abstract class CryptoAESRepository {
  /// size must be 16, 24, 32
  String getKey(int size);

  String getIVKey();

  // TODO(dev): change key to encoded key
  String? encrypt({
    required String key,
    required String ivKey,
    required String plainText,
    AESMode mode = AESMode.cbc,
  });

  // TODO(dev): change key to encoded key
  String? decrypt({
    required String key,
    required String ivKey,
    required String encryptedText,
    AESMode mode = AESMode.cbc,
  });
}
