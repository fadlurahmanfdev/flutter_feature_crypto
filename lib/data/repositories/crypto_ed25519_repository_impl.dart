import 'dart:convert';
import 'dart:developer';

import 'package:ed25519_edwards/ed25519_edwards.dart' as ed;
import 'package:library_core_crypto/data/dto/model/crypto_key.dart';
import 'package:library_core_crypto/data/repositories/crypto_ed25519_repository.dart';

class CryptoED25519RepositoryIml extends CryptoED25519Repository {
  ed.PrivateKey getPrivateKey(String encodedPrivateKey) {
    return ed.PrivateKey(base64.decode(encodedPrivateKey));
  }

  ed.PublicKey getPublicKey(String encodedPrivateKey) {
    return ed.public(getPrivateKey(encodedPrivateKey));
  }

  @override
  CryptoKey generateKey() {
    final key = ed.generateKey();
    return CryptoKey(
      publicKey: base64.encode(key.publicKey.bytes),
      privateKey: base64.encode(key.privateKey.bytes),
    );
  }

  @override
  String? generateSignature({
    required String encodedPrivateKey,
    required String plainText,
  }) {
    try {
      final privateKey = getPrivateKey(encodedPrivateKey);
      return base64.encode(ed.sign(privateKey, utf8.encode(plainText)));
    } on Error catch (e, s) {
      log("failed generateSignature on error: $e, $s");
      return null;
    } on Exception catch (e, s) {
      log("failed generateSignature on exception: $e, $s");
      return null;
    }
  }

  bool verifySignature({
    required String encodedPrivateKey,
    required String encodedSignature,
    required String plainText,
  }) {
    try {
      final publicKey = getPublicKey(encodedPrivateKey);
      return ed.verify(
        publicKey,
        utf8.encode(plainText),
        base64.decode(encodedSignature),
      );
    } on Error catch (e, s) {
      log("failed verifySignature on error: $e, $s");
      return false;
    } on Exception catch (e, s) {
      log("failed verifySignature on exception: $e, $s");
      return false;
    }
  }
}
