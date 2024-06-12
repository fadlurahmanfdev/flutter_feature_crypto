import 'dart:developer';

import 'crypto_usecase.dart';
import 'package:flutter_core_crypto/flutter_core_crypto.dart';

class CryptoUseCaseImpl extends CryptoUseCase {
  CryptoAESRepository cryptoAESRepository;
  CryptoRSARepository cryptoRSARepository;
  CryptoED25519Repository cryptoED25519Repository;

  CryptoUseCaseImpl({
    required this.cryptoAESRepository,
    required this.cryptoRSARepository,
    required this.cryptoED25519Repository,
  });

  @override
  void encryptAndDecryptAES() {
    final key = cryptoAESRepository.getKey(32);
    log("AES KEY: $key");
    final ivKey = cryptoAESRepository.getIVKey();
    log("IV KEY: $ivKey");
    const plainText = 'Passw0rd!';
    log("PLAIN TEXT: $plainText");
    final encrypted = cryptoAESRepository.encrypt(key: key, ivKey: ivKey, plainText: plainText);
    log("ENCRYPTED TEXT: $encrypted");
    if (encrypted != null) {
      final decrypted = cryptoAESRepository.decrypt(key: key, ivKey: ivKey, encryptedText: encrypted);
      log("DECRYPTED TEXT: $decrypted");
    }
  }

  @override
  void encryptAndDecryptRSA() {
    const plainText = "Passw0rd!";
    log("PLAIN TEXT: $plainText");
    final key = cryptoRSARepository.generateKey();
    log("RSA PRIVATE KEY: ${key.privateKey}");
    log("RSA PUBLIC KEY: ${key.publicKey}");
    final encrypted = cryptoRSARepository.encrypt(
      encodedPublicKey: key.publicKey,
      plainText: plainText,
      encoding: CoreCrytoRSAEncoding.pkcs1,
      digest: CoreCryptoRSADigest.sha256,
    );
    log("ENCRYPTED TEXT: $encrypted");
    if (encrypted != null) {
      final decrypted = cryptoRSARepository.decrypt(
        encodedPrivateKey: key.privateKey,
        encryptedText: encrypted,
        encoding: CoreCrytoRSAEncoding.pkcs1,
        digest: CoreCryptoRSADigest.sha256,
      );
      log("DECRYPTED TEXT: $decrypted");
    }

    final signature = cryptoRSARepository.generateSignature(encodedPrivateKey: key.privateKey, plainText: plainText);
    log("SIGNATURE: $signature");
    if (signature != null) {
      final isSignatureVerified = cryptoRSARepository.verifySignature(
        encodedPublicKey: key.publicKey,
        encodedSignature: signature,
        plainText: plainText,
      );
      log("IS SIGNATURE VERIFIED: $isSignatureVerified");
    }
  }

  @override
  void encryptAndDecryptED25519() {
    const plainText = "Passw0rd!";
    log("PLAIN TEXT: $plainText");
    final key = cryptoED25519Repository.generateKey();
    log("PRIVATE KEY: ${key.privateKey}");
    log("PUBLIC KEY: ${key.publicKey}");
    final signature =
        cryptoED25519Repository.generateSignature(encodedPrivateKey: key.privateKey, plainText: plainText);
    log("SIGNATURE: $signature");
    if (signature != null) {
      final isSignatureVerified = cryptoED25519Repository.verifySignature(
        encodedPublicKey: key.publicKey,
        encodedSignature: signature,
        plainText: plainText,
      );
      log("IS SIGNATURE VERIFIED: $isSignatureVerified");
    }
  }
}
