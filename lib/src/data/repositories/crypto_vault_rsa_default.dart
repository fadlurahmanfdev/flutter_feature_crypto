import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:crypto_vault/src/crypto_vault_rsa.dart';
import 'package:crypto_vault/src/data/internal/crypto_vault_safe_operations.dart';
import 'package:crypto_vault/src/data/internal/pointycastle_platform.dart';
import 'package:crypto_vault/src/domain/entities/crypto_key.dart';
import 'package:crypto_vault/src/domain/enums/crypto_vault_rsa_digest.dart';
import 'package:crypto_vault/src/domain/enums/crypto_vault_rsa_encoding.dart';
import 'package:encrypt/encrypt.dart' hide SecureRandom;
import 'package:pointycastle/export.dart' hide RSASigner;

class CryptoVaultRsaDefault
    with CryptoVaultSafeOperations
    implements CryptoVaultRsa {
  RSAEncoding _convertEncoding(CryptoVaultRsaEncoding encoding) {
    switch (encoding) {
      case CryptoVaultRsaEncoding.pkcs1:
        return RSAEncoding.PKCS1;
      case CryptoVaultRsaEncoding.oaep:
        return RSAEncoding.OAEP;
    }
  }

  RSADigest _convertDigest(CryptoVaultRsaDigest digest) {
    switch (digest) {
      case CryptoVaultRsaDigest.sha1:
        return RSADigest.SHA1;
      case CryptoVaultRsaDigest.sha256:
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
    keyGen.init(
      ParametersWithRandom(
        RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64),
        secureRandom,
      ),
    );
    final pair = CryptoUtils.generateRSAKeyPair(keySize: 2048);
    final publicKey = pair.publicKey as RSAPublicKey;
    final privateKey = pair.privateKey as RSAPrivateKey;
    return CryptoKey(
      publicKey: CryptoUtils.encodeRSAPublicKeyToPem(publicKey),
      privateKey: CryptoUtils.encodeRSAPrivateKeyToPem(privateKey),
    );
  }

  @override
  String? encrypt({
    required String encodedPublicKey,
    required String plainText,
    required CryptoVaultRsaEncoding encoding,
    required CryptoVaultRsaDigest digest,
  }) {
    return safeStringOperation('encrypt', () {
      final publicKey = RSAKeyParser().parse(encodedPublicKey) as RSAPublicKey;
      final encrypter = Encrypter(
        RSA(
          publicKey: publicKey,
          encoding: _convertEncoding(encoding),
          digest: _convertDigest(digest),
        ),
      );
      return base64.encode(encrypter.encrypt(plainText).bytes);
    });
  }

  @override
  String? decrypt({
    required String encodedPrivateKey,
    required String encryptedText,
    required CryptoVaultRsaEncoding encoding,
    required CryptoVaultRsaDigest digest,
  }) {
    return safeStringOperation('decrypt', () {
      final privateKey =
          RSAKeyParser().parse(encodedPrivateKey) as RSAPrivateKey;
      final encrypter = Encrypter(
        RSA(
          privateKey: privateKey,
          encoding: _convertEncoding(encoding),
          digest: _convertDigest(digest),
        ),
      );
      return encrypter.decrypt64(encryptedText);
    });
  }

  @override
  String? generateSignature({
    required String encodedPrivateKey,
    required String plainText,
  }) {
    return safeStringOperation('generateSignature', () {
      final privateKey =
          RSAKeyParser().parse(encodedPrivateKey) as RSAPrivateKey;
      final signer = RSASigner(RSASignDigest.SHA256, privateKey: privateKey);
      return signer.sign(Uint8List.fromList(plainText.codeUnits)).base64;
    });
  }

  @override
  bool verifySignature({
    required String encodedPublicKey,
    required String encodedSignature,
    required String plainText,
  }) {
    return safeBoolOperation('verifySignature', () {
      final publicKey = RSAKeyParser().parse(encodedPublicKey) as RSAPublicKey;
      final signer = RSASigner(RSASignDigest.SHA256, publicKey: publicKey);
      return signer.verify(
        Uint8List.fromList(plainText.codeUnits),
        Encrypted.fromBase64(encodedSignature),
      );
    });
  }
}
