import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' hide SecureRandom;
import 'package:flutter_core_crypto/data/dto/model/crypto_key.dart';
import 'package:flutter_core_crypto/data/enum/rsa_digest.dart';
import 'package:flutter_core_crypto/data/enum/rsa_encoding.dart';
import 'package:flutter_core_crypto/data/repositories/crypto_rsa_repository.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';
import "package:pointycastle/export.dart" hide RSASigner;
import 'package:basic_utils/basic_utils.dart';

class CryptoRSARepositoryImpl extends CryptoRSARepository {
  RSAEncoding convertEncoding(CoreCrytoRSAEncoding encoding) {
    switch (encoding) {
      case CoreCrytoRSAEncoding.pkcs1:
        return RSAEncoding.PKCS1;
      case CoreCrytoRSAEncoding.oaep:
        return RSAEncoding.OAEP;
    }
  }

  RSADigest convertDigest(CoreCryptoRSADigest digest) {
    switch (digest) {
      case CoreCryptoRSADigest.sha1:
        return RSADigest.SHA1;
      case CoreCryptoRSADigest.sha256:
        return RSADigest.SHA256;
    }
  }

  @override
  CryptoKey generateKey() {
    final secureRandom = SecureRandom('Fortuna')
      ..seed(
        KeyParameter(Platform.instance.platformEntropySource().getBytes(32)),
      );
    final keyGen = RSAKeyGenerator();
    keyGen.init(ParametersWithRandom(
      RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64),
      secureRandom,
    ));
    final pair = CryptoUtils.generateRSAKeyPair(keySize: 2048);
    final publicKey = pair.publicKey as RSAPublicKey;
    final privateKey = pair.privateKey as RSAPrivateKey;
    final encodedPublicKey = CryptoUtils.encodeRSAPublicKeyToPem(publicKey);
    final encodedPrivateKey = CryptoUtils.encodeRSAPrivateKeyToPem(privateKey);
    return CryptoKey(
      publicKey: encodedPublicKey,
      privateKey: encodedPrivateKey,
    );
  }

  @override
  String? encrypt({
    required String encodedPublicKey,
    required String plainText,
    required CoreCrytoRSAEncoding encoding,
    required CoreCryptoRSADigest digest,
  }) {
    try {
      final publicKey = RSAKeyParser().parse(encodedPublicKey) as RSAPublicKey;
      final encrypter = Encrypter(RSA(
          publicKey: publicKey,
          encoding: convertEncoding(encoding),
        digest: convertDigest(digest),
      ));
      return base64.encode(encrypter.encrypt(plainText).bytes);
    } on Error catch (e, s) {
      log("failed encrypt on error: $e, $s");
      return null;
    } on Exception catch (e, s) {
      log("failed encrypt on exception: $e, $s");
      return null;
    }
  }

  @override
  String? decrypt({
    required String encodedPrivateKey,
    required String encryptedText,
    required CoreCrytoRSAEncoding encoding,
    required CoreCryptoRSADigest digest,
  }) {
    try {
      final privateKey =
          RSAKeyParser().parse(encodedPrivateKey) as RSAPrivateKey;
      final encrypter = Encrypter(RSA(
        privateKey: privateKey,
        encoding: convertEncoding(encoding),
        digest: convertDigest(digest),
      ));
      return encrypter.decrypt64(encryptedText);
    } on Error catch (e, s) {
      log("failed decrypt on error: $e, $s");
      return null;
    } on Exception catch (e, s) {
      log("failed decrypt on exception: $e, $s");
      return null;
    }
  }

  @override
  String? generateSignature({
    required String encodedPrivateKey,
    required String plainText,
  }) {
    try {
      final privateKey =
          RSAKeyParser().parse(encodedPrivateKey) as RSAPrivateKey;
      final signer = RSASigner(RSASignDigest.SHA256, privateKey: privateKey);
      return signer.sign(Uint8List.fromList(plainText.codeUnits)).base64;
    } on Error catch (e, s) {
      log("failed generateSignature on error: $e, $s");
      return null;
    } on Exception catch (e, s) {
      log("failed generateSignature on exception: $e, $s");
      return null;
    }
  }

  @override
  bool verifySignature({
    required String encodedPublicKey,
    required String encodedSignature,
    required String plainText,
  }) {
    try {
      final publicKey = RSAKeyParser().parse(encodedPublicKey) as RSAPublicKey;
      final signer = RSASigner(RSASignDigest.SHA256, publicKey: publicKey);
      return signer.verify(Uint8List.fromList(plainText.codeUnits),
          Encrypted.fromBase64(encodedSignature));
    } on Error catch (e, s) {
      log("failed verifySignature on error: $e, $s");
      return false;
    } on Exception catch (e, s) {
      log("failed verifySignature on exception: $e, $s");
      return false;
    }
  }
}
