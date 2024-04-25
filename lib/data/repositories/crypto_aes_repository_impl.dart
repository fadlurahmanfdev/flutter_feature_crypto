import 'dart:developer';
import 'dart:math' hide log;

import 'package:encrypt/encrypt.dart';
import 'package:library_core_crypto/data/dto/exception/core_crypto_exception.dart';
import 'package:library_core_crypto/data/repositories/crypto_aes_repository.dart';

class CryptoAESRepositoryImpl extends CryptoAESRepository {
  String generateRandomKey(int length) {
    const mChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => mChars.codeUnitAt(Random.secure().nextInt(mChars.length)),
      ),
    );
  }

  @override
  String getKey(int size) {
    if (size == 16 || size == 24 || size == 32) {
      return generateRandomKey(size);
    }
    throw CoreCryptoException(
      code: 'SIZE_NOT_VALID',
      message: 'Size must be 16/24/32',
    );
  }

  @override
  String getIVKey() {
    return generateRandomKey(16);
  }

  @override
  String? encrypt({
    required String key,
    required String ivKey,
    required String plainText,
  }) {
    try {
      final encrypter = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.cbc));
      final iv = IV.fromUtf8(ivKey);
      return encrypter.encrypt(plainText, iv: iv).base64;
    } on Error catch (e, s) {
      log("failed encrypt on error encrypt: $e, $s");
      return null;
    } on Exception catch (e, s) {
      log("failed encrypt on exception encrypt: $e, $s");
      return null;
    }
  }

  @override
  String? decrypt({
    required String key,
    required String ivKey,
    required String encryptedText,
  }) {
    try {
      final encrypter = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.cbc));
      final iv = IV.fromUtf8(ivKey);
      return encrypter.decrypt(Encrypted.fromBase64(encryptedText), iv: iv);
    } on Error catch (e, s) {
      log("failed decrypt on error encrypt: $e, $s");
      return null;
    } on Exception catch (e, s) {
      log("failed decrypt on exception encrypt: $e, $s");
      return null;
    }
  }
}
