import 'dart:developer';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' hide SecureRandom;
import 'package:flutter_core_crypto/data/dto/model/crypto_key.dart';
import 'package:flutter_core_crypto/data/repositories/crypto_rsa_repository.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';
import "package:pointycastle/export.dart" hide RSASigner;

class CryptoRSARepositoryImpl extends CryptoRSARepository {
  @override
  CryptoKey generateKey() {
    final secureRandom = SecureRandom('Fortuna')
      ..seed(
          KeyParameter(Platform.instance.platformEntropySource().getBytes(32)));
    final keyGenerator = KeyGenerator('RSA');
    final rsaParams = RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 64);
    final paramsWithRnd = ParametersWithRandom(rsaParams, secureRandom);
    keyGenerator.init(paramsWithRnd);
    final pair = keyGenerator.generateKeyPair();
    final public = pair.publicKey as RSAPublicKey;
    final private = pair.privateKey as RSAPrivateKey;
    final encodedPublic = RsaKeyHelper().encodePublicKeyToPemPKCS1(public);
    final encodedPrivate = RsaKeyHelper().encodePrivateKeyToPemPKCS1(private);
    return CryptoKey(publicKey: encodedPublic, privateKey: encodedPrivate);
  }

  @override
  String? encrypt({
    required String encodedPublicKey,
    required String plainText,
  }) {
    try {
      final publicKey = RSAKeyParser().parse(encodedPublicKey) as RSAPublicKey;
      final encrypter = Encrypter(RSA(publicKey: publicKey));
      return encrypter.encrypt(plainText).base64;
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
  }) {
    try {
      final privateKey =
          RSAKeyParser().parse(encodedPrivateKey) as RSAPrivateKey;
      final encrypter = Encrypter(RSA(privateKey: privateKey));
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
