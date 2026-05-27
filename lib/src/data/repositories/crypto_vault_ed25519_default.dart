import 'dart:convert';

import 'package:crypto_vault/src/crypto_vault_ed25519.dart';
import 'package:crypto_vault/src/data/internal/crypto_vault_safe_operations.dart';
import 'package:crypto_vault/src/domain/entities/crypto_key.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart' as ed;

class CryptoVaultEd25519Default
    with CryptoVaultSafeOperations
    implements CryptoVaultEd25519 {
  ed.PrivateKey _privateKey(String encodedPrivateKey) {
    return ed.PrivateKey(base64.decode(encodedPrivateKey));
  }

  ed.PublicKey _publicKeyFromPrivateKey(String encodedPrivateKey) {
    return ed.public(_privateKey(encodedPrivateKey));
  }

  ed.PublicKey _publicKey(String encodedPublicKey) {
    return ed.PublicKey(base64.decode(encodedPublicKey));
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
    return safeStringOperation('generateSignature', () {
      return base64.encode(
        ed.sign(_privateKey(encodedPrivateKey), utf8.encode(plainText)),
      );
    });
  }

  @override
  bool verifySignatureUsingPrivateKey({
    required String encodedPrivateKey,
    required String encodedSignature,
    required String plainText,
  }) {
    return safeBoolOperation('verifySignatureUsingPrivateKey', () {
      return ed.verify(
        _publicKeyFromPrivateKey(encodedPrivateKey),
        utf8.encode(plainText),
        base64.decode(encodedSignature),
      );
    });
  }

  @override
  bool verifySignature({
    required String encodedPublicKey,
    required String encodedSignature,
    required String plainText,
  }) {
    return safeBoolOperation('verifySignature', () {
      return ed.verify(
        _publicKey(encodedPublicKey),
        utf8.encode(plainText),
        base64.decode(encodedSignature),
      );
    });
  }
}
