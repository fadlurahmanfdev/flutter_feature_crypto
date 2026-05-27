import 'package:crypto_vault/src/data/repositories/crypto_vault_ec_default.dart';
import 'package:crypto_vault/src/domain/entities/crypto_key.dart';

/// Elliptic-curve key exchange (X25519) API.
abstract class CryptoVaultEc {
  factory CryptoVaultEc() = CryptoVaultEcDefault;

  Future<CryptoKey> generateKeyPair({String? curve});

  Future<String> generateSharedSecret({
    required String encodedPrivateKey,
    required String peerEncodedPublicKey,
  });
}
