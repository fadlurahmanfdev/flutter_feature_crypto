import 'dart:math' hide log;

import 'package:crypto_vault/src/crypto_vault_aes.dart';
import 'package:crypto_vault/src/data/internal/crypto_vault_safe_operations.dart';
import 'package:crypto_vault/src/domain/exceptions/crypto_vault_exception.dart';
import 'package:encrypt/encrypt.dart';

class CryptoVaultAesDefault
    with CryptoVaultSafeOperations
    implements CryptoVaultAes {
  String _generateRandomKey(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(Random.secure().nextInt(chars.length)),
      ),
    );
  }

  @override
  String getKey(int size) {
    if (size == 16 || size == 24 || size == 32) {
      return _generateRandomKey(size);
    }
    throw const CryptoVaultException(
      code: 'SIZE_NOT_VALID',
      message: 'Size must be 16/24/32',
    );
  }

  @override
  String getIVKey() => _generateRandomKey(16);

  @override
  String? encrypt({
    required String key,
    required String ivKey,
    required String plainText,
    AESMode mode = AESMode.cbc,
  }) {
    return safeStringOperation('encrypt', () {
      final encrypter = Encrypter(AES(Key.fromUtf8(key), mode: mode));
      final iv = IV.fromUtf8(ivKey);
      return encrypter.encrypt(plainText, iv: iv).base64;
    });
  }

  @override
  String? decrypt({
    required String key,
    required String ivKey,
    required String encryptedText,
    AESMode mode = AESMode.cbc,
  }) {
    return safeStringOperation('decrypt', () {
      final encrypter = Encrypter(AES(Key.fromUtf8(key), mode: mode));
      final iv = IV.fromUtf8(ivKey);
      return encrypter.decrypt(Encrypted.fromBase64(encryptedText), iv: iv);
    });
  }
}
