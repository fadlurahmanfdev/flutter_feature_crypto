import 'package:crypto_vault/src/data/repositories/crypto_vault_rsa_default.dart';
import 'package:crypto_vault/src/domain/crypto_vault_signature.dart';
import 'package:crypto_vault/src/domain/entities/crypto_key.dart';
import 'package:crypto_vault/src/domain/enums/crypto_vault_rsa_digest.dart';
import 'package:crypto_vault/src/domain/enums/crypto_vault_rsa_encoding.dart';

/// RSA asymmetric encryption and signing API.
abstract class CryptoVaultRsa implements CryptoVaultSignature {
  factory CryptoVaultRsa() = CryptoVaultRsaDefault;

  CryptoKey generateKey();

  String? encrypt({
    required String encodedPublicKey,
    required String plainText,
    required CryptoVaultRsaEncoding encoding,
    required CryptoVaultRsaDigest digest,
  });

  String? decrypt({
    required String encodedPrivateKey,
    required String encryptedText,
    required CryptoVaultRsaEncoding encoding,
    required CryptoVaultRsaDigest digest,
  });

  @override
  String? generateSignature({
    required String encodedPrivateKey,
    required String plainText,
  });

  @override
  bool verifySignature({
    required String encodedPublicKey,
    required String encodedSignature,
    required String plainText,
  });
}
