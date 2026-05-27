import 'package:crypto_vault/src/data/repositories/crypto_vault_ed25519_default.dart';
import 'package:crypto_vault/src/domain/crypto_vault_signature.dart';
import 'package:crypto_vault/src/domain/entities/crypto_key.dart';

/// Ed25519 signing API.
abstract class CryptoVaultEd25519 implements CryptoVaultSignature {
  factory CryptoVaultEd25519() = CryptoVaultEd25519Default;

  CryptoKey generateKey();

  @override
  String? generateSignature({
    required String encodedPrivateKey,
    required String plainText,
  });

  bool verifySignatureUsingPrivateKey({
    required String encodedPrivateKey,
    required String encodedSignature,
    required String plainText,
  });

  @override
  bool verifySignature({
    required String encodedPublicKey,
    required String encodedSignature,
    required String plainText,
  });
}
